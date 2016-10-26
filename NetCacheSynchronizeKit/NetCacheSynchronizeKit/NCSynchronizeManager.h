//
//  NCSynchronizeManager.h
//  NetCacheSynchronizeKit
//
//  Created by huangxiong on 16/7/7.
//  Copyright © 2016年 huangxiong. All rights reserved.
//

#import <Foundation/Foundation.h>
// 类
@class AFHTTPSessionManager, FMDatabase, FMDatabaseQueue, FMResultSet, NCDataStoreModel;

typedef NS_ENUM(NSUInteger, NCInterfaceOperationType) {
    NCInterfaceOperationTypeAdd     = 10001, // 添加接口
    NCInterfaceOperationTypeModify  = 10002, // 修改接口
    NCInterfaceOperationTypeDelete  = 10003, // 删除接口
};

/**
 *  @author huangxiong, 2016/07/08 15:28:52
 *
 *  @brief 网络缓存同步管理器 NC 代表 NetCache, 既可以请求网络服务器数据, 也可以使用数据库缓存本地数据, 或者只做某一个功能
 *
 *  @since 1.0
 */
@interface NCSynchronizeManager : NSObject

/**
 *  @author huangxiong, 2016/07/07 17:49:03
 *
 *  @brief 数据库队列
 *
 *  @since 1.0
 */
@property (nonatomic, strong) FMDatabaseQueue *dataBaseQueue;

/**
 *  @author huangxiong, 2016/07/08 10:29:56
 *
 *  @brief 网络管理器
 *
 *  @since 1.0
 */
@property (nonatomic, strong)AFHTTPSessionManager *sessionManager;

/**
 *  @author huangxiong, 2016/07/08 11:24:27
 *
 *  @brief 相对路路径
 *
 *  @since 1.0
 */
@property (nonatomic, copy) NSString *relativePath;

/**
 *  @author huangxiong, 2016/07/08 11:37:29
 *
 *  @brief 绝对路径
 *
 *  @since 1.0
 */
@property (nonatomic, copy) NSString *absolutelyPath;

// 管理器
+ (instancetype) manager;

// 通过相对路径创建
+ (instancetype) managerWithRelativePath: (NSString *)relativePath;

// 创建相对路径
- (instancetype) initWithRelativePath: (NSString *)relativePath;

// 对接口的设置操作, 删除操作 interface 可空
- (void) setInterfaceOperation: (NCInterfaceOperationType) type interface: (NSString *) interface key: (NSString *) key;

// 添加接口
- (void) addInterface: (NSString *) interface forKey: (NSString *) key;

// 修改接口
- (void) modifyInterface: (NSString *) interface forKey: (NSString *) key;

- (void) deleteInterface: (NSString *) interface forKey: (NSString *) key;

// 查询接口 Item
- (NSString *) queryInterfaceItemForKey: (NSString *) key;

// 清空所有的接口
- (void) clearAllInterface;

- (void) saveDataWithInterfaceKey: (NSString *) key parameter: (id) parameter needCache: (BOOL) isNeedCache cacheParamList: (NSArray *) paramList;

- (void) createDataStore: (NCDataStoreModel *)dataStoreModel;

- (void) synchronize;

@end
