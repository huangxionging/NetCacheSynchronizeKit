//
//  NCDataStorageManager.h
//  NetCacheSynchronizeKit
//
//  Created by huangxiong on 2017/3/7.
//  Copyright © 2017年 huangxiong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NCDataStorageTableModel.h"
#import "NCDataStorageItemModel.h"

@interface NCDataStorageManager : NSObject

/**
 相对路径
 */
@property (nonatomic, copy) NSString *relativePath;

/**
 绝对路径
 */
@property (nonatomic, copy) NSString *absolutelyPath;

// 管理器
+ (instancetype) manager;

// 通过相对路径创建
+ (instancetype) managerWithRelativePath: (NSString *)relativePath;

// 创建相对路径
- (instancetype) initWithRelativePath: (NSString *)relativePath;


/**
 添加数据存储模型, 创建表单, 如果表单已存在, 则不会创建
 
 @param dataStorageTableModel 数据存储模型描述
 @param success 成功回调
 @param failure 失败回调
 */
- (void) createDataStorageTableModel: (NCDataStorageTableModel *)dataStorageTableModel success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

/**
 插入数据项

 @param dataStorageItemModel 数据存储模型
 @param success 成功回调
 @param failure 失败回调
 */
- (void) insertDataStorageItemModel: (NCDataStorageItemModel *)dataStorageItemModel success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

/**
 删除数据项
 
 @param dataStorageItemModel 数据存储模型
 @param success 成功回调
 @param failure 失败回调
 */
- (void) deleteDataStorageItemModel: (NCDataStorageItemModel *)dataStorageItemModel success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

/**
 查询数据项
 
 @param dataStorageItemModel 数据存储模型
 @param success 成功回调
 @param failure 失败回调
 */
- (void) queryDataStorageItemModel: (NCDataStorageItemModel *)dataStorageItemModel success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

/**
 データベースを変更します。修改数据库

 @param oldDataStorageItemModel 旧数据项
 @param newDataStorageItemModel 新数据项
 @param success 成功回调
 @param failure 失败回调
 */
- (void) modifyOldDataStorageItemModel: (NCDataStorageItemModel *)oldDataStorageItemModel withNewDataStorageItemModel: (NCDataStorageItemModel *)newDataStorageItemModel success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;


@end
