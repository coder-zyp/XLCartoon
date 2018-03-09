//
//  sendFriendCircleViewController.h
//  XLCartoon
//
//  Created by Amitabha on 2018/1/4.
//  Copyright © 2018年 XLCR. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^RefreshBlock)(void);

@interface sendFriendCircleViewController : UIViewController

@property (copy, nonatomic) RefreshBlock  block ;

@end
