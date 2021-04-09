//
//  AMConfig.h
//  AppMonitor_Example
//
//  Created by GL on 2021/4/9.
//  Copyright © 2021 StoneStoneStone. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// 可以用来配置CPU使用警告线和卡顿容忍度
@interface AMConfig : NSObject

+ (instancetype)sharedInstance;

// Within 0~100. Default is 80%
@property (nonatomic, assign) NSUInteger usagePercent;

// default is 88ms.
@property (nonatomic, assign) NSUInteger stuckDuration;

@end

NS_ASSUME_NONNULL_END
