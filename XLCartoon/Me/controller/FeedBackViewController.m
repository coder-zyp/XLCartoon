//
//  FeedBackViewController.m
//  XLCartoon
//
//  Created by yuchutian on 2018/1/4.
//  Copyright © 2018年 XLCR. All rights reserved.
//

#import "FeedBackViewController.h"

#define kMaxLength  500

@interface FeedBackViewController ()<UITextViewDelegate>

@property (nonatomic, strong)UIView * backgroundView;
@property (nonatomic, strong)UITextView * textView;
@property (nonatomic, strong)UILabel * placeHolderLabel;
@property (nonatomic, strong)UILabel * wordNumberLabel;
@property (nonatomic, strong)UIButton * submitBtn;

@end

@implementation FeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"意见反馈";
    self.view.backgroundColor = COLOR_SYSTEM_GARY;
    //导航栏自适应关闭 防止textview文字水平居中
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setupVC];
    // Do any additional setup after loading the view.
}

- (void)setupVC
{
    [self.view sd_addSubviews:@[self.backgroundView
                                ,self.submitBtn]];
    
    self.backgroundView.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .topSpaceToView(self.view, NaviHeight)
    .heightIs(SCREEN_HEIGHT/3);
    
    self.submitBtn.sd_layout
    .leftSpaceToView(self.view, 32.5)
    .rightSpaceToView(self.view, 32.5)
    .topSpaceToView(self.backgroundView, 35)
    .heightIs(40);
    
    [self.backgroundView sd_addSubviews:@[self.textView
                                          ,self.placeHolderLabel
                                          ,self.wordNumberLabel]];
    
    self.textView.sd_layout
    .leftSpaceToView(self.backgroundView, 20)
    .rightSpaceToView(self.backgroundView ,20)
    .topSpaceToView(self.backgroundView, 15)
    .bottomSpaceToView(self.backgroundView, 15);
    
    self.placeHolderLabel.sd_layout
    .leftSpaceToView(self.backgroundView, 30)
    .rightSpaceToView(self.backgroundView, 20)
    .topSpaceToView(self.backgroundView, 20)
    .heightIs(20);
    
    self.wordNumberLabel.sd_layout
    .rightSpaceToView(self.backgroundView, 5)
    .bottomSpaceToView(self.backgroundView, 5)
    .widthIs(40)
    .heightIs(15);
}
#pragma mark - textViewDelegate

//限制UITextview的字符串长度
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    //限制输入长度
    NSString *lang = [(UITextInputMode*)[[UITextInputMode activeInputModes] firstObject] primaryLanguage]; // 键盘输入模式  
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输
        UITextRange *selectedRange = [textView markedTextRange];  
        //获取高亮部分  
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];  
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制  
        if (!position) {  
            if ( [text isEqualToString:@"\n"]) {  
                return NO;  
            } else {  
                return YES;  
            }  
        }
        else{  
            return YES;  
        }  
    }
    else{  
        if ( [text isEqualToString:@"\n"]) {
            return NO;  
        } else {  
            return YES;  
        }  
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    NSString *toBeString = textView.text;
    NSString *lang = [(UITextInputMode*)[[UITextInputMode activeInputModes] firstObject] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textView markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length >= kMaxLength) {
                textView.text = [toBeString substringToIndex:kMaxLength];
            }
            _wordNumberLabel.text = [NSString stringWithFormat:@"%lu",kMaxLength-[textView.text length]];
            
        } // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length >= kMaxLength) {
            textView.text = [toBeString substringToIndex:kMaxLength];
        }
        _wordNumberLabel.text = [NSString stringWithFormat:@"%lu",kMaxLength-[textView.text length]];
    }
    
    if (textView.text.length > 0) {
        _submitBtn.backgroundColor = rgba(255,196,56,1);
        [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_submitBtn setEnabled:YES];
        _placeHolderLabel.text = @"";
    }else{
        _submitBtn.backgroundColor = rgba(204,204,204,1);
        [_submitBtn setTitleColor:rgba(238, 238, 238, 1) forState:UIControlStateNormal];
        [_submitBtn setEnabled:NO];
        _placeHolderLabel.text = @" ~ 吐槽下我们和产品吧!";
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    _placeHolderLabel.text = @"";
    NSLog(@"开始编辑");
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length == 0) {
        _placeHolderLabel.text = @" ~ 吐槽下我们和产品吧!";
    }
    NSLog(@"结束编辑");
}
#pragma mark - Action

- (void)submitFeedBack:(id)sender
{
    NSDictionary * param = @{@"userId": USER_ID,
                             @"content": _textView.text};
    [AfnManager postUserAction:URL_FEEDBACK param:param Sucess:^(NSDictionary *responseObject) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

#pragma mark - 懒加载
- (UIView *)backgroundView
{
    if (!_backgroundView) {
        UIView * backgroundView = [[UIView alloc] init];
        backgroundView.backgroundColor = [UIColor whiteColor];
        _backgroundView =backgroundView;
    }
    return _backgroundView;
}

- (UITextView *)textView
{
    if (!_textView) {
        UITextView * textView = [[UITextView alloc] init];
        textView.textColor = [UIColor blackColor];
        textView.delegate = self;
        textView.font = [UIFont systemFontOfSize:15.f];
        textView.backgroundColor = [UIColor whiteColor];
        _textView = textView;
    }
    return _textView;
}

- (UILabel *)placeHolderLabel
{
    if (!_placeHolderLabel) {
        UILabel * placeHolderLabel = [[UILabel alloc] init];
        placeHolderLabel.textColor = rgba(204, 204, 204, 1);
        placeHolderLabel.text = @" ~ 吐槽下我们和产品吧!";
        placeHolderLabel.font = [UIFont systemFontOfSize:15.f];
        _placeHolderLabel = placeHolderLabel;
    }
    return _placeHolderLabel;
}

- (UILabel *)wordNumberLabel
{
    if (!_wordNumberLabel) {
        UILabel * wordNumberLabel = [[UILabel alloc] init];
        wordNumberLabel.text = [NSString stringWithFormat:@"%d",kMaxLength];
        wordNumberLabel.textAlignment = NSTextAlignmentRight;
        wordNumberLabel.textColor = [UIColor orangeColor];
        wordNumberLabel.font = [UIFont systemFontOfSize:13.f];
        _wordNumberLabel = wordNumberLabel;
    }
    return _wordNumberLabel;
}
- (UIButton *)submitBtn
{
    if (!_submitBtn) {
        UIButton * submitBtn = [[UIButton alloc] init];
        submitBtn.backgroundColor = rgba(204, 204, 204, 1);
        [submitBtn setTitle:@"提交反馈" forState:UIControlStateNormal];
        [submitBtn setTitleColor:rgba(238, 238, 238, 1) forState:UIControlStateNormal];
        submitBtn.titleLabel.font = [UIFont systemFontOfSize:19.f];
        [submitBtn setEnabled:NO];
        [submitBtn addTarget:self action:@selector(submitFeedBack:) forControlEvents:UIControlEventTouchUpInside];
        submitBtn.layer.cornerRadius = 7.5f;
        _submitBtn = submitBtn;
    }
    return _submitBtn;
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
