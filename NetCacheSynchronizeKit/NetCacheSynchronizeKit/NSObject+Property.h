//
//  NSObject+Property.h
//  NetCacheSynchronizeKit
//
//  Created by huangxiong on 2017/3/6.
//  Copyright © 2017年 huangxiong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Property)
/**
 获取属性列表

 @return 获得属性列表
 */
+ (NSArray *) getProperties;

/**
 获得本对象所有属性以及对应的值, 只保存有值的属性值

 @return 字典对象
 */
- (NSDictionary<NSString *, id> *) propertiesDictionary;

/**
 设置属性列表的值

 @param keyedValues 键值对描述
 */
- (void) setPropertyValuesForKeysWithDictionary: (NSDictionary<NSString *, id> *)keyedValues;


@end
