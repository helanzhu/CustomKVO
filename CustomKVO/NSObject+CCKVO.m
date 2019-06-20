//
//  NSObject+CCKVO.m
//  CustomKVO
//
//  Created by chenqg on 2019/6/20.
//  Copyright © 2019年 helanzhu. All rights reserved.
//

#import "NSObject+CCKVO.h"
#import <objc/message.h>
#import <objc/runtime.h>

static const char kvo_observerKey;

static NSString *CCKVONotifying_ = @"CCKVONotifying_";

@implementation NSObject (CCKVO)

/*
 1.注册类，继承self
 2.修改isa
 3.重写setter方法
 4.重写class方法
 5.通知外界
 */
- (void)cc_addObserver:(NSObject *)observer forKey:(NSString *)key options:(CCKeyValueObservingOptions)options{
    /*
     *1.获取setter方法名
     */
    NSString *setterName = [NSString stringWithFormat:@"set%@:",[key capitalizedString]];
    SEL setterSEL = NSSelectorFromString(setterName);
    /*
     *2.获取对应setter方法
     */
    Method setterMethod = class_getInstanceMethod([self class], setterSEL);
    if (!setterMethod) {
        NSLog(@"指定key不存在，或者没有setter方法！");
        return;
    }
    /*
     *3.判断是否已经替换过isa
     */
    Class isaClass = object_getClass(self);
    NSString *isaName = NSStringFromClass(isaClass);
    if (![isaName hasPrefix:CCKVONotifying_]) {
        /*
         *4.注册新类
         */
        NSString *oldClassName = NSStringFromClass([self class]);
        NSString *isaClassName = [CCKVONotifying_ stringByAppendingString:oldClassName];
        isaClass = NSClassFromString(isaClassName);
        if (!isaClass) {
            //创建新类
            isaClass = objc_allocateClassPair([self class], [isaClassName UTF8String], 0);
            //注册新类
            objc_registerClassPair(isaClass);
        }
        /*
         *5.修改原类的isa
         */
        object_setClass(self, isaClass);
    }
    /*
     *6.添加setter方法
     此时[self class]=CCKVONotifying_xxx,或者用isaClass
     */
    class_addMethod([self class], setterSEL, (IMP)kvo_setter, method_getTypeEncoding(setterMethod));
    /*
     *7.添加class方法
     */
    SEL classSEL = @selector(class);
    Method classMethod = class_getInstanceMethod([self class], classSEL);
    class_addMethod([self class], classSEL, (IMP)kvo_class, method_getTypeEncoding(classMethod));
    /*
     *8.处理观察者
     */
    CCObserverInfo *info = [[CCObserverInfo alloc]initWithObserver:observer key:key options:options];
    NSMutableArray *observerArr = objc_getAssociatedObject(self, &kvo_observerKey);
    if (!observerArr) {
        observerArr = [NSMutableArray array];
    }
    [observerArr addObject:info];
    objc_setAssociatedObject(self, &kvo_observerKey, observerArr, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

void kvo_setter(id self, SEL _cmd, id newValue){
    /*
     *(1)获取key setName:--->name
     */
    NSString *setterStr = NSStringFromSelector(_cmd);
    //key的首字母小写：n
    NSString *str1 = [[setterStr substringWithRange:NSMakeRange(3, 1)] lowercaseString];
    //key的剩余字母：ame
    NSString *str2 = [setterStr substringWithRange:NSMakeRange(4, [setterStr rangeOfString:@":"].location-4)];
    NSString *key = [NSString stringWithFormat:@"%@%@",str1,str2];
    
    /*
     *(2)获取以前的value值
     */
    id oldValue = [self valueForKey:key];
    
    /*
     *(3)调用父类的setter方法
     */
    struct objc_super superClass;
    superClass.receiver = self;
    superClass.super_class = class_getSuperclass(object_getClass(self));
    ((void (*)(void *, SEL, id))(void *)objc_msgSendSuper)(&superClass,_cmd,newValue);
    /*
     *(4)通知外界
     */
    NSMutableArray *observers = objc_getAssociatedObject(self, &kvo_observerKey);
    for (CCObserverInfo *info in observers) {
        if ([info.key isEqualToString:key]) {
            /*
             *(5)封装回传消息
             CCKeyValueObservingOptionNew|CCKeyValueObservingOptionOld = 11
             info.options&CCKeyValueObservingOptionNew =11&01 = 01
             info.options&CCKeyValueObservingOptionOld =11&10 = 10
             */
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                 NSMutableDictionary<NSKeyValueChangeKey,id> *change =[NSMutableDictionary dictionaryWithCapacity:2];
                 if (info.options&CCKeyValueObservingOptionNew) {
                     [change setObject:newValue forKey:NSKeyValueChangeNewKey];
                 }
                 if (info.options&CCKeyValueObservingOptionOld) {
                     [change setObject:oldValue forKey:NSKeyValueChangeOldKey];
                 }
                 ((void (*)(id,SEL,id,id,id))(void *)objc_msgSend)(info.observer,@selector(cc_observeValueForKey:ofObject:change:),info.key,self,change);
             });
        }
    }
    
}

Class kvo_class(id self, SEL _cmd){
    //获取isa、在获取isa的父类
    return class_getSuperclass(object_getClass(self));
}

- (void)cc_observeValueForKey:(NSString *)key ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change{
    
}

- (void)cc_removeObserver:(NSObject *)observer forKey:(NSString *)key{
    NSMutableArray *observers = objc_getAssociatedObject(self, &kvo_observerKey);
    if (!observers || observers.count <= 0) {
        return;
    }
    for (CCObserverInfo *info in observers) {
        if ([info.key isEqualToString:key]) {
            [observers removeObject:info];
            objc_setAssociatedObject(self, &kvo_observerKey, observers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            break;
        }
    }
    /*
     *当observers为空时，重新设置isa
     */
    if(observers.count <= 0)
    {
        object_setClass(self, [self class]);
    }
}

@end

