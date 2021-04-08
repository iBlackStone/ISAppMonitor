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

@end

NS_ASSUME_NONNULL_END
