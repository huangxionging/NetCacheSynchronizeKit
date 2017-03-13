//
//  NCDataStoreItemModel.m
//  NetCacheSynchronizeKit
//
//  Created by huangxiong on 2017/3/7.
//  Copyright © 2017年 huangxiong. All rights reserved.
//

#import "NCDataStoreItemModel.h"
#import "NSObject+Property.h"

@interface NCDataStoreItemModel ()

/**
 插入数据的对象
 */
@property (nonatomic, weak) id obj;

@end

@implementation NCDataStoreItemModel

+ (instancetype)modelWithObject:(id)obj {
    NCDataStoreItemModel *model = [[super alloc] init];
    if (model && obj) {
        model.obj = obj;
    }
    return model;
}


#pragma mark- 添加对象
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

- (NSString *)queryObjectSql {
    NSAssert(self.obj, @"插入数据不能为空");
    // 获得对象的属性键值对
    NSDictionary *dictionary = [self.obj propertiesDictionary];
    
    // 对象类名即数据库表名
    NSString *className = NSStringFromClass([self.obj class]);
    // sql 语句
    NSMutableString *mutableSql = [NSMutableString stringWithFormat: @"select *from %@ where", className];
    
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

@end
