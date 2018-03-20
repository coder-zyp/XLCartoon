//
//  AppDelegate.m
//  XLCartoon
//
//  Created by Amitabha on 2017/12/16.
//  Copyright © 2017年 XLCR. All rights reserved.
//
#import "AppDelegate.h"
#import <IQKeyboardManager.h>
#import "CommentWindow.h"
#import <UMSocialCore/UMSocialCore.h>
#import "BaseTabBarController.h"
#import "LoginViewController.h"
#import "BaseNavigationController.h"
#import "shareWindow.h"
#import "KSGuaidViewManager.h"
#import "everyDayShowWindow.h"
#import <UMErrorCatch/UMErrorCatch.h>
#import <WRNavigationBar.h>

#import <UMPush/UMessage.h>
#import <UserNotifications/UserNotifications.h>
@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    [BaseNavigationController setDefautNavi];
    
    _naviVC = [[BaseNavigationController alloc]initWithRootViewController:[[LoginViewController alloc]init] ];
    
    _tabBarVC =  [[BaseTabBarController alloc]init];
    //设置窗口的根控制器
    self.window.rootViewController = self.userModel ? _tabBarVC :  _naviVC;
    
    [self.window makeKeyAndVisible];
    
    // Override point for customization after application launch.
//    [CommentWindow share];
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager]; // 获取类库的单例变量
    keyboardManager.shouldResignOnTouchOutside = YES; // 控制点击背景是否收起键盘
    keyboardManager.toolbarTintColor = COLOR_Orange_Red;
    
    [SVProgressHUD setMinimumDismissTimeInterval:1.25f];
    
    
    [self setGuaidView];//引导页
    [self reachability];//网络监测
   
    [CommentWindow share];
    if ([shareWindow share].shareState == shareState_NoResult) {
        [shareWindow  shareSuccess];
    }
    if (USER_ID) [self getUserInfo];
    /* 设置友盟appkey */
    
    [[UMSocialManager defaultManager] setUmSocialAppkey:@"5a531521b27b0a24fc000063"];
    
    [UMConfigure initWithAppkey:@"5a531521b27b0a24fc000063" channel:@"App Store"];
    
    [UMessage registerForRemoteNotificationsWithLaunchOptions:launchOptions Entity:nil completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (@available(iOS 10.0, *)) {//ios 10以后 推送功能要用户允许
            UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
            center.delegate=self;
            UNAuthorizationOptions types10=UNAuthorizationOptionBadge|  UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
            [center requestAuthorizationWithOptions:types10 completionHandler:^(BOOL granted, NSError * _Nullable error) {
                if (granted) {
                    //点击允许
                    //这里可以添加一些自己的逻辑
                } else {
                    //点击不允许
                    //这里可以添加一些自己的逻辑
                }
            }];
        } else {
            // Fallback on earlier versions
        }
        
    }];
    
    [self configUSharePlatforms];
    [self configUPushPlatforms];
    [UMConfigure setLogEnabled:YES];
    [[UMSocialManager defaultManager] openLog:NO];
    [UMErrorCatch initErrorCatch];
    

    // 解决在iOS11上mj 刷新问题
    if (@available(iOS 11.0, *)){
        UITableView.appearance.estimatedRowHeight = 0;
        UITableView.appearance.estimatedSectionFooterHeight = 0;
        UITableView.appearance.estimatedSectionHeaderHeight = 0;
    }
//    NSLog(@"appStoreReceiptURL%@",[[NSBundle mainBundle] appStoreReceiptURL]);
    return YES;
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    
    NSLog(@"sourceApplication : %@",sourceApplication);
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (!result) {
        // 其他如支付等SDK的回调
        
    }
    return result;
}
#pragma mark- APP生命周期
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    if ([self checkEverydateTaskState] && USER_ID) {
        [everyDayShowWindow share];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([shareWindow share].shareState == shareState_NoResult) {
            [shareWindow  shareSuccess];
        }
    });
    
}

