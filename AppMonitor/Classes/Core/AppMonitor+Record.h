//
//  AppMonitor+Record.h
//  Prepare
//
//  Created by GL on 2021/4/2.
//

#import "AppMonitor.h"
#import "AMStackModel.h"
#import "AMFuncCostModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppMonitor (Record)

- (void)recordStackInfo:(AMStackModel *)model;
- (void)clearStackInfo;

- (void)recordFuncInfo:(AMFuncCostModel *)model;
- (void)clearFuncInfo;

@end

NS_ASSUME_NONNULL_END
