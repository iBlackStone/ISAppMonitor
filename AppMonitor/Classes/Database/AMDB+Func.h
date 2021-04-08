//
//  AMDB+Func.h
//  Prepare
//
//  Created by GL on 2021/4/4.
//

#import "AMDB.h"

NS_ASSUME_NONNULL_BEGIN

@interface AMDB (Func)

- (void)inserFuncTableWith:(AMFuncCostModel *)model;

- (nullable NSArray<AMFuncCostModel*> *)fetchFuncModelsWith:(NSUInteger)page;

- (void)clearFuncTable;

@end

NS_ASSUME_NONNULL_END
