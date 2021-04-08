//
//  ThreadStack.h
//  Prepare
//
//  Created by GL on 2021/4/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AMStackAnalyzing : NSObject

extern NSString* stackInfoInThread(thread_t pthread);

@end

NS_ASSUME_NONNULL_END
