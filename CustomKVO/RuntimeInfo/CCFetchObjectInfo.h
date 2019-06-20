//
//  CCFetchObjectInfo.h
//  CustomKVO
//
//  Created by chenqg on 2019/6/20.
//  Copyright © 2019年 helanzhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <objc/message.h>

NS_ASSUME_NONNULL_BEGIN

@interface CCFetchObjectInfo : NSObject

//1.根据类名获取类
+ (Class)fetchClass:(NSString *)clsName;
//2.根据类获取类名
+ (NSString *)fetchClassName:(Class)cls;
//3.获取成员变量
+ (NSArray *)fetchIvarList:(Class)cls;
//4.获取成员属性
+ (NSArray *)fetchPropertyList:(Class)cls;
//5.获取类的实例方法
+ (NSArray *)fetchMethodList:(Class)cls;
//6.获取协议列表
+ (NSArray *)fechProtocolList:(Class)cls;
//7.动态添加方法
+ (void)addMethod:(Class)cls methodName:(SEL)method methodClass:(Class)methodClass methodIMP:(SEL)methodIMP;
//8.动态交换方法
+ (void)exchangeMethod:(Class)cls firstMethod:(SEL)firstMethod secondMethod:(SEL)secondMethod;

@end

NS_ASSUME_NONNULL_END
