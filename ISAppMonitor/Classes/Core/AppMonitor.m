//
//  MyRunLoop.m
//  Prepare
//
//  Created by GL on 2021/3/31.
//

#import "AppMonitor.h"
#import "AMStackMaker.h"
#import "AppMonitor+Record.h"
#import "AppMonitor+CPU.h"
#import "AppMonitor+Stuck.h"
#import "AMMacro.h"
#import "AMConfig.h"

static mach_port_t _mainThreadId;

@interface AppMonitor (){
    int timeoutCount;
    CFRunLoopObserverRef runLoopObserver;
    
    @public
    dispatch_semaphore_t semaphore;
    CFRunLoopActivity activity;
}

@property (nonatomic, assign) BOOL isStuckMonitoring;
@property (nonatomic, assign) BOOL isCPUMonitoring;

@property (nonatomic, strong) NSTimer *timerForCPU;

@end

@implementation AppMonitor

+ (void)load {
    _mainThreadId = mach_thread_self();
}

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static id instance;
    dispatch_once(&onceToken, ^{
        instance = [[AppMonitor alloc] init];
    });
    return instance;
}

#pragma mark - common API

- (void)startMointor:(AppMonitorOptions)options {
    if (options & AppMonitorCPUUsage) {
        [self startCPUMonitor];
    }
    if (options & AppMonitorMainRunLoopStuck) {
        [self startStuckMonitor];
    }
}

- (void)stopMointor:(AppMonitorOptions)options {
    if (options & AppMonitorCPUUsage) {
        [self stopCPUMonitor];
    }
    if (options & AppMonitorMainRunLoopStuck) {
        [self stopStuckMonitor];
    }
}

#pragma mark - Stuck
- (void)startStuckMonitor {
    self.isStuckMonitoring = YES;
    if (runLoopObserver) {
        // 说明已经有循环在子线程开始执行了
        return;;
    }
    
    semaphore = dispatch_semaphore_create(0);
    
    // creat observer
    CFRunLoopObserverContext context = {0, (__bridge void *)self, NULL, NULL};
    runLoopObserver = CFRunLoopObserverCreate(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, 0, &runLoopObserverCallBack, &context);
    CFRunLoopAddObserver(CFRunLoopGetMain(), runLoopObserver, kCFRunLoopCommonModes);
    
    // 创建子线程监控卡顿
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 子线程开启一个持续的loop来进行监控
        while (YES) {
            NSInteger dura = [AMConfig sharedInstance].stuckDuration;
            long semaphoreWait = dispatch_semaphore_wait(self->semaphore, dispatch_time(DISPATCH_TIME_NOW, dura * NSEC_PER_MSEC));
            if (semaphoreWait != 0) {
                if (!self->runLoopObserver) {
                    self->timeoutCount = 0;
                    self->semaphore = 0;
                    self->activity = 0;
                    return;
                }
                if (self->activity == kCFRunLoopBeforeSources || self->activity == kCFRunLoopAfterWaiting) {
                    if (++self->timeoutCount < 3) {
                        continue;
                    }
                    
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                        AMStackModel *model = [AMStackMaker makeForThread:_mainThreadId];
                        [self recordStackInfo:model];
                    });
                } // end Activity
            } // end semaphore wait
            self->timeoutCount = 0;
        } // end while
    });
}

- (void)stopStuckMonitor{
    if (self.isStuckMonitoring == NO) {
        return;
    }
    
    self.isStuckMonitoring = NO;
    if (!runLoopObserver) {
        return;
    }
    CFRunLoopRemoveObserver(CFRunLoopGetMain(), runLoopObserver, kCFRunLoopCommonModes);
    CFRelease(runLoopObserver);
    runLoopObserver = NULL;
}

static void runLoopObserverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
    AppMonitor *object = (__bridge  AppMonitor*)info;
    
    // record
    object->activity = activity;
    
    // send signal
    dispatch_semaphore_t semaphore = object->semaphore;
    dispatch_semaphore_signal(semaphore);
}

- (BOOL)stuckMonitorRunning {
    return self.isStuckMonitoring;
}

#pragma mark - CPU
- (void)startCPUMonitor {
    self.isCPUMonitoring = YES;
    self.timerForCPU = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(tryFindCPUHighUsage) userInfo:nil repeats:YES];
}

- (void)stopCPUMonitor {
    if (self.isCPUMonitoring == NO) {
        return;
    }
    self.isCPUMonitoring = NO;
    [self.timerForCPU invalidate];
}

- (void)tryFindCPUHighUsage {
    AMStackModel *model = [AMStackMaker makeForCPUHighUsage];
    if (model) {
        // need record model
        [self recordStackInfo:model];
    }
}

- (BOOL)cpuMonitorRunning {
    return self.isCPUMonitoring;
}

@end
