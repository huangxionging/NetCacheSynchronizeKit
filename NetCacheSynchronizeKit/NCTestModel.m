//
//  NCTestModel.m
//  NetCacheSynchronizeKit
//
//  Created by huangxiong on 2017/3/3.
//  Copyright © 2017年 huangxiong. All rights reserved.
//

#import "NCTestModel.h"
#import "NSObject+Property.h"

@implementation NCTestModel

+ (instancetype)modelWithDiction:(NSDictionary *)diction {
    NSLog(@"%@", diction);
    NCTestModel *model = [[super alloc] init];
    if (model) {
        model.age = @"14";
        model.memberId = @"6784897r8hdsi2xz93898e";
        model.memberPic = @"http://qn.huangxiong.png";
        model.address = @"中国广东省深圳市南山区科技园权侑莉";
        model.memberName = @"Rxzedmond";
        model.gender = @"man/";
        
        if (diction) {
            [model setPropertyValuesForKeysWithDictionary: diction];
        }
    }
    return model;
}

- (NSDictionary *)diction {
    return @{@"age": self.age, @"memberId" : self.memberId, @"memberPic" : self.memberPic, @"address" : self.address, @"memberName" : self.memberName, @"gender" : self.gender};
}

- (void)setValue:(id)value forUndefinedKey:(nonnull NSString *)key {
    NSLog(@"key == %@", key);
}
@end
