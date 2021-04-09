//
//  MonitorDB.m
//  Prepare
//
//  Created by GL on 2021/4/2.
//

#import "AMDB.h"
#import <FMDB/FMDB.h>

@interface AMDB()

@property (nonatomic, strong) FMDatabaseQueue *dbQueue;
@property (nonatomic, copy) NSString *dbPath;
@property (nonatomic, strong) dispatch_queue_t operationQueue;

@end

@implementation AMDB

+ (instancetype)sharedInstance {
    static id instance;
    static dispatch_once_t onchToken;
    dispatch_once(&onchToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _dbPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"monitor.sqlite"];
        BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:_dbPath];
        if (!isExist) {
            FMDatabase *db = [FMDatabase databaseWithPath:_dbPath];
            if ([db open]) {
                /* clsCall 表记录方法读取频次的表
                 cid: 主id
                 fid: 父id 暂时不用
                 cls: 类名
                 mtd: 方法名
                 path: 完整路径标识
                 timecost: 方法消耗时长
                 calldepth: 层级
                 frequency: 调用次数
                 lastcall: 是否是最后一个 call
                 */
                NSString *createSql = @"create table clscall (cid INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL, fid integer, cls text, mtd text, path text, timecost double, calldepth integer, frequency integer, lastcall integer)";
                [db executeUpdate:createSql];
                
                /* stack 表记录
                 sid: id
                 stackcontent: 堆栈内容
                 insertdate: 日期
                 */
                NSString *createStackSql = @"create table stack (sid INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL, stackcontent text,isstuck integer, insertdate double)";
                [db executeUpdate:createStackSql];
            }
        }
        _dbQueue = [FMDatabaseQueue databaseQueueWithPath:_dbPath];
        _operationQueue = dispatch_queue_create("com.iStone.ll", DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

#pragma mark - For stack
- (void)insertStackTableWith:(AMStackModel *)model {
    [self.dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        if ([db open]) {
            NSNumber *stuck = @0;
            if (model.isStucked) {
                stuck = @1;
            }
            [db executeUpdate:@"insert into stack (stackcontent, isstuck, insertdate) values (?, ?, ?)", model.wholeStackString, stuck, [NSDate date]];
            [db close];
        }
    }];
}

- (NSArray<AMStackModel*> *)fetchStackModelsWith:(NSUInteger)page {
    FMDatabase *db = [FMDatabase databaseWithPath:self.dbPath];
    if ([db open]) {
        FMResultSet *rs = [db executeQuery:@"select * from stack order by sid desc limit ?, 50", @(page * 50)];
        //        FMResultSet *rs = [db executeQuery:@"select * from stack order by sid"];
        
        NSMutableArray *retArr = [NSMutableArray array];
        while ([rs next]) {
            AMStackModel *model = [AMStackModel new];
            model.wholeStackString = [rs stringForColumn:@"stackcontent"];
            model.isStucked = [rs boolForColumn:@"isstuck"];
            model.date = [rs doubleForColumn:@"insertdate"];
            [retArr addObject:model];
        }
        [db close];
        
        if (retArr.count > 0) {
            return  [retArr copy];
        } else {
            return  nil;
        }
    }
    return nil;
}

- (void)clearStack {
    BOOL success = NO;
    FMDatabase *db = [FMDatabase databaseWithPath:self.dbPath];
    if ([db open]) {
        [db executeUpdate:@"delete from stack"];
        [db close];
    }
    if (success == NO) {
        NSLog(@"Failed to delete stack table.");
    }
}

#pragma mark - For function time cost
- (void)inserFuncTableWith:(AMFuncCostModel *)model {
    [self.dbQueue inDatabase:^(FMDatabase *db){
        if ([db open]) {
            //添加白名单
            FMResultSet *rsl = [db executeQuery:@"select cid,frequency from clscall where path = ?", model.path];
            if ([rsl next]) {
                //有相同路径就更新路径访问频率
                int fq = [rsl intForColumn:@"frequency"] + 1;
                int cid = [rsl intForColumn:@"cid"];
                [db executeUpdate:@"update clscall set frequency = ? where cid = ?", @(fq), @(cid)];
            } else {
                //没有就添加一条记录
                NSNumber *lastCall = @0;
                if (model.lastCall) {
                    lastCall = @1;
                }
                [db executeUpdate:@"insert into clscall (cls, mtd, path, timecost, calldepth, frequency, lastcall) values (?, ?, ?, ?, ?, ?, ?)", model.className, model.methodName, model.path, @(model.timeCost), @(model.callDepth), @1, lastCall];
            }
            [db close];
        }
    }];
}

- (nullable NSArray<AMFuncCostModel*> *)fetchFuncModelsWith:(NSUInteger)page{
    FMDatabase *db = [FMDatabase databaseWithPath:self.dbPath];
    if ([db open]) {
        FMResultSet *rs = [db executeQuery:@"select * from clscall where lastcall=? order by frequency desc limit ?, 50",@1, @(page * 50)];
        
        NSMutableArray *arr = [NSMutableArray array];
        while ([rs next]) {
            AMFuncCostModel *model = [self clsCallModelFromResultSet:rs];
            [arr addObject:model];
        }
        [db close];

        if (arr.count) {
            return arr;
        }
    }
    return nil;
}

#pragma mark - Thread Safe
- (void)asyncInsertFuncTableWith:(AMFuncCostModel *)model compelete:(void(^)(void))block {
    dispatch_barrier_async(self.operationQueue, ^{
        [self inserFuncTableWith:model];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block();
            }
        });
    });
}
- (void)asyncFetchFuncModelsWith:(NSUInteger)page compelete:(void(^)( NSArray<AMFuncCostModel*> * _Nullable))block{
    dispatch_async(self.operationQueue, ^{
        NSArray *ret = [self fetchFuncModelsWith:page];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block(ret);
            }
        });
    });
}

- (void)asyncInsertStackTableWith:(AMStackModel *)model
                        compelete:(void(^)(void))block {
    dispatch_barrier_async(self.operationQueue, ^{
        [self insertStackTableWith:model];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block();
            }
        });
    });
}
- (void)asyncFetchStackModelsWith:(NSUInteger)page
                        compelete:(void(^)( NSArray<AMStackModel*> * _Nullable))block{
    dispatch_async(self.operationQueue, ^{
        NSArray *ret = [self fetchStackModelsWith:page];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block(ret);
            }
        });
    });
}

#pragma mark - end

- (void)clearFuncTable{
    BOOL success = NO;
    FMDatabase *db = [FMDatabase databaseWithPath:self.dbPath];
    if ([db open]) {
        success = [db executeUpdate:@"delete from clscall"];
        [db close];
    }
    if (success == NO) {
        NSLog(@"Failed to delete function table.");
    }
}

- (AMFuncCostModel *)clsCallModelFromResultSet:(FMResultSet *)rs {
    AMFuncCostModel *model = [AMFuncCostModel new];
    model.className = [rs stringForColumn:@"cls"];
    model.methodName = [rs stringForColumn:@"mtd"];
    model.path = [rs stringForColumn:@"path"];
    model.timeCost = [rs doubleForColumn:@"timecost"];
    model.callDepth = [rs intForColumn:@"calldepth"];
    model.frequency = [rs intForColumn:@"frequency"];
    model.lastCall = [rs boolForColumn:@"lastcall"];
    return model;
}
@end