#pragma mark- 推送
-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(nonnull NSError *)error{
    NSLog(@"%@",error);
}
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    NSLog(@"deviceToken%@",deviceToken);
}
//iOS10以下 收到通知的代理方法
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(nonnull NSDictionary *)userInfo fetchCompletionHandler:(nonnull void (^)(UIBackgroundFetchResult))completionHandler{
    //
    
    if([[[UIDevice currentDevice] systemVersion]intValue] < 10){
        [UMessage didReceiveRemoteNotification:userInfo];
        
        NSLog(@"iOS10以下 收到通知的代理方法userInfo%@",userInfo);
            //定制自定的的弹出框
        if([UIApplication sharedApplication].applicationState == UIApplicationStateActive)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"标题"
                                                                message:@"Test On ApplicationStateActive"
                                                               delegate:self
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil];
    
            [alertView show];
    
        }
        completionHandler(UIBackgroundFetchResultNewData);
    }
}

//iOS10新增：处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler __IOS_AVAILABLE(10.0){
    NSDictionary * userInfo = notification.request.content.userInfo;
    NSLog(@"iOS10新增：处理前台收到通知的代理方法 userInfo%@",userInfo);
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于前台时的远程推送接受
        //关闭U-Push自带的弹出框
        [UMessage setAutoAlert:NO];
        [UMessage didReceiveRemoteNotification:userInfo];
    }else{
        //应用处于前台时的本地推送接受
    }
    //当应用处于前台时提示设置，需要哪个可以设置哪一个
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
}

//iOS10新增：处理后台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler __IOS_AVAILABLE(10.0){
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    NSLog(@"iOS10新增：处理后台点击通知的代理方法 userInfo%@",userInfo);
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台时的远程推送接受
        [UMessage didReceiveRemoteNotification:userInfo];
        self.window.rootViewController = self.naviVC;
    }else{
        //本地推送接受
    }
}


#pragma mark- 引导页
-(void)setGuaidView{
    KSGuaidManager.images = @[[UIImage imageNamed:@"guid01"],
                              [UIImage imageNamed:@"guid02"],
                              [UIImage imageNamed:@"guid03"]];
    KSGuaidManager.pageIndicatorTintColor =[UIColor clearColor];
    KSGuaidManager.currentPageIndicatorTintColor =[UIColor clearColor];
    KSGuaidManager.dismissButtonImage = [UIImage imageNamed:@"hidden"];
    KSGuaidManager.dismissButtonCenter = CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT*0.846);
    [KSGuaidManager begin];
}
#pragma mark- 3DTouch
-(void)set3DTouch{
    if (@available(iOS 9.0, *)) {
        UIApplicationShortcutItem *shortItem1 = [[UIApplicationShortcutItem alloc] initWithType:@"type1" localizedTitle:@"分享咔咔漫画" localizedSubtitle:nil icon:[UIApplicationShortcutIcon iconWithType: UIApplicationShortcutIconTypeShare] userInfo:nil];
        NSArray *shortItems = [[NSArray alloc] initWithObjects: shortItem1,nil];
        
        NSArray *existingItems = [UIApplication sharedApplication].shortcutItems;
        
        NSArray *updatedItems = [existingItems arrayByAddingObjectsFromArray:shortItems];
        // 设置按钮
        [UIApplication sharedApplication].shortcutItems = updatedItems;
    } else {
        // Fallback on earlier versions
    }
}

-(void)application:(UIApplication *)application performActionForShortcutItem:(nonnull UIApplicationShortcutItem *)shortcutItem completionHandler:(nonnull void (^)(BOOL))completionHandler NS_AVAILABLE_IOS(9_0){
    //判断设定的唯一标识,当选择
    if ([shortcutItem.type isEqualToString:@"type1"]) {
        
    }
}
#pragma mark- APP初始化

