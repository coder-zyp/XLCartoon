//
//  LoginViewController.m
//  XLCartoon
//
//  Created by Amitabha on 2018/1/15.
//  Copyright © 2018年 XLCR. All rights reserved.
//

#import "LoginViewController.h"
#import <objc/runtime.h>
#import "UITextField+CSText.h"

#import "registerViewController.h"
//#import "FindPasswordViewController.h"
//#import "WRNavigationBar.h"
#import <UMSocialCore/UMSocialCore.h>

#import <UMAnalytics/MobClick.h>

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COLOR_NAVI;
//    [WRNavigationBar wr_setDefaultNavBarTintColor:[UIColor blackColor]];
//    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"忘记密码" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.size = CGSizeMake(80, 20);
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn addTarget:self action:@selector(findPassWord) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    [self setupSubview];
    
    // Do any additional setup after loading the view from its nib.
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
}
-(void)findPassWord{
    registerViewController * vc = [[registerViewController alloc]init];
    vc.viewtype = viewTypeFindPassword;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)setupSubview{
    [_phoneTextField setCs_maxLength:11];
    _phoneTextField.keyboardType = UIKeyboardTypeDecimalPad;
    _phoneTextField.text = USER_MODEL.phone;
    _phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    UIView * buttonView = [[UIView alloc]init];
    [self.view addSubview:buttonView];
    CGFloat width = 300;
    buttonView.frame = CGRectMake((SCREEN_WIDTH-width)/2, SCREEN_HEIGHT-80, width, 70);
    
    NSMutableArray * titles = [NSMutableArray arrayWithArray:@[@"微信",@"微博"]] ;
    
    if ([[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_QQ]) {
        [titles insertObject:@"QQ" atIndex:1];
    }
    
    for (int i = 0; i < titles.count; i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"login-%@",titles[i]]]forState:UIControlStateNormal];
        [buttonView addSubview:btn];
        [btn addTarget:self action:@selector(otherLoginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = CGRectMake(i*width/titles.count, 0, width/titles.count, 70);
    }
    
    
    UILabel * lineLabel = [UILabel new];
    lineLabel.textAlignment = NSTextAlignmentCenter;
    lineLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:lineLabel];
    lineLabel.text = @"———  其他登录方式  ———";
    lineLabel.sd_layout.centerXEqualToView(self.view).widthRatioToView(buttonView,1.2).heightIs(20).bottomSpaceToView(buttonView,0);
}
- (IBAction)loginBtnClick:(id)sender {
    NSDictionary * param = @{@"phone" : _phoneTextField.text,
                             @"userPassword" : _passwordTextField.text};
    [self LoginWithParam:param url:URL_LOGIN];

}
- (IBAction)registerBtnClick:(id)sender {
    
    registerViewController * vc = [[registerViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)getAuthWithUserInfoFrom:(UMSocialPlatformType)type
{
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:type currentViewController:nil completion:^(id result, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
        } else {
            UMSocialUserInfoResponse *resp = result;
            
            // 第三方登录数据(为空表示平台未提供)
            // 授权数据
//            NSLog(@" uid: %@", resp.uid);
//            NSLog(@" openid: %@", resp.openid);
//            NSLog(@" accessToken: %@", resp.accessToken);
//            NSLog(@" refreshToken: %@", resp.refreshToken);
//            NSLog(@" expiration: %@", resp.expiration);
//            
//            // 用户数据
//            NSLog(@" name: %@", resp.name);
//            NSLog(@" iconurl: %@", resp.iconurl);
//            NSLog(@" gender: %@", resp.unionGender);
//            
            // 第三方平台SDK原始数据
            NSLog(@" originalResponse: %@", resp.originalResponse);
            NSString * sex = [resp.unionGender isEqualToString:@"男"] ?  @"1" : [resp.unionGender isEqualToString:@"女"] ? @"2" : @"0";
            NSMutableDictionary * param =[NSMutableDictionary dictionaryWithDictionary:
            @{
            @"openid":resp.uid,
            @"sex": sex ,
            @"username":resp.name,
            @"headimgurl":resp.iconurl,
            @"deviceId" :  UUID,
            @"systemVersion" : [[UIDevice currentDevice] systemVersion]
            //                                     @"userId":USER_MODEL.userId ? USER_MODEL.userId :@""
            }];
            [param setObject:[resp.originalResponse objectForKey:@"province" ] forKey:@"province"];
            [param setObject:[resp.originalResponse objectForKey:@"city" ] forKey:@"city"];
            if (type == UMSocialPlatformType_QQ) {
                [param setObject:@"APP_IOS_QQ" forKey:@"platformIndex"];
            }else if(type == UMSocialPlatformType_WechatSession){
                [param setObject:@"APP_IOS_WX" forKey:@"platformIndex"];
            }else if(type == UMSocialPlatformType_Sina){
                [param setObject:@"APP_IOS_SINA" forKey:@"platformIndex"];
            }
            [self LoginWithParam:param url:URL_LOGIN_OTHER];
        }
    }];
}
-(void)otherLoginBtnClick:(UIButton *)btn{
    if (btn.tag == 1) {
        [self getAuthWithUserInfoFrom:UMSocialPlatformType_QQ];
    }else if (btn.tag == 2) {
        [self getAuthWithUserInfoFrom:UMSocialPlatformType_Sina];
    }else{
        [self getAuthWithUserInfoFrom:UMSocialPlatformType_WechatSession];
    }
}
-(void)LoginWithParam:(NSDictionary *)param url:(NSString *)url{

    [SVProgressHUD show];
    [AfnManager postUserAction:url param:param Sucess:^(NSDictionary *responseObject) {
        USER_SET(OBJ(responseObject));
//        友盟在统计用户
        [MobClick profileSignInWithPUID:[param objectForKey: @"deviceId"] provider:[param objectForKey: @"platformIndex"]];
//        [MobClick profileSignInWithPUID:[param ] provider:@"WB"];
        APP_DELEGATE.window.rootViewController = APP_DELEGATE.tabBarVC;
        [SVProgressHUD showSuccessWithStatus:Msg(responseObject)];
    }];
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
