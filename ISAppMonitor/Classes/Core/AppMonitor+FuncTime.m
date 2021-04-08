//
//  AppMonitor+FuncTime.m
//  Prepare
//
//  Created by GL on 2021/4/4.
//

#import "AppMonitor+FuncTime.h"
#import "AMFuncCore.h"
#import "AMFuncCostModel.h"
#import "AppMonitor+Record.h"
#import <objc/runtime.h>

@implementation AppMonitor (FuncTime)

- (void)start {
    CallTraceStart();
}

- (void)startWithMaxDepth:(int)depth {
    CallConfigMaxDepth(depth);
    [self start];
}

- (void)startWithMinTimeCost:(double)ms {
    CallConfigMinTime(ms * 1000);
    [self start];
}
- (void)startWithMaxDepth:(int)depth minTimeCost:(double)ms {
    CallConfigMaxDepth(depth);
    CallConfigMinTime(ms * 1000);
    [self start];
}

- (void)saveToDB {
    NSMutableString *mStr = [NSMutableString new];
    NSArray<AMFuncCostModel*> *arr = [self loadExistRecords];
    for (AMFuncCostModel *model in arr) {
        model.path = [NSString stringWithFormat:@"[%@ %@]", model.className, model.methodName];
        [self recursionModel:model withLog:mStr];
    }
    NSLog(@"\n%@", mStr);
}

- (void)stop {
    CallTraceStop();
}

- (void)clearMemory{
    ClearCallRecords();
}


#pragma mark -
- (NSArray<AMFuncCostModel*>*)loadExistRecords {
    NSMutableArray<AMFuncCostModel*> *retArr = [NSMutableArray array];
    
    int recordCount = 0;
    CallRecord *records = GetCallRecords(&recordCount);
    
    for (int i = 0; i < recordCount; i++) {
        CallRecord *rd = &records[i];
        AMFuncCostModel *model = [AMFuncCostModel new];
        model.className = NSStringFromClass(rd->cls);
        model.methodName = NSStringFromSelector(rd->sel);
        model.isClassMethod = class_isMetaClass(rd->cls);
        model.timeCost = (double)rd->time / 1000000.0;
        model.callDepth = rd->depth;
        [retArr addObject:model];
    }
    
    NSUInteger count = retArr.count;
    for (NSUInteger i = 0; i < count; i++) {
        AMFuncCostModel *model = retArr[i];
        
        // 不断的弹出调用深度大于0的方法并从余下retArr中寻找深度+1的方法
        if (model.callDepth > 0) {
            [retArr removeObjectAtIndex:i];
            // Todo:不需要循环，直接设置下一个，然后判断好边界就行
            for (NSUInteger j = i; j < count - 1; j++) {
                // 下一个深度小的话就开始将后面的递归的往 sub array 里添加
                if (retArr[j].callDepth + 1 == model.callDepth) {
                    NSMutableArray *sub = (NSMutableArray *)retArr[j].subCosts;
                    if (!sub) {
                        sub = [NSMutableArray new];
                        retArr[j].subCosts = sub;
                    }
                    [sub insertObject:model atIndex:0];
                }
            }
            i--;
            count--;
        }
    }
    
    return retArr;
}

- (void)recursionModel:(AMFuncCostModel *)model
               withLog:(NSMutableString *)mStr {
    // format mStr
    [mStr appendFormat:@"%@\n", model.desc];
    
    if (model.subCosts.count < 1) {
        model.lastCall = YES;
        [self recordFuncInfo:model];
    } else {
        for (AMFuncCostModel *subModel in model.subCosts) {
            // 记录方法的子方法的路径
            subModel.path = [NSString stringWithFormat:@"%@ - [%@ %@]", model.path, subModel.className, subModel.methodName];
            [self recursionModel:subModel withLog:mStr];
        }
    }
}

@end
