//
//  NCDataStoreManager.h
//  NetCacheSynchronizeKit
//
//  Created by huangxiong on 2017/3/7.
//  Copyright © 2017年 huangxiong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NCDataStoreModel.h"

@interface NCDataStoreManager : NSObject

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
 
 @param dataStoreModel 数据存储模型描述
 @param success 成功回调
 @param failure 失败回调
 */
- (void) addDataStoreModel: (NCDataStoreModel *)dataStoreModel success:(void (^)(id responceObject))success failure:(void (^)(NSError *error))failure;


/**
 插入数据模型

 @param dataStoreModel 数据存储模型
 @param success 成功回调
 @param failure 失败回调
 */
- (void) insertDataStoreModel: (NCDataStoreModel *)dataStoreModel success:(void (^)(id responceObject))success failure:(void (^)(NSError *error))failure;



@end
