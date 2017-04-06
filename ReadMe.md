# NetCacheSynchronizeKit
-----
本文档为`NetCacheSynchronizeKit` 的开发文档. 架构图


************
|      		|  				  		|
| :-------:	|:--------------------:	|
| 版本号:	  | V1.0					| 
| 作者:	   | huangxiong			|
| 联系方式:	  | huangxionging@qq.com	|
| 日期:	   |  2017.04.15			 |	


*************
## <a name="index"/>目录
* [一. SDK 架构](#Structure)

* [二. DataCache](#DataCache)
	* 2.1 [NCDataStorageManager](#NCDataStorageManager)
	* 2.2 [NCDataStorageTableModel](#NCDataStorageTableModel)
	* 2.3 [NCDataStorageItemModel](#NCDataStorageItemModel)
* [三. NetSynchronize](#NetSynchronize)
* [四. UtilityTool](#UtilityTool)
	* 4.1 [NSObject+Property](#Property)
	* 4.2 [NCDispatchMessageManager](#NCDispatchMessageManager)

## <a name="Structure"/> 一. SDK 架构
 	SDK 分为 DataCache 和 NetSynchronize 以及 UtilityTool 三部分组成
 	DataCache 是基于 FMDB 的数据库 ORM 实现, 无需编写 sql 语句, 可以非常方便的对数据进行增删改查, 而且数据库表名(TableName)就是相应的数据模型的类名. 非常方便的从数据模型映射到数据库.(包含NCDataStorageManager, NCDataStorageTableModel, NCDataStorageItemModel)
 		
 	NetSynchronize 是基于 AFNetWorking 的网络访问, 接口管理, 实现的网络同步工具.


## <a name="DataCache"/>二. DataCache
```Objective-c
	// 创建表单 TableName "NCTestModel", 也即是测试模型的类名
	NCTestModel *testModel = [NCTestModel modelWithDiction: nil];
	// 表名
	NCDataStorageTableModel *dataModel = [NCDataStorageTableModel modelWithDataStorageTableName: @"NCTestModel"];
	// 添加字段和数据类型
	[dataModel addDataStorageItem: @"memberId"  withItemDataType:NCDataStorageDataTypeText itemRestraintType:NCDataStorageRestraintTypeUnique];
	[dataModel addDataStorageItem: @"memberPic"  withItemDataType: NCDataStorageDataTypeText];
	[dataModel addDataStorageItem: @"age"  withItemDataType: NCDataStorageDataTypeText];
	[dataModel addDataStorageItem: @"address"  withItemDataType: NCDataStorageDataTypeText];
	[dataModel addDataStorageItem: @"memberName"  withItemDataType:NCDataStorageDataTypeText itemRestraintType:NCDataStorageRestraintTypeUnique];
	[dataModel addDataStorageItem: @"gender"  withItemDataType:NCDataStorageDataTypeText itemRestraintType:NCDataStorageRestraintTypeUniqueAndNotNull];
	
	// 创建表单 self.storageManager  是 NCDataStorageManager 的实例
	[self.storageManager createDataStorageTableModel: dataModel success:^(id responseObject) {
		NSLog(@"创建成功");
	} failure:^(NSError *error) {
		NSLog(@"创建失败");
	}];
```

```Objective-c
	// 查询数据项
	NCTestModel *test = [[NCTestModel alloc] init];
	test.memberId = testModel.memberId;
	NCDataStorageItemModel *model = [NCDataStorageItemModel modelWithObject: test];
	[self.storageManager queryDataStorageItemModel:model success:^(id responseObject) {
        NSLog(@"查询结果%@", responseObject);
	} failure:^(NSError *error) {
        NSLog(@"错误:%@", error);
	}];
    
	// 删除数据
	[self.storageManager deleteDataStorageItemModel: model success:^(id responseObject) {
		NSLog(@"删除结果%@", responseObject);
	} failure:^(NSError *error) {
		NSLog(@"错误:%@", error);
	}];
	
	// 插入数据项
	model = [NCDataStorageItemModel modelWithObject: testModel];
	[self.storageManager insertDataStorageItemModel: model success:^(id responseObject) {
		NSLog(@"插入结果%@", responseObject);
	} failure:^(NSError *error) {
		NSLog(@"错误:%@", error);
	}];
	
   // 修改数据项
	NCDataStorageItemModel *newModel = [NCDataStorageItemModel modelWithObject: test];
	test.memberName = @"黄小仙";
	test.memberPic = @"http://www.huangxionging.com/huang.png";
	test.age = @"18";
	[self.storageManager modifyOldDataStorageItemModel: model withNewDataStorageItemModel: newModel success:^(id responseObject) {
		NSLog(@"修改结果%@", responseObject);
	} failure:^(NSError *error) {
		NSLog(@"错误:%@", error);
	}];
```

***
* 2.1 <a name="NCDataStorageManager">NCDataStorageManager

> **NCDataStorageManager** 是数据存储管理器, 具有创建表单, 以及对数据模型的增删查改功能, 相关属性以及 API 如下

```Objective-c
@interface NCDataStorageManager : NSObject

/**
 相对路径
 */
@property (nonatomic, copy) NSString *relativePath;

/**
 绝对路径
 */
@property (nonatomic, copy) NSString *absolutelyPath;

// 管理器
+ (instancetype) manager;

// 通过相对路径创建
+ (instancetype) managerWithRelativePath: (NSString *)relativePath;

// 创建相对路径
- (instancetype) initWithRelativePath: (NSString *)relativePath;


/**
 添加数据存储模型, 创建表单, 如果表单已存在, 则不会创建
 
 @param dataStorageTableModel 数据存储模型描述
 @param success 成功回调
 @param failure 失败回调
 */
- (void) createDataStorageTableModel: (NCDataStorageTableModel *)dataStorageTableModel success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

/**
 插入数据项

 @param dataStorageItemModel 数据存储模型
 @param success 成功回调
 @param failure 失败回调
 */
- (void) insertDataStorageItemModel: (NCDataStorageItemModel *)dataStorageItemModel success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

/**
 删除数据项
 
 @param dataStorageItemModel 数据存储模型
 @param success 成功回调
 @param failure 失败回调
 */
- (void) deleteDataStorageItemModel: (NCDataStorageItemModel *)dataStorageItemModel success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

/**
 查询数据项
 
 @param dataStorageItemModel 数据存储模型
 @param success 成功回调
 @param failure 失败回调
 */
- (void) queryDataStorageItemModel: (NCDataStorageItemModel *)dataStorageItemModel success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

/**
 修改数据项

 @param oldDataStorageItemModel 旧数据项
 @param newDataStorageItemModel 新数据项
 @param success 成功回调
 @param failure 失败回调
 */
- (void) modifyOldDataStorageItemModel: (NCDataStorageItemModel *)oldDataStorageItemModel withNewDataStorageItemModel: (NCDataStorageItemModel *)newDataStorageItemModel success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

@end
```