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


@interface ViewController ()

@property (nonatomic, strong) NCSynchronizeManager *manger;

@end

@implementation ViewController

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

    NSArray *array = [NCTestModel getProperties];
    NSLog(@"%@", array);
    NSLog(@"%@", [testModel propertiesDictionary]);
    NCDataStorageTableModel *dataModel = [NCDataStorageTableModel modelWithDataStorageTableName: @"NCTestModel"];
    [dataModel addDataStorageItem: @"memberId"  withItemDataType:NCDataStorageDataTypeText itemRestraintType:NCDataStorageRestraintTypeUnique];
    [dataModel addDataStorageItem: @"memberPic"  withItemDataType: NCDataStorageDataTypeText];
    [dataModel addDataStorageItem: @"age"  withItemDataType: NCDataStorageDataTypeText];
    [dataModel addDataStorageItem: @"address"  withItemDataType: NCDataStorageDataTypeText];
    [dataModel addDataStorageItem: @"memberName"  withItemDataType:NCDataStorageDataTypeText itemRestraintType:NCDataStorageRestraintTypeUnique];
    [dataModel addDataStorageItem: @"gender"  withItemDataType:NCDataStorageDataTypeText itemRestraintType:NCDataStorageRestraintTypeUniqueAndNotNull];
    
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
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
