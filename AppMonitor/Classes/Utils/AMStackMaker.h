//
//  MonitorCPUInfo.h
//  Prepare
//
//  Created by GL on 2021/4/2.
//

#import <Foundation/Foundation.h>
#import "AMStackModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AMStackMaker : NSObject

+ (AMStackModel *)makeForCPUHighUsage;

+ (AMStackModel *)makeForThread:(thread_t)thread;

@end

NS_ASSUME_NONNULL_END
