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

// Thread Safe API
- (void)asyncInsertFuncTableWith:(AMFuncCostModel *)model
                       compelete:(void(^)(void))block;
- (void)asyncFetchFuncModelsWith:(NSUInteger)page
                       compelete:(void(^)( NSArray<AMFuncCostModel*> * _Nullable))block;


@end

NS_ASSUME_NONNULL_END
