//
//  CommentWindow.m
//  XLCartoon
//
//  Created by Amitabha on 2017/12/22.
//  Copyright © 2017年 XLCR. All rights reserved.
//

#import "CommentWindow.h"
#import <IQKeyboardManager.h>


@interface CommentWindow()<UITextViewDelegate,UITextFieldDelegate>
@property (nonatomic,strong) UIView * backView;
@property (nonatomic,strong) UILabel * titleLabel;
@end
#define VIEW_HEIGHT (SCREEN_WIDTH*0.4)

@implementation CommentWindow

+(CommentWindow *)share{
    static CommentWindow *window = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (window == nil) {
            window = [[CommentWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        }
    });
    return window;
}
+(CommentWindow *)shareWithFinshBlock:(CommentWindowBlock)block{

    CommentWindow * window = [CommentWindow share];
    window.block = block;
    [window show];
    return window;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = rgba(0, 0, 0, 0.7);
        UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(close)];
        [self addGestureRecognizer:gesture];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(done:) name:@"IQDoneAction" object:nil];
        
        _backView = [UIView new];
        _backView.backgroundColor = COLOR_SYSTEM_GARY;
        _backView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, VIEW_HEIGHT);
        [self addSubview:_backView];
        
        _titleLabel =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        _titleLabel.text = @"发表评论";
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = COLOR_NAVI;
        [_backView addSubview:_titleLabel];
        
        _textView = [[SLKTextView alloc]initWithFrame:CGRectMake(10, 50, SCREEN_WIDTH-20, VIEW_HEIGHT-20-50)];
        _textView.backgroundColor = COLOR_LIGHT_GARY;
        _textView.layer.cornerRadius =5;
        _textView.font = [UIFont fontWithName:@"PingFangSC-Regular" size:18];
        [_backView addSubview:_textView];
        _textView.placeholder =@"优质评论会被优先展示哦~";
//        _textView.placeholderText = @"优质评论会被优先展示哦~";
//        _textView.returnKeyType = UIReturnKeySend;
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = COLOR_NAVI;
    }
    return self;
}
- (void)done:(NSNotification *)notification{
    //done按钮的操作
    if (self.textView.text.length>0) {
        self.block(self.textView.text,self);
        
    }
}
-(void)setTitle:(NSString *)title{
    _title = title;
    self.titleLabel.text = title;
}
-(void)resetData{
    self.textView.placeholder =@"优质评论会被优先展示哦~";
    _titleLabel.text = @"发表评论";
}

//这个函数的最后一个参数text代表你每次输入的的那个字，所以：
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        return NO; //这里返回NO，就代表return键值失效
    }
    return YES;
}
- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    
    // 动画的持续时间
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 键盘的frame
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
//    NSLog(@"%lf",keyboardF.origin.y);
    // 执行动画
    [UIView animateWithDuration:duration animations:^{
        // 工具条的Y值 == 键盘的Y值 - 工具条的高度
        if (keyboardF.origin.y > self.height) { // 键盘的Y值已经远远超过了控制器view的高度
        } else {
            
        }//keyboardF.size.height-self.textView.inputAccessoryView.size.height-
        self.backView.frame = CGRectMake(0, SCREEN_HEIGHT-VIEW_HEIGHT-keyboardF.size.height, SCREEN_WIDTH, VIEW_HEIGHT);
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    [self resetData];
    [self close];
}

-(void)close{
    self.hidden = YES;
    _backView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, VIEW_HEIGHT);
    [IQKeyboardManager sharedManager].toolbarDoneBarButtonItemText = @"完成";
}
- (void)show
{
    [self makeKeyWindow];
    self.hidden = NO;
    [IQKeyboardManager sharedManager].toolbarDoneBarButtonItemText = @"发送";
    [self.textView becomeFirstResponder];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
