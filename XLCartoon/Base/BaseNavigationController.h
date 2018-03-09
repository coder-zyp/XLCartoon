//
//  BaseNavigationController.h
//  XLGame
//
//  Created by Amitabha on 2017/12/14.
//  Copyright © 2017年 In.于楚天. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseNavigationController : UINavigationController <UINavigationBarDelegate>
@property (nonatomic,strong) NSArray <NSString *> * WhiteNaviControllerNames;
+(void)setWhiteNavi;
+(void)setDefautNavi;
@end
