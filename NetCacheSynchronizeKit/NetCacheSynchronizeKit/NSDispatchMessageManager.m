//
//  NSDispatchMessageManager.m
//  NetCacheSynchronizeKit
//
//  Created by huangxiong on 2017/3/7.
//  Copyright © 2017年 huangxiong. All rights reserved.
//

#import "NSDispatchMessageManager.h"
#import <objc/message.h>

@implementation NSDispatchMessageManager

+ (instancetype)shareManager {
    static NSDispatchMessageManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    
    return manager;
}

- (void) dispatchTarget:(id)target method:(NSString *)method, ... {
    
    // 方法
    SEL selector = NSSelectorFromString(method);
    
    if (![target respondsToSelector: selector]) {
        
        NSLog(@"target :%@ 不能响应方法: %@", target, method);
        return;
        //        NSAssert(0, @"目标不能响应方法");
    }
    
    // 生成签名
    NSMethodSignature *methodSignature = [target methodSignatureForSelector: selector];
    // 生成调用器
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
    // 设置调用目标
    [invocation setTarget: target];
    // 设置方法
    [invocation setSelector: selector];
    
    // 可变指针
    va_list ap;
    va_start(ap, method);
    
    // 循环获取参数
    id object = nil;
    NSInteger index = 2;
    while ((object = va_arg(ap, id))) {
        // 配置参数
        [invocation setArgument: &object atIndex: index++];
    }
    // 结束
    va_end(ap);
    
    // 保持参数
    [invocation retainArguments];
    // 调用
    [invocation invoke];

//    // 调用方法, 为了支持 64 位
//    switch (parameterArray.count) {
//        case 0: {
//            void (*dispatch)(id, SEL) = (void (*)(id, SEL)) objc_msgSend;
//            dispatch(target, selector);
//            break;
//        }
//        case 1: {
//            void (*dispatch)(id, SEL, id) = (void (*)(id, SEL, id)) objc_msgSend;
//            dispatch(target, selector, parameterArray[0]);
//            break;
//        }
//        case 2: {
//            void (*dispatch)(id, SEL, id, id) = (void (*)(id, SEL, id, id)) objc_msgSend;
//            dispatch(target, selector, parameterArray[0], parameterArray[1]);
//            break;
//        }
//        case 3: {
//            void (*dispatch)(id, SEL, id, id, id) = (void (*)(id, SEL, id, id, id)) objc_msgSend;
//            dispatch(target, selector, parameterArray[0], parameterArray[1], parameterArray[2]);
//            break;
//        }
//        case 4: {
//            void (*dispatch)(id, SEL, id, id, id, id) = (void (*)(id, SEL, id, id, id, id)) objc_msgSend;
//            dispatch(target, selector, parameterArray[0], parameterArray[1], parameterArray[2], parameterArray[3]);
//            break;
//        }
//        case 5: {
//            void (*dispatch)(id, SEL, id, id, id, id, id) = (void (*)(id, SEL, id, id, id, id, id)) objc_msgSend;
//            dispatch(target, selector, parameterArray[0], parameterArray[1], parameterArray[2], parameterArray[3], parameterArray[4]);
//            break;
//        }
//        case 6: {
//            void (*dispatch)(id, SEL, id, id, id, id, id, id) = (void (*)(id, SEL, id, id, id, id, id, id)) objc_msgSend;
//            dispatch(target, selector, parameterArray[0], parameterArray[1], parameterArray[2], parameterArray[3], parameterArray[4], parameterArray[5]);
//            break;
//        }
//        case 7: {
//            void (*dispatch)(id, SEL, id, id, id, id, id, id, id) = (void (*)(id, SEL, id, id, id, id, id, id, id)) objc_msgSend;
//            dispatch(target, selector, parameterArray[0], parameterArray[1], parameterArray[2], parameterArray[3], parameterArray[4], parameterArray[5],parameterArray[6]);
//            break;
//        }
//        case 8: {
//            void (*dispatch)(id, SEL, id, id, id, id, id, id, id, id) = (void (*)(id, SEL, id, id, id, id, id, id, id, id)) objc_msgSend;
//            dispatch(target, selector, parameterArray[0], parameterArray[1], parameterArray[2], parameterArray[3], parameterArray[4], parameterArray[5],parameterArray[6], parameterArray[7]);
//            break;
//        }
//        case 9: {
//            void (*dispatch)(id, SEL, id, id, id, id, id, id, id, id, id) = (void (*)(id, SEL, id, id, id, id, id, id, id, id, id)) objc_msgSend;
//            dispatch(target, selector, parameterArray[0], parameterArray[1], parameterArray[2], parameterArray[3], parameterArray[4], parameterArray[5],parameterArray[6], parameterArray[7], parameterArray[8]);
//            break;
//        }
//        case 10: {
//            void (*dispatch)(id, SEL, id, id, id, id, id, id, id, id, id, id) = (void (*)(id, SEL, id, id, id, id, id, id, id, id, id, id)) objc_msgSend;
//            dispatch(target, selector, parameterArray[0], parameterArray[1], parameterArray[2], parameterArray[3], parameterArray[4], parameterArray[5],parameterArray[6], parameterArray[7], parameterArray[8], parameterArray[9]);
//            break;
//        }
//        default:
//            NSLog(@"😝, 你脑袋被门挤了, 超过10个参数");
//            break;
//    }
}

