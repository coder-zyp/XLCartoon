//
//  GlobalDefines.h
//  XLGame
//
//  Created by yuchutian on 2017/10/11.
//  Copyright © 2017年 In.于楚天. All rights reserved.
//

#ifndef GlobalDefines_h
#define GlobalDefines_h
//微博
#define SinaAppKey             @"1783345252"
#define SinaAppSecret          @"f6f0c12c410a0765c6632100ab84a5e8"
#define SinaAppRedirectURI     URL_SHARE_BACK

//QQ
#define QQAPPID @"1106379231"
#define QQAPPKey @"uXXFM2cBEmn1kztz"
#define QQAppRedirectURI URL_SHARE_BACK
//微信
#define WXAPPID @"wx4eabd1dc92bd538e"
#define WXAppSecret @"949a134632f9aada7981eb96475b7f1a"
#define WXAppRedirectURI   URL_SHARE_BACK

//客服微信
#define CustomerService_Wechat @"13066798436"
//客服电话
#define CustomerService_Phone @"024-31272260"

//------------- USERDEFULTS ----------------//
#define APP_PAY_FAIL_KEY @"IAP_PAY_FAIL"

#define APP_Enter_TIME_SET(OBJ) [[NSUserDefaults standardUserDefaults] setObject:OBJ forKey:@"LastInterTime"];[[NSUserDefaults standardUserDefaults] synchronize]
#define APP_Enter_TIME [[NSUserDefaults standardUserDefaults]objectForKey: @"LastInterTime"]

#define USER_SET(OBJ) [[NSUserDefaults standardUserDefaults] setObject:OBJ forKey:@"userInfo"];[[NSUserDefaults standardUserDefaults] synchronize]
#define USER_INFO [[NSUserDefaults standardUserDefaults] objectForKey: @"userInfo"]
//分享用的
#define USER_ShareState_Set(OBJ) [[NSUserDefaults standardUserDefaults] setObject:OBJ forKey:@"userShareState"];[[NSUserDefaults standardUserDefaults] synchronize]
#define USER_ShareState [[NSUserDefaults standardUserDefaults] objectForKey: @"userShareState"]
//用户弹幕开关
#define USER_BarrageState_Set(OBJ) [[NSUserDefaults standardUserDefaults] setObject:OBJ forKey:@"userBarrageState"];[[NSUserDefaults standardUserDefaults] synchronize]
#define USER_BarrageState [[NSUserDefaults standardUserDefaults] objectForKey: @"userBarrageState"]
//系统亮度
#define USER_SYSTEM_LIGHT_SET(OBJ) [[NSUserDefaults standardUserDefaults] setObject:OBJ forKey:@"systemLight"];[[NSUserDefaults standardUserDefaults] synchronize]
#define USER_SYSTEM_LIGHT [[NSUserDefaults standardUserDefaults] objectForKey: @"systemLight"]

//

#define USER_ID          [[[NSUserDefaults standardUserDefaults] objectForKey: @"userInfo"] objectForKey: @"userId"]
#define USER_MODEL        APP_DELEGATE.userModel

//------------- 常用颜色 ----------------//
#define rgba(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b) rgba(r,g,b,1.0f)
#define HEXCOLOR(hex) [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16)) / 255.0 green:((float)((hex & 0xFF00) >> 8)) / 255.0 blue:((float)(hex & 0xFF)) / 255.0 alpha:1]

#define COLOR_LINE RGB(220,220,220)
#define COLOR_LIGHT_GARY RGB(233,233,233)
#define COLOR_SYSTEM_GARY RGB(244,244,244)
#define COLOR_NAVI RGB(245,185,44)  //255  G196  B56
#define COLOR_Orange_Red RGB(233,152,109)
#define COLOR_BUTTON RGB(228  , 138  , 82)

#define kRandomColor [UIColor colorWithRed:arc4random_uniform(256.0)/255.0 green:arc4random_uniform(256.0)/255.0 blue:arc4random_uniform(256.0)/255.0 alpha:1.0]

/*********字体****************/
#define Font_Regular(SIZE)  [UIFont fontWithName:@"PingFangSC-Regular" size:SIZE]
#define Font_Medium(SIZE)   [UIFont fontWithName:@"PingFangSC-Medium" size:SIZE]

//-----------iPhone X---------------//
#define  LL_iPhoneX (SCREEN_WIDTH == 375.f && SCREEN_HEIGHT == 812.f ? YES : NO)

#define  TabbarHeight  (LL_iPhoneX ? (49.f+34.f) : 49.f)
#define  NaviHeight  (LL_iPhoneX ? (64.f+24.f) : 64.f)

#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
//------------- 尺寸 ----------------//
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
//------------- 其他 ----------------//
//#define weakSelf (__weak typeof(self) weakSelf = self)
#define APP_DELEGATE  ((AppDelegate*)[UIApplication sharedApplication].delegate)
#define Z_PlaceholderImg [UIImage imageNamed:@"Z_PlaceholderImg"]
#define UUID [[[UIDevice currentDevice] identifierForVendor] UUIDString]

//ios 11 table
#define  adjustsScrollViewInsets_NO(scrollView,vc)\
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
if ([UIScrollView instancesRespondToSelector:NSSelectorFromString(@"setContentInsetAdjustmentBehavior:")]) {\
[scrollView   performSelector:NSSelectorFromString(@"setContentInsetAdjustmentBehavior:") withObject:@(2)];\
} else {\
vc.automaticallyAdjustsScrollViewInsets = NO;\
}\
_Pragma("clang diagnostic pop") \
} while (0)






#endif /* GlobalDefines_h */










