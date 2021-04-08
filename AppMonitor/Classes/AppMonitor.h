//
//  MyRunLoop.h
//  Prepare
//
//  Created by GL on 2021/3/31.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSUInteger, AppMonitorOptions) {
    AppMonitorCPUUsage = 1 << 0,
    AppMonitorMainRunLoopStuck = 1 << 1,
};

@interface AppMonitor : NSObject

+ (instancetype)sharedInstance;

- (void)startMointor:(AppMonitorOptions)options;

- (void)stopMointor:(AppMonitorOptions)options;

@end

NS_ASSUME_NONNULL_END
