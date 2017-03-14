//
//  NCDataStorageManager.m
//  NetCacheSynchronizeKit
//
//  Created by huangxiong on 2017/3/7.
//  Copyright © 2017年 huangxiong. All rights reserved.
//

#import "NCDataStorageManager.h"
#import "NCDispatchMessageManager.h"
#import "FMDB.h"

@interface NCDataStorageManager ()

/**
 数据库操作
 */
@property (nonatomic, strong) FMDatabaseQueue *dataBaseQueue;

@property (nonatomic, strong) NCDataStorageTableModel *dataStorageTableModel;

@end

@implementation NCDataStorageManager

#pragma mark- 合成变量
@synthesize absolutelyPath = _absolutelyPath, relativePath = _relativePath;

#pragma mark- 管理器生成方法
+ (instancetype)manager {
    return [[[self class] alloc] initWithRelativePath: nil];
}

+ (instancetype)managerWithRelativePath:(NSString *)relativePath {
    return [[[self class] alloc] initWithRelativePath: relativePath];
}

#pragma mark- 初始化方法
- (instancetype)initWithRelativePath:(NSString *)relativePath {
    
    self = [super init];
    
    if (self && relativePath) {
        self.relativePath = relativePath;
    }
    return self;
}

#pragma mark- 数据库配置
- (FMDatabaseQueue *)dataBaseQueue {
    if (_dataBaseQueue == nil) {
        _dataBaseQueue = [FMDatabaseQueue databaseQueueWithPath: self.absolutelyPath];
    }
    return _dataBaseQueue;
}

#pragma mark- 添加模型
- (void)createDataStorageTableModel:(NCDataStorageTableModel *)dataStorageTableModel success:(void (^)(id responceObject))success failure:(void (^)(NSError *error))failure {
    [self.dataBaseQueue inDatabase:^(FMDatabase *db) {
        // 打开数据库
        if ([db open]) {
            NSString *createSql = [[NCDispatchMessageManager shareManager] dispatchReturnValueTarget: dataStorageTableModel method: @"createTableSql", nil];
            if ([db executeUpdate: createSql]) {
                NSDictionary *diction = @{@"code": @"1000", @"msg" : @"创建成功"};
                success(diction);
            } else {
                NSError *error = [NSError errorWithDomain: @"com.netCache.createSql" code: 10001 userInfo: @{@"code": @"999", @"msg" : @"创建失败"}];
                failure(error);
            }
        } else {
            NSError *error = [NSError errorWithDomain: @"com.netCache.createSql" code: 10001 userInfo: @{@"code": @"999", @"msg" : @"数据库打开失败"}];
            failure(error);
        }
        [db close];
    }];
    
}

#pragma mark- 插入数据存储模型
- (void)insertDataStorageItemModel:(NCDataStorageItemModel *)dataStorageItemModel success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    [self.dataBaseQueue inDatabase:^(FMDatabase *db) {
        // 打开数据库
        if ([db open]) {
            NSString *addObjectSql = [[NCDispatchMessageManager shareManager] dispatchReturnValueTarget: dataStorageItemModel method: @"addObjectSql", nil];
            NSDictionary *parameter = [[NCDispatchMessageManager shareManager] dispatchReturnValueTarget: dataStorageItemModel method: @"parameterDictionary", nil];
            if ([db executeUpdate: addObjectSql withParameterDictionary: parameter]) {
                NSDictionary *diction = @{@"code": @"1000", @"msg" : @"插入成功"};
                success(diction);
            } else {
                NSError *error = [NSError errorWithDomain: @"com.netCache.createSql" code: 10001 userInfo: @{@"code": @"999", @"msg" : @"创建失败"}];
                failure(error);
            }
        } else {
            NSError *error = [NSError errorWithDomain: @"com.netCache.createSql" code: 10001 userInfo: @{@"code": @"999", @"msg" : @"数据库打开失败"}];
            failure(error);
        }
        [db close];
    }];

}
@end
