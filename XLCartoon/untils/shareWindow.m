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
@property (nonatomic, strong) cartoon * cartoonModel;
@property (nonatomic, strong) NSString * cartoonSetId;
@property (nonatomic, strong) NSMutableString * shareUrl;
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
+(shareWindow *)shareWithModel:(cartoon *)model cartoonSetId:(NSString *)cartoonSetId sucess:(shareSucessBlock)sucess{
    [shareWindow shareWithModel:model cartoonSetId:cartoonSetId];
    [shareWindow share].sucessBlock = sucess;
    return [shareWindow share];
}
+(shareWindow *)shareWithModel:(cartoon *)model cartoonSetId:(NSString *)cartoonSetId{
    shareWindow *window = [shareWindow share];
    
    window.cartoonSetId = cartoonSetId;
    window.cartoonModel = model;
    [window show];
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

        NSArray * titles   = @[@"微信好友",@"微信朋友圈",@"QQ",@"QQ空间",@"新浪微博"];
        
        for (int i = 0; i<5; i++) {
            
            UIView * view = [UIView new];
            [btnView addSubview:view];
            view.sd_layout.heightIs(70);
            
            UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
            NSString * imageName = [NSString stringWithFormat:@"share-%@",titles[i]];
            [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
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
        case 0:
            type = UMSocialPlatformType_WechatSession;
            break;
        case 1:
            type = UMSocialPlatformType_WechatTimeLine;
            break;
        case 2:
            type = UMSocialPlatformType_QQ;
            break;
        case 3:
            type = UMSocialPlatformType_Qzone;
            break;
        case 4:
            type = UMSocialPlatformType_Sina;
            break;
        default:
            type = UMSocialPlatformType_UnKnown;
            break;
    }
    [self shareWebPageToPlatformType:type];
}
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
//[param setObject:@"APP_IOS_WX" forKey:@"platformIndex"];
    NSMutableDictionary * param =[NSMutableDictionary dictionaryWithDictionary: @{
                             @"platformIndex" :@"qd",
                             }];
    if (self.cartoonSetId) {
        [param setObject:self.cartoonSetId forKey:@"cartoonSetId"];
    }
    if (self.cartoonModel) {
        [param setObject:self.cartoonModel.id forKey:@"cartoonId"];
    }
    
    [AfnManager postWithUrl:BASE_URL @"qpp/comic/add/cartoon/lianjie.do" param:param Sucess:^(NSDictionary *responseObject) {
        
    
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];

    NSString * title;
    NSString * text;
    __block id shareIcon;

    
    if (self.cartoonModel) {
        title = [NSString stringWithFormat:@"有毒！《%@》这部漫画超级好看",self.cartoonModel.cartoonName];
        text = self.cartoonModel.introduc;
        shareIcon = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.cartoonModel.sharePhoto]];
        shareIcon = [UIImage imageWithData:shareIcon];
        // [NSURL URLWithString: self.cartoonModel.sharePhoto];
        [self.shareUrl appendString:[NSString stringWithFormat:@"?cartoonId=%@",self.cartoonModel.id]];
        if (self.cartoonSetId) {
            [self.shareUrl appendString:[NSString stringWithFormat:@"&cartoonSetId=%@",self.cartoonSetId]];
        }
    }else{
        title = @"有毒！咔咔平台的漫画超级好看";
        text = @"下载APP,做新手任务看漫画";
        shareIcon = [UIImage imageNamed:@"AppIcon"];
        
    }

    
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:text thumImage:shareIcon];
    //设置网页地址
    shareObject.webpageUrl = Msg(responseObject);
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    self.shareState = shareState_NoResult;
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
//            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
              self.shareState = shareState_Fail;
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                self.shareState = shareState_Success;
                [shareWindow shareSuccess];
            }else{
                self.shareState = shareState_Fail;
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
    }];
    }];
}
-(void)setShareState:(shareState)shareState{
    USER_ShareState_Set(@(shareState));
}

-(shareState)shareState{
    return [USER_ShareState integerValue];
}

+(void)shareSuccess{

    NSString * url = [shareWindow share].cartoonModel == nil ? URL_SHARE_BACK : URL_SHARE_CARTOON_BACK;
    [shareWindow share].shareState = shareState_None;
    [AfnManager postUserAction:url param:nil Sucess:^(NSDictionary *responseObject) {
        if ([shareWindow share].sucessBlock) {
            [shareWindow share].sucessBlock();
        }
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
