//
//  registerViewController.m
//  XLCartoon
//
//  Created by Amitabha on 2018/1/15.
//  Copyright © 2018年 XLCR. All rights reserved.
//

#import "registerViewController.h"
#import "JKCountDownButton.h"
#import "UITextField+CSText.h"
//#import <WRNavigationBar.h>
#import <YYText.h>
#import "PrivacyAgreement.h"
@interface registerViewController ()<UITextFieldDelegate>
@property (nonatomic,strong) NSArray  <UITextField  *> * textFieldArr;
@property (nonatomic,strong) JKCountDownButton * countDownCode;
@property (nonatomic,strong) NSString * codeId;
@property (nonatomic,strong) YYLabel * userAgreementLabel;
@end

@implementation registerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COLOR_NAVI;
    [self setTextField];
    
    // Do any additional setup after loading the view from its nib.
}

-(YYLabel *)userAgreementLabel{
    if (!_userAgreementLabel) {
        _userAgreementLabel = [[YYLabel alloc]init];
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"注册视为同意\n《隐私协议》《服务协议》《未成年人协议》"];
        [text yy_setTextHighlightRange:NSMakeRange(7, 6)
                                 color:[UIColor blueColor]
                       backgroundColor:[UIColor clearColor]
                             tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect){
                                 [self AgrrementPushWithFileName:@"隐私协议.docx"];
                             }];
        [text yy_setTextHighlightRange:NSMakeRange(13, 6)
                                 color:[UIColor blueColor]
                       backgroundColor:[UIColor clearColor]
                             tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect){
                                 [self AgrrementPushWithFileName:@"服务协议.docx"];
                             }];
        [text yy_setTextHighlightRange:NSMakeRange(19, 8)
                                 color:[UIColor blueColor]
                       backgroundColor:[UIColor clearColor]
                             tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect){                                                        [self AgrrementPushWithFileName:@"未成年人协议.docx"];
                             }];
        [text yy_setFont:[UIFont systemFontOfSize:16] range:NSMakeRange(0, 7)];
        [text yy_setFont:[UIFont systemFontOfSize:13] range:NSMakeRange(7, text.length-7)];
        [text yy_setLineSpacing:7 range:NSMakeRange(0, text.length)];
        _userAgreementLabel.attributedText = text;
    }
