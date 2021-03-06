//
//  AppMonitor+CPU.h
//  Prepare
//
//  Created by GL on 2021/4/2.
//

#import "AppMonitor.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppMonitor (CPU)

- (void)startCPUMonitor;

- (void)stopCPUMonitor;

- (BOOL)cpuMonitorRunning;

@end

NS_ASSUME_NONNULL_END
