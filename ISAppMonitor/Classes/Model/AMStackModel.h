//
//  ThreadStackModel.h
//  Prepare
//
//  Created by GL on 2021/4/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AMStackModel : NSObject

@property (nonatomic, copy) NSString *wholeStackString;

@property (nonatomic, assign) BOOL isStucked;

@property (nonatomic, assign) NSTimeInterval date;

@end

NS_ASSUME_NONNULL_END
