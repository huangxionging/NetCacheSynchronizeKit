//
//  NCDataStoreModel.h
//  NetCacheSynchronizeKit
//
//  Created by huangxiong on 16/7/13.
//  Copyright © 2016年 huangxiong. All rights reserved.
//

#import <Foundation/Foundation.h>

// 数据存储类型
typedef NS_ENUM(NSUInteger, NCDataStoreDataType) {
    NCDataStoreDataTypeInteger  = 10001,    // 整数
    NCDataStoreDataTypeText     = 10002,    // 文本
    NCDataStoreDataTypeReal     = 10003,    // 实数
    NCDataStoreDataTypeBinary   = 10004,    // 二进制
};

// 约束类型
typedef NS_ENUM(NSUInteger, NCDataStoreRestraintType) {
    NCDataStoreRestraintTypeNone                = 20001,    // 默认
    NCDataStoreRestraintTypeNotNull             = 20002,    // 非空约束
    NCDataStoreRestraintTypeUnique              = 20003,    // 唯一约束
    NCDataStoreRestraintTypeUniqueAndNotNull    = 20004,    // 非空且唯一
};

/**
 *  @author huangxiong
 *
 *  @brief 该类用来创建数据存储模型, 存储数据使用
 */
@interface NCDataStoreModel : NSObject

/**
 *  @author huangxiong, 2016/07/14 09:41:27
 *
 *  @brief 数据存储模型名字, 也就是表名
 *
 *  @since 1.0
 */
@property (nonatomic, copy, readonly) NSString *dataStoreName;

/**
 *  @author huangxiong
 *
 *  @brief 通过存储模型的名字
 *
 *  @param dataStoreName 存储模型的名字
 *
 *  @return 返回对象
 */
- (instancetype)initWithDataStoreName: (NSString *)dataStoreName;
/**
 *  @author huangxiong
 *
 *  @brief 添加数据存储项和
 *
 *  @param item          item
 *  @param dataType      数据类型
 *  @param restraintType 约束类型
 */
- (void) addDataStoreItem: (NSString *) item withItemDataType: (NCDataStoreDataType) dataType  itemRestraintType: (NCDataStoreRestraintType) restraintType;

/**
 *  @author huangxiong
 *
 *  @brief
 *
 *  @param object object 必须是对象
 *  @param item    item 是数据项, 但必须已存在, 即使用 addDataStoreItem 添加过
 */
- (void) addDataStoreObject: (id) object ForItem: (NSString *) item;


@end
