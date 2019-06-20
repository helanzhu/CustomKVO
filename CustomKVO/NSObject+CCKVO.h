//
//  NSObject+CCKVO.h
//  CustomKVO
//
//  Created by chenqg on 2019/6/20.
//  Copyright © 2019年 helanzhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCObserverInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (CCKVO)

//添加KVO
- (void)cc_addObserver:(NSObject *)observer forKey:(NSString *)key options:(CCKeyValueObservingOptions)options;
//监听KVO
- (void)cc_observeValueForKey:(NSString *)key ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change;
//移除KVO
- (void)cc_removeObserver:(NSObject *)observer forKey:(NSString *)key;


@end

NS_ASSUME_NONNULL_END
