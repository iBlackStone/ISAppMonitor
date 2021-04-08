//
//  MonitorCPUInfo.m
//  Prepare
//
//  Created by GL on 2021/4/2.
//

#import "AMStackMaker.h"
#import "AMMacro.h"
#import "AMStackAnalyzing.h"
#import "AppMonitor+CPU.h"

@implementation AMStackMaker

+ (AMStackModel *)makeForCPUHighUsage {
    // prepare parameters container
    thread_act_array_t threads; // empty array
    mach_msg_type_number_t threadCount = 0; //
    const task_t thisTask = mach_task_self();
    
    // 以上的参数都是为该函数准备，获取当前运行的所有线程
    kern_return_t kr = task_threads(thisTask, &threads, &threadCount);
    if (kr != KERN_SUCCESS) {
        // 获取数据失败
        return nil;
    }
    
    for (int i = 0; i < threadCount; i++) {
        thread_info_data_t threadInfo;
        mach_msg_type_number_t threadInfoCount = THREAD_INFO_MAX;
        
        kern_return_t kr = thread_info((thread_act_t)threads[i], THREAD_BASIC_INFO, (thread_info_t)threadInfo, &threadInfoCount);
        if (kr == KERN_SUCCESS) {
            thread_basic_info_t threadBaseInfo = (thread_basic_info_t)threadInfo;
            // 线程为非空线程进入
            if (!(threadBaseInfo->flags & TH_FLAGS_IDLE)) {
                integer_t cpuUsage = threadBaseInfo->cpu_usage / 10; // cpu_usage(0...1000)，除10转为百分比
                if (cpuUsage > CPU_WARNING_USAGE) {
                    // 创建model，记录堆栈并返回
                    AMStackModel *model = [AMStackModel new];
                    model.wholeStackString = stackInfoInThread(threads[i]);
                    return model;
                }
            }
        }
    }
    
    return nil;
}

+ (AMStackModel *)makeForThread:(thread_t)thread{
    NSString *retStr = stackInfoInThread(thread);
    assert(vm_deallocate(mach_task_self(), (vm_address_t)thread, 1 * sizeof(thread_t)) == KERN_SUCCESS);
    AMStackModel *model = [AMStackModel new];
    model.wholeStackString = retStr;
    model.isStucked = YES;
    return  model;
}

@end
