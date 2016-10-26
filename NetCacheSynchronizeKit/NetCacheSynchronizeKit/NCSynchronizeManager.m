//
//  NCSynchronizeManager.m
//  NetCacheSynchronizeKit
//
//  Created by huangxiong on 16/7/7.
//  Copyright © 2016年 huangxiong. All rights reserved.
//

#import "NCSynchronizeManager.h"
#import "NCDataStoreModel.h"
#import "FMDatabaseQueue.h"
#import "FMDatabase.h"
#import "AFNetworking.h"

// 私有 API 调用
@interface NCDataStoreModel ()

- (BOOL) excuteinDatabase: (FMDatabase *)db;
- (NSString *) createTableSql;

@end


@interface NCSynchronizeManager ()

@end

@implementation NCSynchronizeManager

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
        [self createInterfaceTable];
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

#pragma mark- 网络请求配置
- (AFHTTPSessionManager *)sessionManager {
    if (_sessionManager == nil) {
        _sessionManager = [AFHTTPSessionManager manager];
        _sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        _sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    return _sessionManager;
}

#pragma mark- 绝对路径的配置
- (NSString *)absolutelyPath {
    if (_absolutelyPath == nil) {
        NSAssert(_absolutelyPath, @"绝对路径不合法");
    }
    NSLog(@"%@", _absolutelyPath);
    return _absolutelyPath;
}

- (void)setAbsolutelyPath:(NSString *)absolutelyPath {
    if (absolutelyPath == nil || ![absolutelyPath hasPrefix: NSHomeDirectory()]) {
        NSAssert(absolutelyPath, @"绝对路径不合法");
    }
    _absolutelyPath = absolutelyPath;
}

#pragma mark- 相对路径的配置
- (NSString *)relativePath {
    if (_relativePath == nil) {
        
        // 若绝对路径存在, 计算相对路径
        if (self.absolutelyPath) {
            NSRange range = [self.absolutelyPath rangeOfString: NSHomeDirectory()];
            _relativePath = [self.absolutelyPath substringFromIndex: range.location + range.length + 1];
        } else {
            NSAssert(_relativePath, @"相对路径不能为空");
        }
    }
    return _relativePath;
}

- (void)setRelativePath:(NSString *)relativePath {
    if (relativePath == nil) {
        NSAssert(relativePath, @"相对路径不能为空");
    }
    // 完成相对路径和绝对路径的配置
    _relativePath = relativePath;
    self.absolutelyPath = [NSHomeDirectory() stringByAppendingPathComponent: _relativePath];
}

#pragma mark- 设置接口的操作
- (void) setInterfaceOperation:(NCInterfaceOperationType)type interface:(NSString *)interface key:(NSString *)key {
    
    // 根据不同类型来操作
    switch (type) {
        case NCInterfaceOperationTypeAdd: {
            NSAssert(interface && key, @"不能添加空接口");
            [self.dataBaseQueue inDatabase:^(FMDatabase *db) {
                // 查询是否存在
                BOOL isExist = [self isExistInterfaceItemForKey: key inDatabase: db];
                
                // 存在结果, 则不继续
                if (isExist) {
                    return;
                }
                
//                NCDataStoreModel *model = [[NCDataStoreModel alloc] initWithDataStoreName: @"nc_interface_table"];
//                // 添加数据项
//                [model addDataStoreItem: @"nc_interface"  withItemDataType:NCDataStoreDataTypeText itemRestraintType:NCDataStoreRestraintTypeNone];
//                [model addDataStoreItem: @"nc_key" withItemDataType:NCDataStoreDataTypeText itemRestraintType:NCDataStoreRestraintTypeUnique];
//                
//                // 保存值
//                [model addDataStoreObject: interface ForItem: @"nc_interface"];
//                [model addDataStoreObject: key ForItem: @"nc_key"];
//                
//                [model excuteinDatabase: db];
                // 添加数据项语句
                NSString *insertSql = [NSString stringWithFormat: @"insert into nc_interface_table(nc_interface, nc_key) values(?, ?)"];
                [db open];
                // 执行添加结果
                if ([db executeUpdate: insertSql, interface, key]) {
                    NSLog(@"数据项增加成功");
                }
                [db close];
            }];
            break;
        }
            
        case NCInterfaceOperationTypeDelete: {
            
            if (key == nil) {
                return;
            }
            [self.dataBaseQueue inDatabase:^(FMDatabase *db) {
                BOOL isExist = [self isExistInterfaceItemForKey: key inDatabase: db];
                // 存在结果, 则不继续
                if (!isExist) {
                    return;
                }
                
                NCDataStoreModel *model = [[NCDataStoreModel alloc] initWithDataStoreName: @"nc_interface_table"];
                // 添加数据项
//                [model addDataStoreItem: @"nc_interface"  withItemDataType:NCDataStoreDataTypeText itemRestraintType:NCDataStoreRestraintTypeNone];
                [model addDataStoreItem: @"nc_key" withItemDataType:NCDataStoreDataTypeText itemRestraintType:NCDataStoreRestraintTypeUnique];

                // 保存值
//                [model addDataStoreObject: interface ForItem: @"nc_interface"];
                [model addDataStoreObject: key ForItem: @"nc_key"];
                
                [model excuteinDatabase: db];
                // 删除语句
                NSString *deleteSql = [NSString stringWithFormat: @"delete from nc_interface_table where nc_key=?"];
                [db open];
                if ([db executeUpdate: deleteSql, key]) {
                    NSLog(@"数据删除成功");
                }
                [db close];
            }];
            break;
        }
            
        case NCInterfaceOperationTypeModify: {
            if (key == nil) {
                return;
            }
            
            [self.dataBaseQueue inDatabase:^(FMDatabase *db) {
                BOOL isExist = [self isExistInterfaceItemForKey: key inDatabase: db];
                // 如果存在执行修改语句, 不存在执行插入语句
                if (isExist) {
                    NSString *modifySql = [NSString stringWithFormat: @"update nc_interface_table set nc_interface=? where nc_key=?"];
                    [db open];
                    if ([db executeUpdate: modifySql, interface, key]) {
                        NSLog(@"修改成功");
                    }
                } else {
                    // 添加数据项语句
                    NSString *insertSql = [NSString stringWithFormat: @"insert into nc_interface_table(nc_interface, nc_key) values(?, ?)"];
                    [db open];
                    // 执行添加结果
                    if ([db executeUpdate: insertSql, interface, key]) {
                        NSLog(@"数据项增加成功");
                    }

                }
                [db close];
            }];
            break;
        }
        default:
            break;
    }
}

#pragma mark- 判断接口是否存在
- (BOOL) isExistInterfaceItemForKey: (NSString *) key inDatabase: (FMDatabase *)db {
    // 查询语句
    BOOL isExist = NO;
    NSString *querySql = [NSString stringWithFormat: @"select *from nc_interface_table where nc_key=?"];
    
    [db open];
    // 执行查询语句
    FMResultSet *result = [db executeQuery: querySql, key];
    
    // 判断是否存在
    isExist = [result next];
    
    // 记得关闭
    [result close];
    [db close];
    // 返回结果
    return isExist;
}

#pragma mark- 查询接口
- (NSString *)queryInterfaceItemForKey:(NSString *)key {
    
    __block NSString *resultString = nil;
    [self.dataBaseQueue inDatabase:^(FMDatabase *db) {
        NSString *querySql = [NSString stringWithFormat: @"select *from nc_interface_table where nc_key=?"];
        [db open];
        // 执行查询语句
        FMResultSet *result = [db executeQuery: querySql, key];
        
        // 判断是否存在
        if ([result next]) {
            resultString = [result stringForColumn: @"nc_interface"];
        }
        [result close];
        [db close];
    }];
    
    // 返回执行结果
    return resultString;
}

#pragma mark- 清空接口表
- (void)clearAllInterface {
    // 清空接口表
    [self.dataBaseQueue inDatabase:^(FMDatabase *db) {
        
        if ([db open]) {
            NSString *clearSql = @"delete from nc_interface_table";
            if ([db executeUpdate: clearSql]) {
                NSLog(@"清空表成功");
            }
        }
        [db close];
        
    }];
}

#pragma mark- 创建接口表
- (void) createInterfaceTable {
    
    NCDataStoreModel *model = [[NCDataStoreModel alloc] initWithDataStoreName: @"nc_interface_table"];
    // 添加数据项
    [model addDataStoreItem: @"nc_interface"  withItemDataType:NCDataStoreDataTypeText itemRestraintType:NCDataStoreRestraintTypeNone];
    
    [model addDataStoreItem: @"nc_key" withItemDataType:NCDataStoreDataTypeText itemRestraintType:NCDataStoreRestraintTypeUnique];
    
    // 创建数据存储模型
    [self createDataStore: model];
}

#pragma mark- 创建表
- (void)createDataStore:(NCDataStoreModel *)dataStoreModel {
    // 创建接口表
    [self.dataBaseQueue inDatabase:^(FMDatabase *db) {
        if ([db open]) {
            NSString *createSql = [dataStoreModel createTableSql];
            if (![db executeUpdate: createSql]) {
                NSLog(@"接口表创建失败");
            }
        }
        [db close];
    }];

    
}

- (void)saveDataWithInterfaceKey:(NSString *)key parameter:(id)parameter  needCache:(BOOL)isNeedCache cacheParamList:(NSArray *)paramList {
    
    
    NSString *interface = [self queryInterfaceItemForKey: key];
    
    [self.sessionManager POST: interface parameters: parameter progress: nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

@end
