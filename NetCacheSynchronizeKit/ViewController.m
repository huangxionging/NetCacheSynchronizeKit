//
//  ViewController.m
//  NetCacheSynchronizeKit
//
//  Created by huangxiong on 16/7/7.
//  Copyright © 2016年 huangxiong. All rights reserved.
//

#import "ViewController.h"
#import "NCSynchronizeManager.h"
#import "NCDataStorageTableModel.h"
#import "NCTestModel.h"
#import "FMDB.h"
#import "NSObject+Property.h"
#import "NCDataStorageManager.h"
#import "NSDispatchMessageManager.h"


@interface ViewController ()

@property (nonatomic, strong) NCSynchronizeManager *manger;

@property (nonatomic, strong) NCDataStorageManager *storageManager;

@end

@implementation ViewController

- (NCDataStorageManager *)storageManager {
    if (_storageManager == nil) {
        _storageManager = [NCDataStorageManager managerWithRelativePath: @"Documents/main.db"];
    }
    return _storageManager;
}

- (NCSynchronizeManager *)manger {
    if (_manger == nil) {
        _manger = [NCSynchronizeManager managerWithRelativePath: @"Documents/main.db"];
    }
    return _manger;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    [self.manger setInterfaceOperation:NCInterfaceOperationTypeDelete interface: nil key: @"insert做做_wg"];
  //  [self.manger saveDataWithInterfaceKey: @"insert_wg"  parameter: @{@"uid" : @"2100100", @"value" : @"100", @"date":@"2016-06-20"} needCache: YES cacheParamList: @[@"histID", @"citime", @"value"]];
    NCTestModel *testModel = [NCTestModel modelWithDiction: nil];
    NCDataStorageTableModel *dataModel = [NCDataStorageTableModel modelWithDataStorageTableName: @"NCTestModel"];
    [dataModel addDataStorageItem: @"memberId"  withItemDataType:NCDataStorageDataTypeText itemRestraintType:NCDataStorageRestraintTypeUnique];
    [dataModel addDataStorageItem: @"memberPic"  withItemDataType: NCDataStorageDataTypeText];
    [dataModel addDataStorageItem: @"age"  withItemDataType: NCDataStorageDataTypeText];
    [dataModel addDataStorageItem: @"address"  withItemDataType: NCDataStorageDataTypeText];
    [dataModel addDataStorageItem: @"memberName"  withItemDataType:NCDataStorageDataTypeText itemRestraintType:NCDataStorageRestraintTypeUnique];
    [dataModel addDataStorageItem: @"gender"  withItemDataType:NCDataStorageDataTypeText itemRestraintType:NCDataStorageRestraintTypeUniqueAndNotNull];
    
    [self.storageManager createDataStorageTableModel: dataModel success:^(id responseObject) {
        NSLog(@"创建成功");
    } failure:^(NSError *error) {
        NSLog(@"创建失败");
    }];
    
//    NSLog(@"创建表单 API == %@", [dataModel createTableSql]);
//    [self.manger.dataBaseQueue inDatabase:^(FMDatabase *db) {
//        
//        if ([db open]) {
//            if (![db executeUpdate: dataModel.createTableSql]) {
//                NSLog(@"创建表单");
//            }
//        }
//        [db close];
//    }];
    
//    [self.manger.dataBaseQueue inDatabase:^(FMDatabase *db) {
//        if ([db open]) {
//
//            NSString * string =[dataModel insertDataStoreWith: nil];
//            
//            [db executeUpdate: string withParameterDictionary: [[NCTestModel modelWithDiction: nil] diction]];
//        }
//        [db close];
//    }];
//    
//    [self.manger.dataBaseQueue inDatabase:^(FMDatabase *db) {
//        if ([db open]) {
//            
//            NSMutableDictionary *diction = [NSMutableDictionary dictionaryWithCapacity: 4];
//            [diction setObject: testModel.memberId  forKey: @"memberId"];
//            [diction setObject: testModel.memberName forKey: @"memberName"];
//            FMResultSet *resultSet = [db executeQuery: @"select *from NCTestModel where memberId=:memberId and memberName=:memberName" withParameterDictionary: diction];
//            
////            [db executeQuery: @"" withParameterDictionary: nil];
//            while ([resultSet next]) {
//                NSLog(@"查询结果: %@", resultSet);
//                NCTestModel *model = [NCTestModel modelWithDiction: [resultSet resultDictionary]];
//                
//                [model setPropertyValuesForKeysWithDictionary: [resultSet resultDictionary]];
//            }
//            
//
////            [dataModel insertDataStoreWith: nil];
//
//        }
//        [db close];
//    }];
    NCTestModel *test = [[NCTestModel alloc] init];
    test.memberId = testModel.memberId;
    NCDataStorageItemModel *model = [NCDataStorageItemModel modelWithObject: test];
    [self.storageManager queryDataStorageItemModel:model success:^(id responseObject) {
        NSLog(@"查询结果%@", responseObject);
    } failure:^(NSError *error) {
        NSLog(@"错误:%@", error);
    }];
    
//    // 删除结果
    [self.storageManager deleteDataStorageItemModel: model success:^(id responseObject) {
        NSLog(@"删除结果%@", responseObject);
    } failure:^(NSError *error) {
        NSLog(@"错误:%@", error);
    }];
    model = [NCDataStorageItemModel modelWithObject: testModel];
    [self.storageManager insertDataStorageItemModel: model success:^(id responseObject) {
        NSLog(@"插入结果%@", responseObject);
    } failure:^(NSError *error) {
        NSLog(@"错误:%@", error);
    }];
//
    NCDataStorageItemModel *newModel = [NCDataStorageItemModel modelWithObject: test];
    test.memberName = @"黄小仙";
    test.memberPic = @"http://www.huangxionging.com/huang.png";
    test.age = @"18";
    [self.storageManager modifyOldDataStorageItemModel: model withNewDataStorageItemModel: newModel success:^(id responseObject) {
        NSLog(@"修改结果%@", responseObject);
    } failure:^(NSError *error) {
        NSLog(@"错误:%@", error);
    }];
    
    NCDataStorageItemModel *model1 = [[NSDispatchMessageManager shareManager] dispatchReturnValueTarget:[NCDataStorageItemModel class] method: @"modelWithObject:", test, nil];
    test.memberName = @"sadas";
    NSLog(@"%@", model1);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
