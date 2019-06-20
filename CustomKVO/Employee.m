
//
//  Employee.m
//  CustomKVO
//
//  Created by chenqg on 2019/6/20.
//  Copyright © 2019年 helanzhu. All rights reserved.
//

#import "Employee.h"

@implementation Employee

- (void)cc_observeValueForKey:(NSString *)key ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change{
    
    NSLog(@"属性%@改变之前的值为：%@ \n 属性%@改变之后的值为：%@",key,change[NSKeyValueChangeOldKey],key,change[NSKeyValueChangeNewKey]);
    
}

@end
