//
//  NCDataStorageTableModel.m
//  NetCacheSynchronizeKit
//
//  Created by huangxiong on 16/7/13.
//  Copyright © 2016年 huangxiong. All rights reserved.
//

#import "NCDataStorageTableModel.h"

@interface  NCDataStorageTableModel ()

/**
 *  @author huangxiong
 *
 *  @brief 数据存储 sql 生成数组
 */
@property (nonatomic, strong) NSMutableDictionary *dataStoreTypeDictionary;

@end

@implementation NCDataStorageTableModel

+ (instancetype)modelWithDataStorageTableName:(NSString *)dataStorageTableName {
    return [[super alloc] initWithDataStorageTableName: dataStorageTableName];
}

- (instancetype)initWithDataStorageTableName:(NSString *)dataStorageTableName {
    NSAssert(dataStorageTableName, @"存储模型的名字不能为空");
    if (self = [super init]) {
        _dataStorageTableName = dataStorageTableName;
    }
    return self;
}

#pragma mark- 数据存储类型字典 用于保存数据类型和约束类型
- (NSMutableDictionary *)dataStoreTypeDictionary {
    if (_dataStoreTypeDictionary == nil) {
        _dataStoreTypeDictionary = [NSMutableDictionary dictionaryWithCapacity: 5];
    }
    return _dataStoreTypeDictionary;
}

#pragma mark- 添加字段
- (void)addDataStorageItem:(NSString *)item withItemDataType:(NCDataStorageDataType)dataType {
    [self addDataStorageItem: item withItemDataType:dataType itemRestraintType:NCDataStorageRestraintTypeTypeNone];
}

#pragma mark- 添加字段
- (void)addDataStorageItem:(NSString *)item withItemDataType:(NCDataStorageDataType)dataType itemRestraintType:(NCDataStorageRestraintType)restraintType {
    
    // item
    NSMutableString *itemString = [NSMutableString stringWithString: item];
    
    // 添加数据类型
    NSArray *dataTypeArray = @[@" integer", @" text", @" real", @" blob"];
    NSInteger index = dataType - NCDataStorageDataTypeInteger;
    [itemString appendString: dataTypeArray[index]];
    
    // 添加约束类型
    index = restraintType - NCDataStorageRestraintTypeTypeNone;
    NSArray *restraintTypeArray = @[@"", @" not null", @" unique", @" not null unique"];
    [itemString appendString: restraintTypeArray[index]];
    
    // 设置类型
    [self.dataStoreTypeDictionary setObject: itemString forKey: item];
}

#pragma mark- 创建 sql 表单语句
- (NSString *) createTableSql {
    // sql 语句
    NSMutableString *mutableSql = [NSMutableString stringWithFormat: @"create table if not exists %@(nc_id integer primary key autoincrement, ", self.dataStorageTableName];
    
    // 数组排序
    NSArray *array = [self.dataStoreTypeDictionary.allValues sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare: obj2 options:NSCaseInsensitiveSearch];
    }];
    
    // 生成的 sql 语句
    [mutableSql appendFormat: @"%@)", [array componentsJoinedByString: @", "]];
    // 产生创建 表单 sql 语句
    return  mutableSql;
}


@end
