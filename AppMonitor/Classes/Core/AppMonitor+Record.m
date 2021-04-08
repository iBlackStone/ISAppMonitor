//
//  AppMonitor+Record.m
//  Prepare
//
//  Created by GL on 2021/4/2.
//

#import "AppMonitor+Record.h"
#import "AMDB+Stack.h"
#import "AMDB+Func.h"

@implementation AppMonitor (Record)

- (void)recordStackInfo:(AMStackModel *)model {
    if (!model) {
        return;
    }
    [[AMDB sharedInstance] insertStackTableWith:model];
}

- (void)clearStackInfo {
    [[AMDB sharedInstance] clearStackTable];
}

- (void)recordFuncInfo:(AMFuncCostModel *)model {
    if (!model) {
        return;
    }
    [[AMDB sharedInstance] inserFuncTableWith:model];
}

- (void)clearFuncInfo {
    [[AMDB sharedInstance] clearFuncTable];
}

@end
