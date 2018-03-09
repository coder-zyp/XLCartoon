//
//  UIResponder+Dispatch.m
//  ChinaDaily IM
//
//  Created by li.dg on 15/5/22.
//  Copyright (c) 2016年 Neusoft. All rights reserved.
//

#import "UIResponder+Custom.h"

@implementation UIResponder (Custom)

- (void)dispatchCustomEventWithName:(NSString *)name userInfo:(NSDictionary *)userInfo {
    [self.nextResponder dispatchCustomEventWithName:name userInfo:userInfo];
}

@end

