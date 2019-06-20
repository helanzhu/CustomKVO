//
//  main.m
//  CustomKVO
//
//  Created by chenqg on 2019/6/20.
//  Copyright © 2019年 helanzhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Employee.h"
#import "CCFetchObjectInfo.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {

        Employee *employ = [[Employee alloc]init];
        NSLog(@"方法列表：%@",[CCFetchObjectInfo fetchMethodList:object_getClass(employ)]);
        NSLog(@"class：%@",[employ class]);
        NSLog(@"isa：%@",object_getClass(employ));
        NSLog(@"setterIMP：%p",[employ methodForSelector:@selector(setName:)]);
        NSLog(@"classIMP：%p",[employ methodForSelector:@selector(class)]);

        employ.name = @"chenqg";
        [employ cc_addObserver:employ forKey:NSStringFromSelector(@selector(name)) options:CCKeyValueObservingOptionNew|CCKeyValueObservingOptionOld];
        employ.name = @"chenqg3721";
        
        
        NSLog(@"分割线=======😍😍😍😍😍==========");
        
        NSLog(@"方法列表：%@",[CCFetchObjectInfo fetchMethodList:object_getClass(employ)]);
        NSLog(@"class：%@",[employ class]);
        NSLog(@"isa：%@",object_getClass(employ));
        NSLog(@"setterIMP：%p",[employ methodForSelector:@selector(setName:)]);
        NSLog(@"classIMP：%p",[employ methodForSelector:@selector(class)]);


    }
    return 0;
}
