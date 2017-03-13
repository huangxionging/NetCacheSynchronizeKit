//
//  NCDataStoreItemModel.h
//  NetCacheSynchronizeKit
//
//  Created by huangxiong on 2017/3/7.
//  Copyright © 2017年 huangxiong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NCDataStoreItemModel : NSObject

/**
 通过对象创建模型

 @param obj 通过对象创建模型
 @return 模型对象
 */
+ (instancetype) modelWithObject: (id) obj;

/**
 添加对象的 sql 语句

 @return sql 语句
 */
- (NSString *)addObjectSql;

/**
 查询对象的 sql 语句

 @return sql 语句
 */
- (NSString *)queryObjectSql;

/**
 修改对象的 sql 语句

 @return 修改对象的 sql
 */
- (NSString *)modifyObjectSql;

/**
 删除对象的 sql 语句

 @return sql 语句
 */
- (NSString *)deleteObjectSql;

/**
 参数字典, 用于配合插入 sql 语句需要填充的参数

 @return 参数字典
 */
- (NSDictionary *) parameterDictionary;

@end