- (id)dispatchReturnValueTarget:(id)target method:(NSString *)method, ... {
    
    // 方法
    SEL selector = NSSelectorFromString(method);

    if (![target respondsToSelector: selector]) {
        
        NSLog(@"target :%@ 不能响应方法: %@", target, method);
        return nil;
//        NSAssert(0, @"目标不能响应方法");
    }
    
    // 生成签名
    NSMethodSignature *methodSignature = [target methodSignatureForSelector: selector];
    // 生成调用器
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
    // 设置调用目标
    [invocation setTarget: target];
    // 设置方法
    [invocation setSelector: selector];
    
    // 可变指针
    va_list ap;
    va_start(ap, method);
    
    // 循环获取参数
    id object = nil;
    NSInteger index = 2;
    while ((object = va_arg(ap, id))) {
        // 配置参数
        [invocation setArgument: &object atIndex: index++];
    }
    // 结束
    va_end(ap);

    // 保持参数
    [invocation retainArguments];
    // 调用
    [invocation invoke];
    // 这里只能写 void *
    void *result = nil;
    if (methodSignature.methodReturnLength != 0) {
        // 获得返回值
        [invocation getReturnValue:&result];
    }
    // 转换
    return (__bridge id)(result);
//    // 调用方法, 为了支持 64 位
//    switch (parameterArray.count) {
//        case 0: {
//            id (*dispatch)(id, SEL) = (id (*)(id, SEL)) objc_msgSend;
//            return dispatch(target, selector);
//            break;
//        }
//        case 1: {
//            id (*dispatch)(id, SEL, id) = (id (*)(id, SEL, id)) objc_msgSend;
//            return dispatch(target, selector, parameterArray[0]);
//            break;
//        }
//        case 2: {
//            id (*dispatch)(id, SEL, id, id) = (id (*)(id, SEL, id, id)) objc_msgSend;
//            return dispatch(target, selector, parameterArray[0], parameterArray[1]);
//            break;
//        }
//        case 3: {
//            id (*dispatch)(id, SEL, id, id, id) = (id (*)(id, SEL, id, id, id)) objc_msgSend;
//            return dispatch(target, selector, parameterArray[0], parameterArray[1], parameterArray[2]);
//            break;
//        }
//        case 4: {
//            id (*dispatch)(id, SEL, id, id, id, id) = (id (*)(id, SEL, id, id, id, id)) objc_msgSend;
//            return dispatch(target, selector, parameterArray[0], parameterArray[1], parameterArray[2], parameterArray[3]);
//            break;
//        }
//        case 5: {
//            id (*dispatch)(id, SEL, id, id, id, id, id) = (id (*)(id, SEL, id, id, id, id, id)) objc_msgSend;
//            return dispatch(target, selector, parameterArray[0], parameterArray[1], parameterArray[2], parameterArray[3], parameterArray[4]);
//            break;
//        }
//        case 6: {
//            id (*dispatch)(id, SEL, id, id, id, id, id, id) = (id (*)(id, SEL, id, id, id, id, id, id)) objc_msgSend;
//            return dispatch(target, selector, parameterArray[0], parameterArray[1], parameterArray[2], parameterArray[3], parameterArray[4], parameterArray[5]);
//            break;
//        }
//        case 7: {
//            id (*dispatch)(id, SEL, id, id, id, id, id, id, id) = (id (*)(id, SEL, id, id, id, id, id, id, id)) objc_msgSend;
//            return dispatch(target, selector, parameterArray[0], parameterArray[1], parameterArray[2], parameterArray[3], parameterArray[4], parameterArray[5],parameterArray[6]);
//            break;
//        }
//        case 8: {
//            id (*dispatch)(id, SEL, id, id, id, id, id, id, id, id) = (id (*)(id, SEL, id, id, id, id, id, id, id, id)) objc_msgSend;
//            return dispatch(target, selector, parameterArray[0], parameterArray[1], parameterArray[2], parameterArray[3], parameterArray[4], parameterArray[5],parameterArray[6], parameterArray[7]);
//            break;
//        }
//        case 9: {
//            id (*dispatch)(id, SEL, id, id, id, id, id, id, id, id, id) = (id (*)(id, SEL, id, id, id, id, id, id, id, id, id)) objc_msgSend;
//            return dispatch(target, selector, parameterArray[0], parameterArray[1], parameterArray[2], parameterArray[3], parameterArray[4], parameterArray[5],parameterArray[6], parameterArray[7], parameterArray[8]);
//            break;
//        }
//        case 10: {
//            id (*dispatch)(id, SEL, id, id, id, id, id, id, id, id, id, id) = (id (*)(id, SEL, id, id, id, id, id, id, id, id, id, id)) objc_msgSend;
//            return dispatch(target, selector, parameterArray[0], parameterArray[1], parameterArray[2], parameterArray[3], parameterArray[4], parameterArray[5],parameterArray[6], parameterArray[7], parameterArray[8], parameterArray[9]);
//            break;
//        }
//        case 11: {
//            id (*dispatch)(id, SEL, id, id, id, id, id, id, id, id, id, id, id) = (id (*)(id, SEL, id, id, id, id, id, id, id, id, id, id, id)) objc_msgSend;
//            return dispatch(target, selector, parameterArray[0], parameterArray[1], parameterArray[2], parameterArray[3], parameterArray[4], parameterArray[5],parameterArray[6], parameterArray[7], parameterArray[8], parameterArray[9], parameterArray[10]);
//            break;
//        }
//        default:
//            NSLog(@"😝, 你脑袋被门挤了, 超过10个参数");
//            return nil;
//            break;
//    }
}


@end