-(UIInterfaceOrientationMask )application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
}
-(UserModel *)userModel{
    if (!_userModel) {
        _userModel = [UserModel mj_objectWithKeyValues:USER_INFO];
    }
    return _userModel;
}
- (void)configUPushPlatforms{

    [UMessage registerForRemoteNotificationsWithLaunchOptions:nil Entity:nil completionHandler:^(BOOL granted, NSError * _Nullable error) {
        NSLog(@"%@",error);
    }];
    
    //iOS10必须加下面这段代码。
}


- (void)configUSharePlatforms
{
    /*
     设置微信的appKey和appSecret
     [微信平台从U-Share 4/5升级说明]http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_1
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:WXAPPID appSecret:WXAppSecret redirectURL:WXAppRedirectURI];
    /*
     * 移除相应平台的分享，如微信收藏
     */
    [[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_WechatFavorite)]];
    
    /* 设置分享到QQ互联的appID
     * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
     100424468.no permission of union id
     [QQ/QZone平台集成说明]http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_3
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:QQAPPID/*设置QQ平台的appID*/  appSecret:QQAPPKey redirectURL:QQAppRedirectURI];

    /*
     设置新浪的appKey和appSecret
     [新浪微博集成说明]http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_2
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey: SinaAppKey  appSecret:SinaAppSecret redirectURL:SinaAppRedirectURI];
}
-(void)logoutAction{
    [SVProgressHUD showSuccessWithStatus:@"已退出"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userInfo"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"LastInterTime"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.userModel = nil;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        self.window.rootViewController = self.naviVC;
    });
}

- (void)reachability
{
    // 1.获得网络监控的管理者
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    // 2.设置网络状态改变后的处理
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        // 当网络状态改变了, 就会调用这个block
        switch (status) {
            case AFNetworkReachabilityStatusUnknown: // 未知网络
                NSLog(@"未知网络");
                break;
            case AFNetworkReachabilityStatusNotReachable: // 没有网络(断网)
                _notNet = YES;
                NSLog(@"没有网络(断网)");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN: // 手机自带网络
                NSLog(@"手机自带网络");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi: // WIFI
                NSLog(@"WIFI");
                break;
        }
    }];
    // 3.开始监控
    [mgr startMonitoring];
}


- (BOOL)checkEverydateTaskState{
    NSDate * date =[NSDate date];
    NSDateFormatter * dateFormatter =[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString * dateStr=[dateFormatter stringFromDate:date];
    NSLog(@"%@\n%@",USER_ID,APP_Enter_TIME);

    if (APP_Enter_TIME == nil && USER_ID) {
        
        APP_Enter_TIME_SET(dateStr);
        return YES;
    }else{
        if ([self intervalSinceNow:APP_Enter_TIME]>=1 && USER_ID) {
            APP_Enter_TIME_SET(dateStr);
            return YES;
        }
    }
    return NO;
}
// 得到的结果为相差的天数
- (int)intervalSinceNow:(NSString *) theDate
{
    
    NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
    [DateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *d=[DateFormatter dateFromString:theDate];
    
    NSInteger unitFlags = NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay;
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [cal components:unitFlags fromDate:d];
    NSDate *newBegin  = [cal dateFromComponents:comps];
    
    // 当前时间
    NSCalendar *cal2 = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps2 = [cal2 components:unitFlags fromDate:[NSDate date]];
    NSDate *newEnd  = [cal2 dateFromComponents:comps2];
    
    NSTimeInterval interval = [newEnd timeIntervalSinceDate:newBegin];
    NSInteger resultDays=((NSInteger)interval)/(3600*24);
    
    return (int) resultDays;
}

-(void)getUserInfo{
    
    [AfnManager postWithUrl:URL_GET_USER_INFO param:nil Sucess:^(NSDictionary *responseObject) {
        USER_MODEL = nil;
        USER_SET(OBJ(responseObject));
    }];
}
- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
