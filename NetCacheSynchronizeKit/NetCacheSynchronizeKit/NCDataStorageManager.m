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
#import "NSObject+Property.h"

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
        self.absolutelyPath = [NSHomeDirectory() stringByAppendingPathComponent: _relativePath];
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
- (void)createDataStorageTableModel:(NCDataStorageTableModel *)dataStorageTableModel success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure {
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

#pragma mark- 插入数据项
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

#pragma mark- 查询数据项
- (void)queryDataStorageItemModel:(NCDataStorageItemModel *)dataStorageItemModel success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    [self.dataBaseQueue inDatabase:^(FMDatabase *db) {
        // 打开数据库
        if ([db open]) {
            // 获得查询 sql 语句
            NSString *queryObjectSql = [[NCDispatchMessageManager shareManager] dispatchReturnValueTarget: dataStorageItemModel method: @"queryObjectSql", nil];
            // 获得参数
            NSDictionary *parameter = [[NCDispatchMessageManager shareManager] dispatchReturnValueTarget: dataStorageItemModel method: @"parameterDictionary", nil];
            // 查询结果
            FMResultSet *resultSet = [db executeQuery: queryObjectSql withParameterDictionary: parameter];
            // 遍历查询结果, 输出数组
            NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity: 10];
            while ([resultSet next]) {
                NSString *className = [[NCDispatchMessageManager shareManager] dispatchReturnValueTarget: dataStorageItemModel method: @"modelName", nil];
                NSObject *model = [[NSClassFromString(className) alloc] init];
                [model setPropertyValuesForKeysWithDictionary: [resultSet resultDictionary]];
                [mutableArray addObject: model];
            }
            NSDictionary *diction = @{@"code": @"1000", @"msg" : @"查询成功", @"data" : mutableArray};
            success(diction);
        } else {
            NSError *error = [NSError errorWithDomain: @"com.netCache.createSql" code: 10001 userInfo: @{@"code": @"999", @"msg" : @"数据库打开失败"}];
            failure(error);
        }
        [db close];
    }];
}

#pragma mark- 删除数据项
- (void)deleteDataStorageItemModel:(NCDataStorageItemModel *)dataStorageItemModel success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    [self.dataBaseQueue inDatabase:^(FMDatabase *db) {
        // 打开数据库
        if ([db open]) {
            // 获得删除 sql 语句
            NSString *deleteObjectSql = [[NCDispatchMessageManager shareManager] dispatchReturnValueTarget: dataStorageItemModel method: @"deleteObjectSql", nil];
            // 获得参数
            NSDictionary *parameter = [[NCDispatchMessageManager shareManager] dispatchReturnValueTarget: dataStorageItemModel method: @"parameterDictionary", nil];
            // 查询结果
            BOOL result = [db executeUpdate: deleteObjectSql withParameterDictionary: parameter];
            if (result == YES) {
                NSDictionary *diction = @{@"code": @"1000", @"msg" : @"删除成功"};
                success(diction);
            } else {
                NSError *error = [NSError errorWithDomain: @"com.netCache.deleteObjectSql" code: 10001 userInfo: @{@"code": @"999", @"msg" : @"删除失败"}];
                failure(error);
            }
            
        } else {
            NSError *error = [NSError errorWithDomain: @"com.netCache.createSql" code: 10001 userInfo: @{@"code": @"999", @"msg" : @"数据库打开失败"}];
            failure(error);
        }
        [db close];
    }];
}

#pragma mark- 修改数据项
- (void)modifyOldDataStorageItemModel:(NCDataStorageItemModel *)oldDataStorageItemModel withNewDataStorageItemModel:(NCDataStorageItemModel *)newDataStorageItemModel success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    NSDictionary *parameter = [[NCDispatchMessageManager shareManager] dispatchReturnValueTarget: self method: @"parameterForModifyOldDataStorageItemModel:withNewDataStorageItemModel:", oldDataStorageItemModel, newDataStorageItemModel, nil];
    
    if (parameter == nil) {
        NSError *error = [NSError errorWithDomain: @"com.netCache.modifySql" code: 10001 userInfo: @{@"code": @"999", @"msg" : @"参数错误"}];
        failure(error);
        return;
    }
    
    [self.dataBaseQueue inDatabase:^(FMDatabase *db) {
        NSString *modifySql = parameter[@"modifySql"];
        NSArray *parameterArray = parameter[@"parameterArray"];
        // 打开数据库
        if ([db open]) {
            // 查询结果
            BOOL result = [db executeUpdate: modifySql withArgumentsInArray: parameterArray];
            if (result == YES) {
                NSDictionary *diction = @{@"code": @"1000", @"msg" : @"修改成功"};
                success(diction);
            } else {
                NSError *error = [NSError errorWithDomain: @"com.netCache.deleteObjectSql" code: 10001 userInfo: @{@"code": @"999", @"msg" : @"修改失败"}];
                failure(error);
            }
            
        } else {
            NSError *error = [NSError errorWithDomain: @"com.netCache.createSql" code: 10001 userInfo: @{@"code": @"999", @"msg" : @"数据库打开失败"}];
            failure(error);
        }
        [db close];

    }];
}

#pragma mark- 产生 sql 语句和参数
- (NSDictionary *) parameterForModifyOldDataStorageItemModel:(NCDataStorageItemModel *)oldDataStorageItemModel withNewDataStorageItemModel:(NCDataStorageItemModel *)newDataStorageItemModel {
    NSString *tableName = [[NCDispatchMessageManager shareManager] dispatchReturnValueTarget: oldDataStorageItemModel method: @"modelName", nil];
    // 生成表头
    NSMutableString *modifySql = [NSMutableString stringWithFormat:@"update %@ set ", tableName];
     NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity: 10];
    // 新的在前
    // 遍历新参数字典
    NSDictionary *newParameter = [[NCDispatchMessageManager shareManager] dispatchReturnValueTarget: newDataStorageItemModel method: @"parameterDictionary", nil];
    [newParameter.allKeys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == 0) {
            // 添加字段
            [modifySql appendFormat: @"%@=?", obj];
        } else {
            // 添加字段
            [modifySql appendFormat: @", %@=?", obj];
        }
        // 添加参数
        [mutableArray addObject: [newParameter objectForKey: obj]];
    }];
    
    // 添加 where 字段
    [modifySql appendString: @" where "];
    // 遍历旧参数字典
    NSDictionary *oldParameter = [[NCDispatchMessageManager shareManager] dispatchReturnValueTarget: oldDataStorageItemModel method: @"parameterDictionary", nil];
    [oldParameter.allKeys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == 0) {
            // 添加字段
            [modifySql appendFormat: @"%@=?", obj];
        } else {
            // 添加字段
            [modifySql appendFormat: @" and %@=?", obj];
        }
        // 添加参数
        [mutableArray addObject: [oldParameter objectForKey: obj]];
    }];
    
    // 判断 mutableArray 是否为空
    if (mutableArray.count == 0){
        return nil;
    } else {
        NSDictionary *parameter = @{@"modifySql" : modifySql, @"parameterArray" : mutableArray};
        return parameter;
    }
}
@end
