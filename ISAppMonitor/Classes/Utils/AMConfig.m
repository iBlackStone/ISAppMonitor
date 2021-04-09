//
//  AMConfig.m
//  AppMonitor_Example
//
//  Created by GL on 2021/4/9.
//  Copyright © 2021 StoneStoneStone. All rights reserved.
//

#import "AMConfig.h"

@implementation AMConfig

+ (instancetype)sharedInstance {
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _usagePercent = 80;
        _stuckDuration = 88;
    }
    return self;
}

- (void)setUsagePercent:(NSUInteger)usagePercent {
    _usagePercent = usagePercent % 100;
}

@end
