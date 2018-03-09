//
//  BaseTabBarController.m
//  XLCartoon
//
//  Created by Amitabha on 2017/12/16.
//  Copyright © 2017年 XLCR. All rights reserved.
//

#import "BaseTabBarController.h"
#import "HomeViewController.h"
#import "HomeNewViewController.h"
#import "FriendCircleViewController.h"
#import "MeViewController.h"
#import "BaseNavigationController.h"
#import "CartoonSetPageViewController.h"
#import "everyDayShowWindow.h"

@interface BaseTabBarController ()
@property (nonatomic,strong) NSArray * controllers;
@end

@implementation BaseTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tabBar setBarTintColor:[UIColor whiteColor]];
    self.tabBar.tintColor = COLOR_NAVI;
    self.viewControllers = self.controllers;
    // Do any additional setup after loading the view.
}
-(NSArray *)controllers{
    if (!_controllers) {
        NSArray <UIViewController *>* vcArray = @[[[HomeViewController alloc] init],
                              [[CartoonSetPageViewController alloc] init],
                              [[FriendCircleViewController alloc] init],
                              [[MeViewController alloc] init]
                              ];
        NSArray * array = @[@"首页",@"书架",@"混圈",@"我的"];
        
        NSMutableArray * arr = [NSMutableArray array];
        int i =0;
        for (NSString * title in array) {
            vcArray[i].title = title;
            BaseNavigationController * nc = [[BaseNavigationController alloc] initWithRootViewController:vcArray[i]];
            [nc.tabBarItem setImage:[UIImage imageNamed:title]];
            [nc.tabBarItem setSelectedImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@-1",title]]];
            
            [nc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor],NSFontAttributeName:[UIFont systemFontOfSize:13.f]}forState:UIControlStateNormal];
            [nc.tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.f],NSForegroundColorAttributeName:COLOR_NAVI} forState:UIControlStateHighlighted];
            i++;
            [arr addObject:nc];
        }
        _controllers = arr;
    }
    return _controllers;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if ([APP_DELEGATE checkEverydateTaskState] && USER_ID) {
        [everyDayShowWindow share];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
