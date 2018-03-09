//
//  TopTableViewController.h
//  XLCartoon
//
//  Created by Amitabha on 2018/2/23.
//  Copyright © 2018年 XLCR. All rights reserved.
//
typedef NS_ENUM(NSUInteger, TopType) {
    TopTypePlay = 0,
    TopTypeFollow
};

#import "BaseTableViewController.h"

@interface TopTableViewController : BaseTableViewController
- (instancetype)initWithUrl:(NSString * )url;
@end
