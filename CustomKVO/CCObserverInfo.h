//
//  CCObserverInfo.h
//  CustomKVO
//
//  Created by chenqg on 2019/6/20.
//  Copyright © 2019年 helanzhu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSUInteger, CCKeyValueObservingOptions){
    CCKeyValueObservingOptionNew = 0x01,        //01
    CCKeyValueObservingOptionOld = 0x02         //10
};


NS_ASSUME_NONNULL_BEGIN

@interface CCObserverInfo : NSObject

//观察者
@property (nonatomic, strong) id observer;
//被监听的key
@property (nonatomic, copy) NSString *key;
//监听策略
@property (nonatomic, assign) CCKeyValueObservingOptions options;

- (instancetype)initWithObserver:(id)observer key:(NSString *)key options:(CCKeyValueObservingOptions)options;

@end

NS_ASSUME_NONNULL_END

