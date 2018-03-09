//
//  AppDelegate.h
//  XLCartoon
//
//  Created by Amitabha on 2017/12/16.
//  Copyright © 2017年 XLCR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"
#import "BaseTabBarController.h"
#import "LoginViewController.h"
#import "BaseNavigationController.h"
#import "shareWindow.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (assign, nonatomic) BOOL notNet;
@property (strong, nonatomic) UserModel * userModel;
@property (strong, nonatomic) BaseTabBarController * tabBarVC;
@property (strong, nonatomic) BaseNavigationController * naviVC;

-(void)getUserInfo;
- (BOOL)checkEverydateTaskState;
-(void)logoutAction;
@end

