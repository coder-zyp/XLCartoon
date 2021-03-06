//
//  UIResponder+Dispatch.h
//  ChinaDaily IM
//
//  Created by li.dg on 15/5/22.
//  Copyright (c) 2016年 Neusoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIResponder (Custom)


/**
 *  发送一个自定义消息, 对name时间感兴趣的 UIResponsder 可以对消息进行处理
 *
 *  @param name 发生的事件名称
 *  @param userInfo  传递消息时, 携带的数据, 数据传递过程中, 会有新的数据添加
 *
 */
- (void)dispatchCustomEventWithName:(NSString *)name userInfo:(NSDictionary *)userInfo;

@end
