//
//  MonitorDB+Stack.h
//  Prepare
//
//  Created by GL on 2021/4/2.
//

#import "AMDB.h"

NS_ASSUME_NONNULL_BEGIN

@interface AMDB (Stack)

- (void)insertStackTableWith:(AMStackModel *)model;

- (nullable NSArray<AMStackModel*> *)fetchStackModelsWith:(NSUInteger)page;

- (void)clearStackTable;

// Thread Safe API
- (void)asyncInsertStackTableWith:(AMStackModel *)model
                        compelete:(void(^)(void))block;
- (void)asyncFetchStackModelsWith:(NSUInteger)page
                        compelete:(void(^)( NSArray<AMStackModel*> * _Nullable))block;

@end

NS_ASSUME_NONNULL_END
