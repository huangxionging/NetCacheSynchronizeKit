//
//  NCDataStoreModel.m
//  NetCacheSynchronizeKit
//
//  Created by huangxiong on 16/7/13.
//  Copyright © 2016年 huangxiong. All rights reserved.
//

#import "NCDataStoreModel.h"
#import "FMDatabase.h"

@interface  NCDataStoreModel ()

/**
 *  @author huangxiong
 *
 *  @brief 数据存储 sql 生成数组
 */
@property (nonatomic, strong) NSMutableDictionary *dataStoreTypeDictionary;

/**
 *  @author huangxiong
 *
 *  @brief 数据存储值字典
 */
@property (nonatomic, strong) NSMutableDictionary *dataStoreValueDictionary;

#pragma mark- 私有 API
- (BOOL) excuteinDatabase: (FMDatabase *)db;

// 创建表 sql
- (NSString *) createTableSql;

// 保存值 sql
- (NSString *) saveValueSql;

// 删除值 sql
- (NSString *) deleteValueSql;

// 查询
- (NSString *) queryValueSql;

@end

@implementation NCDataStoreModel

- (instancetype)initWithDataStoreName:(NSString *)dataStoreName {
    NSAssert(dataStoreName, @"存储模型的名字不能为空");
    if (self = [super init]) {
        _dataStoreName = dataStoreName;
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

#pragma mark- 数据
- (NSMutableDictionary *)dataStoreValueDictionary {
    if (_dataStoreValueDictionary == nil) {
        _dataStoreValueDictionary = [NSMutableDictionary dictionaryWithCapacity: 5];
    }
    return _dataStoreValueDictionary;
}

#pragma mark- 添加字段
-  (void) addDataStoreItem:(NSString *)item withItemDataType:(NCDataStoreDataType)dataType {
    [self addDataStoreItem: item withItemDataType:dataType itemRestraintType: NCDataStoreRestraintTypeNone];
}

#pragma mark- 添加字段
- (void)addDataStoreItem:(NSString *)item withItemDataType:(NCDataStoreDataType)dataType itemRestraintType:(NCDataStoreRestraintType)restraintType {
    
    // item
    NSMutableString *itemString = [NSMutableString stringWithString: item];
    
    // 添加数据类型
    NSArray *dataTypeArray = @[@" integer", @" text", @" real", @" blob"];
    NSInteger index = dataType - NCDataStoreDataTypeInteger;
    [itemString appendString: dataTypeArray[index]];
    
    // 添加约束类型
    index = restraintType - NCDataStoreRestraintTypeNone;
    NSArray *restraintTypeArray = @[@"", @" not null", @" unique", @" not null unique"];
    [itemString appendString: restraintTypeArray[index]];
    
    // 设置类型
    [self.dataStoreTypeDictionary setObject: itemString forKey: item];
}

#pragma mark- 为 item 添加值
- (void)addDataStoreObject:(id)object ForItem:(NSString *)item {
    
    // 首先得保证 key 中有值
    if ([self.dataStoreTypeDictionary.allKeys containsObject: item]) {
        [self.dataStoreValueDictionary setObject: object forKey: item];
    }
}


#pragma mark- 私有 API 实现
- (BOOL) excuteinDatabase: (FMDatabase *)db {
    [db open];
    
    if (![db executeUpdate: [self deleteValueSql] withParameterDictionary: self.dataStoreValueDictionary]) {
        NSLog(@"插入失败");
    }
    return YES;
}

#pragma mark- 创建 sql 表单语句
- (NSString *) createTableSql {
    
    // sql 语句
    NSMutableString *mutableSql = [NSMutableString stringWithFormat: @"create table if not exists %@(nc_id integer primary key autoincrement, ", self.dataStoreName];
    
    // 数组排序
    NSArray *array = [self.dataStoreTypeDictionary.allValues sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare: obj2 options:NSCaseInsensitiveSearch];
    }];
    
    // 生成的 sql 语句
    [mutableSql appendFormat: @"%@)", [array componentsJoinedByString: @", "]];
    // 产生创建 表单 sql 语句
    return  mutableSql;
}

#pragma mark- 保存 sql
- (NSString *)saveValueSql {
    // sql 语句
    NSMutableString *mutableSql = [NSMutableString stringWithFormat: @"insert into %@(", self.dataStoreName];
    
    NSMutableString *valueString = [NSMutableString stringWithString: @" values("];
    
    for (NSInteger index = 0; index < self.dataStoreTypeDictionary.allKeys.count; ++index) {
        if (index == 0) {
            [mutableSql appendFormat: @"%@", self.dataStoreTypeDictionary.allKeys[0]];
            [valueString appendFormat: @"?"];
        } else {
            [mutableSql appendFormat: @", %@", self.dataStoreTypeDictionary.allKeys[index]];
            [valueString appendFormat: @", ?"];
        }
    }
    
    // 添加后缀
    [mutableSql appendString: @")"];
    [valueString appendString:@")"];
    [mutableSql appendString: valueString];
    
    // 返回保存使用的 sql
    return mutableSql;
}

- (void)insertSql {
    
}

- (NSString *)deleteValueSql {
    // sql 语句
    NSMutableString *mutableSql = [NSMutableString stringWithFormat: @"delete from %@ where ", self.dataStoreName];
    
    for (NSInteger index = 0; index < self.dataStoreValueDictionary.allKeys.count; ++index) {
        if (index == 0) {
            [mutableSql appendFormat: @"%@ = :%@", self.dataStoreValueDictionary.allKeys[0], self.dataStoreValueDictionary.allKeys[0]];
        } else {
            [mutableSql appendFormat: @"and %@ = :%@", self.dataStoreValueDictionary.allKeys[index], self.dataStoreValueDictionary.allKeys[index]];
        }
    }
    
    return mutableSql;
}

- (void) insertDataStoreWith:(NSObject *)model {
    NSLog(@"%@", [self saveValueSql]);
}

@end
