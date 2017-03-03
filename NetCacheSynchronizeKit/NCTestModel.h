//
//  NCTestModel.h
//  NetCacheSynchronizeKit
//
//  Created by huangxiong on 2017/3/3.
//  Copyright © 2017年 huangxiong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NCTestModel : NSObject

/**
 id
 */
@property (nonatomic, copy) NSString *memberId;

/**
 头像
 */
@property (nonatomic, copy) NSString *memberPic;

/**
 年龄
 */
@property (nonatomic, copy) NSString *age;

/**
 地址
 */
@property (nonatomic, copy) NSString *address;

/**
 成员名称
 */
@property (nonatomic, copy) NSString *memberName;

/**
 性别
 */
@property (nonatomic, copy) NSString *gender;

+ (instancetype) modelWithDiction: (NSDictionary *)diction;

@end
