//
//  NSObject+Property.m
//  NetCacheSynchronizeKit
//
//  Created by huangxiong on 2017/3/6.
//  Copyright © 2017年 huangxiong. All rights reserved.
//

#import "NSObject+Property.h"
#import <objc/runtime.h>

@implementation NSObject (Property)

#pragma mark 获得属性列表
+ (NSArray *)getProperties {
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    NSMutableArray *propetiesArray = [NSMutableArray arrayWithCapacity: count];
    for (NSInteger index = 0; index < count; ++index) {
        const char *propertyName = property_getName(properties[index]);
        [propetiesArray addObject: [NSString stringWithUTF8String: propertyName]];
    }
    free(properties);
    return propetiesArray;
}

#pragma mark- 获得有值的属性字典
- (NSDictionary *)propertiesDictionary {
    NSMutableDictionary *propertiesDictionary = [NSMutableDictionary dictionary];
    NSArray *properties = [[self class] getProperties];
    if (properties.count > 0) {
        for (NSString *key in properties) {
            id value = [self valueForKey: key];
            if (value) {
                [propertiesDictionary setObject: value forKey: key];
            }
        }
    }
    return propertiesDictionary;
}

#pragma mark- 设置通过键值对字典设置属性
- (void)setPropertyValuesForKeysWithDictionary:(NSDictionary<NSString *,id> *)keyedValues {
    NSArray *properties = [[self class] getProperties];
    if (properties.count > 0) {
        // 遍历属性列表
        for (NSString *key in properties) {
            // 属性列表有字段, 并且键值对字典也包含值
            if (keyedValues[key]) {
                [self setValue: keyedValues[key] forKey: key];
            }
        }
    }
}

@end
