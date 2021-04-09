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

// 本类只负责本地记录，上传需求比较灵活，此处不再封装
@interface AppMonitor (Record)

- (void)recordStackInfo:(AMStackModel *)model;
- (void)clearStackInfo;

- (void)recordFuncInfo:(AMFuncCostModel *)model;
- (void)clearFuncInfo;

@end

NS_ASSUME_NONNULL_END
