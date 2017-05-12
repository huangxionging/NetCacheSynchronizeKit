//
//  NCDataStorageItemModel.h
//  NetCacheSynchronizeKit
//
//  Created by huangxiong on 2017/3/7.
//  Copyright © 2017年 huangxiong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NCDataStorageItemModel : NSObject

- (NSString *) modelName;
/**
 通过对象创建模型

 @param obj 通过对象创建模型
 @return 模型对象
 */
+ (instancetype) modelWithObject: (id) obj;

/**
 通过对象初始化模型
 
 @param obj 通过对象创建模型
 @return 模型对象
 */
- (instancetype) initWithObject: (id) obj;

@end
