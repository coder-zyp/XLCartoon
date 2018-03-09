//
//  PrivacyAgreement.m
//  XLCartoon
//
//  Created by Amitabha on 2018/1/30.
//  Copyright © 2018年 XLCR. All rights reserved.
//

#import "PrivacyAgreement.h"
#import <WebKit/WebKit.h>
@interface PrivacyAgreement() <WKNavigationDelegate>

@property (nonatomic,strong) WKWebView * webview;
@property (nonatomic,strong) NSURL * url;
@end
@implementation PrivacyAgreement
-(void)viewDidLoad{
    
    [super viewDidLoad];
    NSString *urlStr = [[NSBundle mainBundle] pathForResource:self.fileName ofType:nil];
    self.url = [NSURL fileURLWithPath:urlStr];
    self.title = [[self.fileName componentsSeparatedByString:@"."]firstObject];
    self.view.backgroundColor = [UIColor whiteColor];
    
    WKWebViewConfiguration *config = [WKWebViewConfiguration new];
    //初始化偏好设置属性：preferences
    config.preferences = [WKPreferences new];
    //The minimum font size in points default is 0;
    config.preferences.minimumFontSize = 10;
    //是否支持JavaScript
    config.preferences.javaScriptEnabled = YES;
    //不通过用户交互，是否可以打开窗口
    config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
    
    CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    _webview = [[WKWebView alloc] initWithFrame:frame ];
    _webview.navigationDelegate = self;
    [self.view addSubview:_webview];

    //加载页面，self.urlString是网址
    [_webview loadRequest:[NSURLRequest requestWithURL:self.url]];
    [SVProgressHUD show];
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    
}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    [SVProgressHUD dismiss];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
