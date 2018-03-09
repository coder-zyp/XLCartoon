//
//  shareWindow.m
//  XLCartoon
//
//  Created by Amitabha on 2018/1/10.
//  Copyright © 2018年 XLCR. All rights reserved.
//

#import "shareWindow.h"
#import "FSCustomButton.h"
#import <UMSocialCore/UMSocialCore.h>

@interface shareWindow()
@property (nonatomic,strong) UIView * backView;

@end

@implementation shareWindow

+(shareWindow *)share{
    static shareWindow *window = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (window == nil) {
            window = [[shareWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        }
    });
    
    return window;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _backView = [UIView new];
        _backView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_backView];
        _backView.sd_layout.bottomEqualToView(self).rightEqualToView(self).leftEqualToView(self);
        
        UILabel * label = [UILabel new];
        label.text = @"分享";
        label.textAlignment = NSTextAlignmentCenter;
        [_backView addSubview:label];
        label.sd_layout.leftEqualToView(_backView).rightEqualToView(_backView).
        topSpaceToView(_backView, 15).autoHeightRatio(0);
        
        UIView * btnView = [UIView new];
        [_backView addSubview:btnView];
        btnView.sd_layout.topSpaceToView(label, 0).leftEqualToView(_backView).widthIs(SCREEN_WIDTH).autoHeightRatio(0);
        
        NSArray * imgNames = @[@"login_icon0",@"login_icon0",@"login_icon1",@"login_icon1",@"login_icon2"];
        NSArray * titles   = @[@"微信好友",@"微信朋友圈",@"QQ",@"QQ空间",@"新浪微博"];
        
        for (int i = 0; i<5; i++) {
            
            UIView * view = [UIView new];
            [btnView addSubview:view];
            view.sd_layout.heightIs(70);
            
            UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setImage:[UIImage imageNamed:imgNames[i]] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            btn.tag = i;
            [btn addTarget:self action:@selector(ShareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:btn];
            
            UILabel * label =[UILabel new];
            label.text = titles[i];
            label.font = [UIFont systemFontOfSize:15];
            label.textColor = [UIColor grayColor];
            label.textAlignment = NSTextAlignmentCenter;
            [view addSubview:label];
            
            
            btn.sd_layout.topSpaceToView(view, 0).centerXEqualToView(view).widthIs(50).heightIs(50);
            label.sd_layout.spaceToSuperView(UIEdgeInsetsMake(55, 0, 0, 0));
            
        }

        [btnView setupAutoWidthFlowItems:btnView.subviews withPerRowItemsCount:4 verticalMargin:15 horizontalMargin:0 verticalEdgeInset:15 horizontalEdgeInset:15];
        
        UIButton * cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.backgroundColor = COLOR_SYSTEM_GARY;
        [_backView addSubview:cancelBtn];
        [cancelBtn setTitle:@"取消分享" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        cancelBtn.sd_layout.topSpaceToView(btnView, 0).heightIs(50)
        .leftEqualToView(_backView).rightEqualToView(_backView);
        [cancelBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
        
        [_backView setupAutoHeightWithBottomView:cancelBtn bottomMargin:0];
        
        UIButton * btn = [ UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = self.bounds;
        btn.backgroundColor =  rgba(0, 0, 0, 0.7);
        [self insertSubview:btn atIndex:0];
        [btn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}
-(void)ShareBtnClick:(UIButton *)btn{
    UMSocialPlatformType type;
    switch (btn.tag) {
        case 2:
            type = UMSocialPlatformType_QQ;
            break;
        default:
            break;
    }
    [self shareWebPageToPlatformType:type];
}
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];

    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:_shareTitle descr:_shareText thumImage:_shareIcon];
    //设置网页地址
    shareObject.webpageUrl = @"http://mobile.umeng.com/social";
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}
-(void)close{
    self.hidden = YES;
}
- (void)show
{
    [self makeKeyWindow];
    self.hidden = NO;
}

@end
