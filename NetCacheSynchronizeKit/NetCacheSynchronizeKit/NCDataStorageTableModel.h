//
//  NCDataStorageTableModel.h
//  NetCacheSynchronizeKit
//
//  Created by huangxiong on 16/7/13.
//  Copyright © 2016年 huangxiong. All rights reserved.
//

#import <Foundation/Foundation.h>

// 数据存储类型
typedef NS_ENUM(NSUInteger, NCDataStorageDataType) {
    NCDataStorageDataTypeInteger  = 10001,    // 整数
    NCDataStorageDataTypeText     = 10002,    // 文本
    NCDataStorageDataTypeReal     = 10003,    // 实数
    NCDataStorageDataTypeBinary   = 10004,    // 二进制
};

// 约束类型
typedef NS_ENUM(NSUInteger, NCDataStorageRestraintType) {
    NCDataStorageRestraintTypeTypeNone                = 20001,    // 默认
    NCDataStorageRestraintTypeNotNull             = 20002,    // 非空约束
    NCDataStorageRestraintTypeUnique              = 20003,    // 唯一约束
    NCDataStorageRestraintTypeUniqueAndNotNull    = 20004,    // 非空且唯一
};

/**
 *  @author huangxiong
 *
 *  @brief 该类用来创建数据存储模型, 存储数据使用
 */
@interface NCDataStorageTableModel : NSObject

/**
 *  @author huangxiong, 2016/07/14 09:41:27
 *
 *  @brief 数据存储模型名字, 也就是表名
 *
 *  @since 1.0
 */
@property (nonatomic, copy, readonly) NSString *dataStorageTableName;

/**
 *  @author huangxiong
 *
 *  @brief 通过存储模型的名字
 *
 *  @param dataStoreName 存储模型的名字
 *
 *  @return 返回对象
 */
- (instancetype)initWithDataStorageTableName: (NSString *)dataStorageTableName;

/**
 通过数据存储名创建模型

 @param dataStoreName 存储模型的名字
 @return 返回对象
 */
+ (instancetype)modelWithDataStorageTableName: (NSString *)dataStorageTableName;



/**
 添加字段

 @param item item 字段
 @param dataType 数据类型, 约束类型默认为空
 */
-  (void) addDataStorageItem:(NSString *)item withItemDataType:(NCDataStorageDataType)dataType;

/**
 *  @brief 添加数据存储项和
 *
 *  @param item          item
 *  @param dataType      数据类型
 *  @param restraintType 约束类型
 */
- (void) addDataStorageItem: (NSString *) item withItemDataType: (NCDataStorageDataType) dataType  itemRestraintType: (NCDataStorageRestraintType) restraintType;


@end
