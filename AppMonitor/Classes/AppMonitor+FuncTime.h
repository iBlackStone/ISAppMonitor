//
//  AppMonitor+FuncTime.h
//  Prepare
//
//  Created by GL on 2021/4/4.
//

#import "AppMonitor.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppMonitor (FuncTime)

- (void)start;
- (void)startWithMaxDepth:(int)depth;
- (void)startWithMinTimeCost:(double)ms;
- (void)startWithMaxDepth:(int)depth minTimeCost:(double)ms;

- (void)saveToDB;

- (void)stop;
- (void)clearMemory;

@end

NS_ASSUME_NONNULL_END