//    _userAgreementLabel.font = Font_Regular(13);
    _userAgreementLabel.textAlignment = NSTextAlignmentCenter;
    _userAgreementLabel.numberOfLines = 0;
    return _userAgreementLabel;
}
-(void)AgrrementPushWithFileName:(NSString *)fileName{

    PrivacyAgreement * AgreementVC = [PrivacyAgreement new];
    AgreementVC.fileName = fileName;
    [self.navigationController pushViewController:AgreementVC animated:YES];
}
- (void)GetSMS:(id)sender{

    NSMutableDictionary * param = [NSMutableDictionary dictionaryWithDictionary: @{@"phone":_textFieldArr[0].text}];
    if (viewTypeFindPassword) [param setObject:@"1" forKey:@"condition"];
    [AfnManager postUserAction:URL_SMS param:param Sucess:^(NSDictionary *responseObject) {
        self.codeId = OBJ(responseObject);
    }];
    
}
- (void)RegisterAction:(id)sender{
    
    if (_textFieldArr[1].text.length != 5){
        [SVProgressHUD showErrorWithStatus:@"验证码位数错误"];
        return;
    }
    if (_textFieldArr[2].text.length < 6){
        [SVProgressHUD showErrorWithStatus:@"密码位数不足"];
        return;
    }
    if (self.codeId == nil){
        [SVProgressHUD showErrorWithStatus:@"验证码失效"];
        return;
    }
    
    NSDictionary * dict = @{
                             @"phone" : _textFieldArr[0].text,
                             @"code" : _textFieldArr[1].text,
                             @"userPassword" : _textFieldArr[2].text,
                             @"id" : self.codeId
                             };
    NSString * url;
    NSMutableDictionary * param = [NSMutableDictionary dictionaryWithDictionary:dict];
    switch (self.viewtype) {
        case viewTypeAddPhone:
            url = URL_SAVE_PHONG;
            break;
        case viewTypeFindPassword:
            url = URL_FIND_PASSWORD;
            break;
        case viewTypeRegister:
            url = URL_REGISTER;
            [param setValuesForKeysWithDictionary:@{@"platformIndex" : @"APP_IOS_TEL",
                                                    @"deviceId" :  [[[UIDevice currentDevice] identifierForVendor] UUIDString],
                                                    @"systemVersion" : [[UIDevice currentDevice] systemVersion]}];
            break;
        default:
            break;
    }
    [AfnManager postUserAction:url param:param Sucess:^(NSDictionary *responseObject) {
        [SVProgressHUD showSuccessWithStatus:Msg(responseObject)];
        switch (self.viewtype) {
            case viewTypeAddPhone:
                [self.navigationController popViewControllerAnimated:YES];
                break;
            case viewTypeFindPassword:
                [self.navigationController popViewControllerAnimated:YES];
                break;
            case viewTypeRegister:
            {
                USER_SET(OBJ(responseObject));
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    APP_DELEGATE.window.rootViewController = APP_DELEGATE.tabBarVC;
                    [MobClick profileSignInWithPUID:[param objectForKey: @"deviceId"] provider:[param objectForKey: @"platformIndex"]];
                });
                break;
            }
            default:
                break;
        }
    }];
}
-(void)setTextField{
    
    UIImage * image = [UIImage imageNamed:@"register-back"];
    UIImageView * backImageView = [[UIImageView alloc]initWithImage:image];
    [self.view addSubview:backImageView];
    backImageView.sd_layout.centerXEqualToView(self.view).yIs(SCREEN_HEIGHT/6.5).widthRatioToView(self.view, 0.4)
    .autoHeightRatio(image.size.height/image.size.width);
    
    UIView * textsView = [UIView new];
    [self.view addSubview:textsView];
    textsView.sd_layout.topSpaceToView(backImageView, 35).centerXEqualToView(self.view).widthRatioToView(self.view, 0.7);

    NSArray * placeholders = @[@"输入手机号",@"验证码",@"设置6~18位数字或字母"];
    NSArray * imageName = @[@"手机",@"验证码",@"密码"];
    NSMutableArray * arr = [NSMutableArray array];
    for (int i=0; i<3; i++) {
        UIView * view = [UIView new];
        [textsView addSubview:view];
        view.sd_layout.heightIs(40);
        
        UIView * textFieldView = [UIView new];
        textFieldView.backgroundColor = [UIColor whiteColor];
        textFieldView.layer.cornerRadius = 10;
        [view addSubview:textFieldView];
        textFieldView.sd_layout.leftEqualToView(view).topEqualToView(view).bottomEqualToView(view)
        .widthRatioToView(view, i==1 ? 0.6 : 1);
        
        UITextField * textField =[[UITextField alloc]init];
        [arr addObject:textField];
        [textFieldView addSubview:textField];
        textField.placeholder = placeholders[i];
        textField.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 25+13, 0, 0));
        [textField setFont:[UIFont systemFontOfSize:16]];
        
        UIImageView * icon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName[i]]];
        [textFieldView addSubview:icon];
        icon.sd_layout.widthIs(25).heightEqualToWidth().leftSpaceToView(textFieldView, 8)
        .centerYEqualToView(textFieldView);
        if (i == 2) {
            textField.secureTextEntry=YES;
            textField.cs_maxLength = 18;
            textField.delegate = self;
            
        }else{
            textField.keyboardType = UIKeyboardTypeDecimalPad;
            if (i==1) {
                [view addSubview:self.countDownCode];
                _countDownCode.sd_layout.rightSpaceToView(view, 0).topEqualToView(view).
                leftSpaceToView(textField, 15).bottomEqualToView(view);
            }else{
                textField.cs_maxLength = 11;
                [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
            }
        }
    }
    _textFieldArr = arr;
    
    
    [textsView setupAutoWidthFlowItems:textsView.subviews withPerRowItemsCount:1 verticalMargin:10 horizontalMargin:0 verticalEdgeInset:0 horizontalEdgeInset:0];
    
    UIButton * btn = [UIButton new];
    btn.backgroundColor = RGB(72, 34, 14);
    switch (self.viewtype) {
        case viewTypeAddPhone:
            [btn setTitle:@"绑定手机" forState:UIControlStateNormal];
            break;
        case viewTypeFindPassword:
            [btn setTitle:@"找回密码" forState:UIControlStateNormal];
            break;
        case viewTypeRegister:
            [btn setTitle:@"注册" forState:UIControlStateNormal];
            break;
        default:
            break;
    }
    
    [self.view addSubview:btn];
    btn.layer.cornerRadius = 10;
    [btn addTarget:self action:@selector(RegisterAction:) forControlEvents:UIControlEventTouchUpInside];
    btn.sd_layout.heightIs(45).topSpaceToView(textsView, 35).
    centerXEqualToView(textsView).widthRatioToView(textsView, 1);
    
    if (self.viewtype == viewTypeRegister) {
        [self.view addSubview:self.userAgreementLabel];
        _userAgreementLabel.sd_layout.topSpaceToView(btn, 8).heightIs(60).widthIs(SCREEN_WIDTH).rightEqualToView(self.view);
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
//    NSLog(@"%ld,%@",textField.text.length,string);
    if (textField.text.length == 18 && ![string isEqualToString:@""]) {
        [SVProgressHUD showInfoWithStatus:@"不能再输入了"];
    }
    return YES;
}
-(JKCountDownButton *)countDownCode{
    if (!_countDownCode) {
        _countDownCode =[JKCountDownButton buttonWithType:UIButtonTypeCustom];
        _countDownCode.backgroundColor = [UIColor lightGrayColor];
        _countDownCode.enabled = NO;
        _countDownCode.layer.cornerRadius = 10;
        [self.view addSubview:_countDownCode];
        _countDownCode.titleLabel.font = Font_Regular(14);
        [_countDownCode addTarget:self action:@selector(GetSMS:) forControlEvents:UIControlEventTouchUpInside];
        [_countDownCode setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_countDownCode countDownButtonHandler:^(JKCountDownButton*sender, NSInteger tag) {
            sender.enabled = NO;
            [sender startCountDownWithSecond:60];
            [sender countDownChanging:^NSString *(JKCountDownButton *countDownButton,NSUInteger second) {
                NSString *title = [NSString stringWithFormat:@"剩余%zd秒",second];
                return title;
            }];
            [sender countDownFinished:^NSString *(JKCountDownButton *countDownButton, NSUInteger second) {
                countDownButton.enabled = YES;
                return @"重新获取";
            }];
        }];
    }
    return _countDownCode;
}
-(void)textFieldDidChange :(UITextField *)theTextField{
//    NSLog( @"text changed: %@", theTextField.text);
    
    if (theTextField.text.length==11) {
        _countDownCode.backgroundColor = RGB(72, 34, 14);
        _countDownCode.enabled = YES;
    }else{
        _countDownCode.backgroundColor = [UIColor lightGrayColor];
        _countDownCode.enabled = NO;
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
