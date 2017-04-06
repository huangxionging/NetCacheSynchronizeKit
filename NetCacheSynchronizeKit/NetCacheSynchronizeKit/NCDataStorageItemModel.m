//
//  NCDataStorageItemModel.m
//  NetCacheSynchronizeKit
//
//  Created by huangxiong on 2017/3/7.
//  Copyright © 2017年 huangxiong. All rights reserved.
//

#import "NCDataStorageItemModel.h"
#import "NSObject+Property.h"

@interface NCDataStorageItemModel ()

/**
 插入数据的对象
 */
@property (nonatomic, weak) id obj;

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

@implementation NCDataStorageItemModel

#pragma mark- 初始化函数
- (instancetype)initWithObject:(id)obj {
    self = [super init];
    if (self && obj) {
        self.obj = obj;
    }
    return self;
}

#pragma mark- 模型创建函数
+ (instancetype)modelWithObject:(id)obj {
    return [[super alloc] initWithObject: obj];
}

#pragma mark- 模型名称
- (NSString *) modelName {
    return NSStringFromClass([self.obj class]);
}


#pragma mark- 添加对象的 sql
- (NSString *) addObjectSql {
    
    NSAssert(self.obj, @"插入数据不能为空");
    // 获得对象的属性键值对
    NSDictionary *dictionary = [self.obj propertiesDictionary];
    
    // 对象类名即数据库表名
    NSString *className = NSStringFromClass([self.obj class]);
    // sql 语句
    NSMutableString *mutableSql = [NSMutableString stringWithFormat: @"insert into %@(", className];
    
    NSMutableString *valueString = [NSMutableString stringWithString: @" values("];
    
    // 遍历添加数据
    for (NSInteger index = 0; index < dictionary.allKeys.count; ++index) {
        if (index == 0) {
            [mutableSql appendFormat: @"%@", dictionary.allKeys[0]];
            [valueString appendFormat: @" :%@", dictionary.allKeys[index]];
        } else {
            [mutableSql appendFormat: @", %@", dictionary.allKeys[index]];
            [valueString appendFormat: @", :%@", dictionary.allKeys[index]];
        }
    }
    // 添加后缀
    [mutableSql appendString: @")"];
    [valueString appendString:@")"];
    [mutableSql appendString: valueString];
    
    // 返回保存使用的 sql
    return mutableSql;
}

#pragma mark- 查询对象的 sql 语句
- (NSString *)queryObjectSql {
    NSAssert(self.obj, @"插入数据不能为空");
    // 获得对象的属性键值对
    NSDictionary *dictionary = [self.obj propertiesDictionary];
    
    // 对象类名即数据库表名
    NSString *className = NSStringFromClass([self.obj class]);
    // sql 语句
    NSMutableString *mutableSql = [NSMutableString stringWithFormat: @"select *from %@ where", className];
    
    
    // 遍历添加数据
    for (NSInteger index = 0; index < dictionary.allKeys.count; ++index) {
        if (index == 0) {
            [mutableSql appendFormat: @" %@=:%@", dictionary.allKeys[0], dictionary.allKeys[0]];
            
        } else {
            [mutableSql appendFormat: @" and %@=:%@", dictionary.allKeys[index], dictionary.allKeys[index]];
        }
    }
    // 添加后缀
    // 返回保存使用的 sql
    return mutableSql;
}

- (NSDictionary *)parameterDictionary {
    return [self.obj propertiesDictionary];
}

- (NSString *)deleteObjectSql {
    NSAssert(self.obj, @"删除数据不能为空");
    // 获得对象的属性键值对
    NSDictionary *dictionary = [self.obj propertiesDictionary];
    
    // 对象类名即数据库表名
    NSString *className = NSStringFromClass([self.obj class]);
    // sql 语句
    NSMutableString *mutableSql = [NSMutableString stringWithFormat: @"delete from %@ where", className];
    
    
    // 遍历添加数据
    for (NSInteger index = 0; index < dictionary.allKeys.count; ++index) {
        if (index == 0) {
            [mutableSql appendFormat: @" %@=:%@", dictionary.allKeys[0], dictionary.allKeys[0]];
            
        } else {
            [mutableSql appendFormat: @" and %@=:%@", dictionary.allKeys[index], dictionary.allKeys[index]];
        }
    }
    // 返回保存使用的 sql
    return mutableSql;

}

@end
