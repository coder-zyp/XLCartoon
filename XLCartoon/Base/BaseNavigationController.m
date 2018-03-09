//
//  BaseNavigationController.m
//  XLGame
//
//  Created by Amitabha on 2017/12/14.
//  Copyright © 2017年 In.于楚天. All rights reserved.
//

#import "BaseNavigationController.h"
#import "WRNavigationBar.h"
#import "CaricatureDetailViewController.h"

@implementation BaseNavigationController
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.WhiteNaviControllerNames = @[@"TaskTableViewController",
                                        @"FeedBackViewController",
                                        @"PayVIPTableViewController"];
    }
    return self;
}
-(void)viewDidLoad{
    [super viewDidLoad];
    [self.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]}];
}
+(void)setWhiteNavi{
    // 设置导航栏默认的背景颜色
    [WRNavigationBar wr_setDefaultNavBarBarTintColor:COLOR_SYSTEM_GARY];
    // 设置导航栏所有按钮的默认颜色
    [WRNavigationBar wr_setDefaultNavBarTintColor:[UIColor blackColor]];
    // 设置导航栏标题默认颜色
    [WRNavigationBar wr_setDefaultNavBarTitleColor:[UIColor blackColor]];
}

+(void)setDefautNavi{

    // 设置是 全局使用WRNavigationBar，还是局部使用WRNavigationBar，目前默认是全局使用 （局部使用待开发）
    [WRNavigationBar wr_widely];
    // WRNavigationBar 不会对 blackList 中的控制器有影响

//    [WRNavigationBar wr_setBlacklist:@[@"PYSearchViewController"]];
    // 设置导航栏默认的背景颜色
    [WRNavigationBar wr_setDefaultNavBarBarTintColor:COLOR_NAVI];
    // 设置导航栏所有按钮的默认颜色
    [WRNavigationBar wr_setDefaultNavBarTintColor:[UIColor whiteColor]];
    // 设置导航栏标题默认颜色
    [WRNavigationBar wr_setDefaultNavBarTitleColor:[UIColor whiteColor]];
    // 统一设置状态栏样式
    [WRNavigationBar wr_setDefaultStatusBarStyle:UIStatusBarStyleLightContent];
    // 如果需要设置导航栏底部分割线隐藏，可以在这里统一设置
    [WRNavigationBar wr_setDefaultNavBarShadowImageHidden:YES];
    
}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.childViewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
//    NSLog(@"class name>> %@",NSStringFromClass([viewController class]));
//    NSString * className = NSStringFromClass([self class]);
//    int i= 0;
//    for (NSString * str  in self.WhiteNaviControllerNames) {
//        if ([className isEqualToString:str ]) {
//            [BaseNavigationController setWhiteNavi];
//            break;
//        }
//        i++;
//        if (i == self.WhiteNaviControllerNames.count) {
//            viewController
//        }
//    }
    [super pushViewController:viewController animated:animated];
}

//-(BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item{
//    int i = 0;
//    int first = 0;
//    int count =0;
//    for (UIViewController * vc in self.viewControllers) {
//        if([vc isKindOfClass:[CaricatureDetailViewController class]]){
//            first = i;
//            break;
//        }
//        i++;
//    }
//    for (UIViewController * vc in self.viewControllers) {
//        if ([vc isKindOfClass:[CaricatureDetailViewController class]]) {
//            count ++;
//        }
//    }
//    NSLog(@"%@",item);
//    //  pop出栈
//    if (count > 1) {
//        [self popToViewController:(UIViewController *)self.viewControllers[first] animated:NO];
//    }else{
//        [self popViewControllerAnimated:NO];
//    }
//
//    return YES;
//}

//-(UIViewController *)popViewControllerAnimated:(BOOL)animated{
//    [super popViewControllerAnimated:animated];
//    
//    int i = 0;
//    int first = 0;
//    int count =0;
//    for (UIViewController * vc in self.viewControllers) {
//        if([vc isKindOfClass:[CaricatureDetailViewController class]]){
//            first = i;
//            break;
//        }
//        i++;
//    }
//    for (UIViewController * vc in self.viewControllers) {
//        if ([vc isKindOfClass:[CaricatureDetailViewController class]]) {
//            count ++;
//        }
//    }
//    //  pop出栈
//    if (count > 1) {
//        return [super popToViewController:(UIViewController *)self.viewControllers[first] animated:animated];
//    }else{
//        return [super popViewControllerAnimated:animated];
//    }
//}
@end
