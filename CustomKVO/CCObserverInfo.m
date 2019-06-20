//
//  CCObserverInfo.m
//  CustomKVO
//
//  Created by chenqg on 2019/6/20.
//  Copyright © 2019年 helanzhu. All rights reserved.
//

#import "CCObserverInfo.h"

@implementation CCObserverInfo

- (instancetype)initWithObserver:(id)observer key:(NSString *)key options:(CCKeyValueObservingOptions)options{
    self = [super init];
    if (self) {
        self.observer = observer;
        self.key = key;
        self.options = options;
    }
    return self;
}

@end
