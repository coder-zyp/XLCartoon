//
//  AboutUsViewController.m
//  XLCartoon
//
//  Created by yuchutian on 2018/1/30.
//  Copyright © 2018年 XLCR. All rights reserved.
//

#import "AboutUsViewController.h"
#import <YYLabel.h>
#import "NSAttributedString+YYText.h"

@interface AboutUsViewController ()

//@property (nonatomic, strong)UIImageView * iconView;

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于咔咔漫画";
    self.view.backgroundColor = COLOR_SYSTEM_GARY;
    
    [self setupVC];
    
    // Do any additional setup after loading the view.
}

- (void)setupVC{
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    //版本号
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    //app名字
    //    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    //build版本号
    NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
    
    UIImageView * iconView = [[UIImageView alloc] init];
    iconView.image = [UIImage imageNamed:@"iconiPhoneApp_60pt"];
    iconView.layer.cornerRadius = 15.f;
    iconView.layer.masksToBounds = YES;
    
    
    UIImageView * displayNameImg = [[UIImageView alloc] init];
    displayNameImg.image = [UIImage imageNamed:@"register-back"];
    
    UILabel * versionLabel = [[UILabel alloc] init];
    versionLabel.textAlignment = NSTextAlignmentCenter;
    versionLabel.textColor = COLOR_NAVI;
    versionLabel.font = [UIFont systemFontOfSize:15.f];
    versionLabel.text = [NSString stringWithFormat:@"v%@ (%@)",app_Version,app_build];
    
    //去评分
    UIButton * GotoScoreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    GotoScoreBtn.frame = CGRectMake(0, 0, 60, 25);
    GotoScoreBtn.titleLabel.font = [UIFont systemFontOfSize:17.f];
    [GotoScoreBtn setTitle:@"去评分" forState:UIControlStateNormal];
    [GotoScoreBtn addTarget:self action:@selector(GotiScoreAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:GotoScoreBtn];
    //    [GotoScoreBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    UILabel * companyName = [[UILabel alloc] init];
    companyName.textAlignment = NSTextAlignmentCenter;
    companyName.textColor = rgba(124, 125, 127, 1);
    companyName.font = [UIFont systemFontOfSize:14.f];
    companyName.text = @"";//@"沈阳星奥影视文化传媒有限公司";
    
    NSMutableAttributedString * phonetext = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"联系电话:%@",CustomerService_Phone]];
    phonetext.yy_color = rgba(124, 125, 127, 1);
    phonetext.yy_font = [UIFont systemFontOfSize:14.f];
    phonetext.yy_alignment = YYTextVerticalAlignmentCenter;
    [phonetext yy_setTextHighlightRange:NSMakeRange(5, 12) color:[UIColor blueColor] backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        //用于拨打
        NSMutableString * str = [[NSMutableString alloc] initWithFormat:@"tel:%@",CustomerService_Phone];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        
    }];
    YYLabel * phoneLabel = [[YYLabel alloc] init];
    phoneLabel.attributedText = phonetext;
    
    NSMutableAttributedString * wechatText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"客服微信:%@ (点击复制)",CustomerService_Wechat]];
    wechatText.yy_color = rgba(124, 125, 127, 1);
    wechatText.yy_font = [UIFont systemFontOfSize:14.f];
    wechatText.yy_alignment = YYTextVerticalAlignmentCenter;
    [wechatText yy_setTextHighlightRange:NSMakeRange(wechatText.length-6, 6) color:[UIColor blueColor] backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        
        [SVProgressHUD showSuccessWithStatus:@"复制成功!"];
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = CustomerService_Wechat;
    }];
    
    YYLabel * wechatLabel = [[YYLabel alloc] init];
    wechatLabel.attributedText = wechatText;
    
    [self.view sd_addSubviews:@[iconView
                                ,displayNameImg
                                ,versionLabel
                                ,wechatLabel
                                ,phoneLabel
                                ,companyName]];
    
    iconView.sd_layout
    .centerXIs(SCREEN_WIDTH/2)
    .topSpaceToView(self.view, 50+NaviHeight)
    .heightIs(SCREEN_WIDTH/3.5)
    .widthIs(SCREEN_WIDTH/3.5);
    
    displayNameImg.sd_layout
    .centerXIs(SCREEN_WIDTH/2)
    .topSpaceToView(iconView, 20)
    .heightIs(20)
    .widthIs(SCREEN_WIDTH/5);
    
    versionLabel.sd_layout
    .centerXIs(SCREEN_WIDTH/2)
    .topSpaceToView(displayNameImg, 15)
    .heightIs(15)
    .widthIs(SCREEN_WIDTH);
    
    wechatLabel.sd_layout
    .centerXIs(SCREEN_WIDTH/2)
    .bottomSpaceToView(self.view, 30)
    .heightIs(15)
    .widthIs(SCREEN_WIDTH);
    
    phoneLabel.sd_layout
    .centerXIs(SCREEN_WIDTH/2)
    .bottomSpaceToView(wechatLabel, 15)
    .heightIs(15)
    .widthIs(SCREEN_WIDTH);
    
    companyName.sd_layout
    .centerXIs(SCREEN_WIDTH/2)
    .bottomSpaceToView(phoneLabel, 15)
    .heightIs(15)
    .widthIs(SCREEN_WIDTH);
}

- (void)GotiScoreAction:(id)sender
{
    
    NSString *reviewURL = @"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=1346479687&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8";
    if (@available(iOS 11.0, *)) {
        reviewURL =  @"itms-apps://itunes.apple.com/cn/app/id1346479687?mt=8&action=write-review";
    }
//    static NSString * const reviewURL = @"itms-apps://itunes.apple.com/app/id1346479687?type=Purple+Software";
    [SVProgressHUD show];
    //    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:reviewURL]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:reviewURL] options:nil completionHandler:^(BOOL success) {
        [SVProgressHUD dismiss];
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

