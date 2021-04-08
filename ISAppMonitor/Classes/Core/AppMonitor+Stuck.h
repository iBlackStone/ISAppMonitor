//
//  AppMonitor+Stuck.h
//  Prepare
//
//  Created by GL on 2021/4/2.
//

#import "AppMonitor.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppMonitor (Stuck)

- (void)startStuckMonitor;

- (void)stopStuckMonitor;

- (BOOL)stuckMonitorRunning;

@end

NS_ASSUME_NONNULL_END
