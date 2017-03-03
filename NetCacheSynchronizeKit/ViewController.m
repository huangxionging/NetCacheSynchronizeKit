//
//  ViewController.m
//  NetCacheSynchronizeKit
//
//  Created by huangxiong on 16/7/7.
//  Copyright © 2016年 huangxiong. All rights reserved.
//

#import "ViewController.h"
#import "NCSynchronizeManager.h"
#import "NCDataStoreModel.h"
#import "NCTestModel.h"
#import "FMDB.h"


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
    
    NCDataStoreModel *dataModel = [[NCDataStoreModel alloc] initWithDataStoreName: @"NCTestModel"];
    [dataModel addDataStoreItem: @"memberId"  withItemDataType:NCDataStoreDataTypeText itemRestraintType:NCDataStoreRestraintTypeUnique];
    [dataModel addDataStoreItem: @"memberPic"  withItemDataType:NCDataStoreDataTypeText];
    [dataModel addDataStoreItem: @"age"  withItemDataType:NCDataStoreDataTypeText];
    [dataModel addDataStoreItem: @"address"  withItemDataType:NCDataStoreDataTypeText];
    [dataModel addDataStoreItem: @"memberName"  withItemDataType:NCDataStoreDataTypeText itemRestraintType:NCDataStoreRestraintTypeUnique];
    [dataModel addDataStoreItem: @"gender"  withItemDataType:NCDataStoreDataTypeText itemRestraintType:NCDataStoreRestraintTypeUniqueAndNotNull];
    
    NSLog(@"创建表单 API == %@", [dataModel createTableSql]);
    [self.manger.dataBaseQueue inDatabase:^(FMDatabase *db) {
        
        if ([db open]) {
            if (![db executeUpdate: dataModel.createTableSql]) {
                NSLog(@"创建表单");
            }
        }
        [db close];
    }];
    
    [self.manger.dataBaseQueue inDatabase:^(FMDatabase *db) {
        if ([db open]) {
            [dataModel insertDataStoreWith: nil];
        }
        [db close];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
