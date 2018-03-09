//
//  FindPasswordViewController.m
//  test
//
//  Created by Amitabha on 2017/9/30.
//  Copyright © 2017年 张允鹏. All rights reserved.
//

#import "FindPasswordViewController.h"
#import "SDAutoLayout.h"
#import "UITextField+CSText.h"

@interface FindPasswordViewController()

@property (nonatomic,strong) UITextField  * phoneTextField;
@property (nonatomic,strong) UITextField  * passwordTextField;
@property (nonatomic,strong) UITextField  * againInputPasswordTextField;
@property (nonatomic,strong) UITextField  * messageCodeTextField;
@property (nonatomic,strong) NSString * codeId;

@end

@implementation FindPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    self.title= @"找回密码";
    //手机号输入框
    _phoneTextField =[[UITextField alloc]init];
    _phoneTextField.placeholder=@"手机号/邮箱/用户名";
    [_phoneTextField setCs_maxLength:11];
    _phoneTextField.keyboardType = UIKeyboardTypeDecimalPad;
    _phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:_phoneTextField];
//    [_phoneTextField setLeftImage:[UIImage imageNamed:@"输入手机号"] height:45 imageWidth:25];
    [_phoneTextField setFont:[UIFont systemFontOfSize:16]];
    [_phoneTextField setPlaceholderColor:[UIColor grayColor]];
    
    //验证码输入框
    _messageCodeTextField = [[UITextField alloc]init];
    [self.view addSubview:_messageCodeTextField];
    NSMutableAttributedString * aStr = [[NSMutableAttributedString alloc]initWithString:@"输入验证码(验证码将发送到手机)"];
    [aStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, 5)];
    [aStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(5, aStr.length-5)];
    [aStr addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0, aStr.length)];
    _messageCodeTextField.attributedPlaceholder = aStr;
    
    UIButton * sendCodeBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    sendCodeBtn.backgroundColor = RGB(255,164,0);
    sendCodeBtn.layer.cornerRadius = 8;
    [sendCodeBtn addTarget:self action:@selector(GetSMS:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendCodeBtn];
    sendCodeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [sendCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    
    //密码输入框
    _passwordTextField =[[UITextField alloc]init];
    _passwordTextField.placeholder=@"请输入新密码";
    _passwordTextField.secureTextEntry=YES;
    [self.view addSubview:_passwordTextField];
//    [_passwordTextField setLeftImage:[UIImage imageNamed:@"密码"] height:45 imageWidth:25];
    [_passwordTextField setFont:[UIFont systemFontOfSize:16]];
    [_passwordTextField setPlaceholderColor:[UIColor grayColor]];
    
    //重复密码输入框
    _againInputPasswordTextField = [[UITextField alloc]init];
    _againInputPasswordTextField.placeholder=@"再次输入新密码";
    _againInputPasswordTextField.secureTextEntry=YES;
    [self.view addSubview:_againInputPasswordTextField];
//    [_againInputPasswordTextField setLeftImage:[UIImage imageNamed:@"密码"] height:45 imageWidth:25];
    [_againInputPasswordTextField setFont:[UIFont systemFontOfSize:16]];
    [_againInputPasswordTextField setPlaceholderColor:[UIColor grayColor]];
    
    //确认按钮
    UIButton * registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    registerBtn.backgroundColor = RGB(255,164,0);
    registerBtn.layer.cornerRadius = 8;
    [registerBtn addTarget:self action:@selector(FindPwdAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerBtn];
    [registerBtn setTitle:@"使用新密码登录" forState:UIControlStateNormal];
    
    //线条
    [self addBottomLineToView:_passwordTextField];
    [self addBottomLineToView:_phoneTextField];
    [self addBottomLineToView:_againInputPasswordTextField];
    
    //布局
    _phoneTextField.sd_layout
    .leftSpaceToView(self.view,20)
    .rightSpaceToView(self.view,20)
    .topSpaceToView(self.view,20).heightIs(45);
    
    _messageCodeTextField.sd_layout
    .centerXEqualToView(self.view)
    .widthRatioToView(_phoneTextField, 1)
    .topSpaceToView(_phoneTextField, 10)
    .heightIs(45);
    
    sendCodeBtn.sd_layout
    .rightEqualToView(_messageCodeTextField)
    .bottomEqualToView(_messageCodeTextField)
    .heightIs(40).widthIs(80);
    
    UIView * line = [UIView new];
    line.backgroundColor = [UIColor lightGrayColor];
    [_messageCodeTextField addSubview:line];
    line.sd_layout.leftEqualToView(line.superview).bottomEqualToView(line.superview).rightSpaceToView(sendCodeBtn, 24).heightIs(0.7);
    
    _passwordTextField.sd_layout
    .leftEqualToView(_phoneTextField)
    .rightEqualToView(_phoneTextField)
    .topSpaceToView(sendCodeBtn,10).heightIs(45);
    
    _againInputPasswordTextField.sd_layout
    .widthRatioToView(_passwordTextField, 1)
    .centerXEqualToView(_passwordTextField)
    .topSpaceToView(_passwordTextField, 10).heightIs(45);
    
    registerBtn.sd_layout
    .topSpaceToView(_againInputPasswordTextField,32)
    .centerXEqualToView(self.view)
    .widthRatioToView(_passwordTextField,1).heightIs(45);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)HidePassworkBtnClick:(UIButton *)btn{
    btn.selected = !btn.isSelected;
    if (btn.isSelected) {
        _passwordTextField.secureTextEntry = NO;
    }else{
        _passwordTextField.secureTextEntry = YES;
    }
}
-(void)addBottomLineToView:(UIView *)view{
    UIView * line = [UIView new];
    line.backgroundColor = [UIColor lightGrayColor];
    [view addSubview:line];
    line.sd_layout.leftEqualToView(line.superview).rightEqualToView(line.superview)
    .bottomEqualToView(line.superview).heightIs(0.5);
}


#pragma mark - FindPassWord HTTP

- (void)GetSMS:(id)sender{
    
    
    NSDictionary * param = @{
                             @"phone" : _phoneTextField.text,
                             @"userId" : USER_ID
                             };
    [SVProgressHUD show];
    [[AFHTTPSessionManager manager] POST: URL_SMS  parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",[responseObject yy_modelToJSONString]);
        if (IS_SUCCESS(responseObject) ) {
            [SVProgressHUD showSuccessWithStatus:Msg(responseObject)];
        }else{
            [SVProgressHUD showErrorWithStatus:Msg(responseObject)];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        NSLog(@"%@",error);
    }];
}

- (void)FindPwdAction:(id)sender{
    
    if ([_passwordTextField.text isEqualToString:_againInputPasswordTextField.text]) {
        
        
        NSDictionary * param = @{
                                 @"phone" : _phoneTextField.text,
                                 @"userPassword" : _passwordTextField.text
                                 };
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager POST:BASE_URL URL_LOGIN  parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"requestDataLIstInfo failure: %@", error);
        }];
        
    }else{
        
//        [self popPromptViewWithMsg:@"两次输入密码不一致，请重新输入"];
        
        
    }
    
    
    
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
