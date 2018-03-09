//
//  everyDayShowWindow.m
//  XLCartoon
//
//  Created by Amitabha on 2018/1/22.
//  Copyright © 2018年 XLCR. All rights reserved.
//

#import "everyDayShowWindow.h"
#import "everyDayShowView.h"
#import "TaskTableViewController.h"
#import "CaricatureDetailViewController.h"
@interface everyDayShowWindow()
@property (nonatomic,strong) everyDayShowView * view;
@end

@implementation everyDayShowWindow

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [AfnManager postWithUrl:URL_EVERYDAY_UPDATA param:nil Sucess:^(NSDictionary *responseObject) {
            NSMutableArray * arr = [NSMutableArray array];
            for (NSDictionary *dict in OBJ(responseObject)) {
                [arr addObject:[CartoonDetailModel mj_objectWithKeyValues:dict]];
            }
            [self addSubview:self.view];
            self.view.modelArr = arr;
            
            [self.view layoutSubviews];
            
            UIButton * btn = [ UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = self.bounds;
            btn.backgroundColor =  rgba(0, 0, 0, 0.7);
            [self insertSubview:btn atIndex:0];
            [btn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
            
            UIButton * closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [closeBtn setTitle:@"×" forState:UIControlStateNormal];
            closeBtn.titleLabel.font = [UIFont systemFontOfSize:30];
            [closeBtn setTitleColor:COLOR_NAVI forState:UIControlStateNormal];
            [closeBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
            [self.view.backVIew addSubview:closeBtn];
            closeBtn.sd_layout.widthIs(30).heightIs(30).rightSpaceToView(self.view.backVIew, 5).topSpaceToView(self.view.backVIew, 5);
        }];
    }
    return self;
}
-(UIView *)view{
    if (_view ==nil) {
        _view = [[[NSBundle mainBundle] loadNibNamed:@"everyDayShowView" owner:nil options:nil] firstObject];
        _view.center = CGPointMake(self.center.x, self.center.y-50);

        [_view.btn addTarget:self action:@selector(goToTaskVCBtnClick) forControlEvents:UIControlEventTouchUpInside];
        __weak typeof(self) weakSelf = self;
        _view.clickBlock = ^(CartoonDetailModel *model) {
            [weakSelf close];
            UINavigationController * navi = [APP_DELEGATE.tabBarVC.viewControllers objectAtIndex:APP_DELEGATE.tabBarVC.selectedIndex ];
            CaricatureDetailViewController * vc = [[CaricatureDetailViewController alloc]init];
            vc.cartoonId = model.cartoon.id;
            [navi pushViewController:vc animated:YES];
        };
    }
    return _view;
}
-(void)goToTaskVCBtnClick{
    [self close];
    UINavigationController * navi = [APP_DELEGATE.tabBarVC.viewControllers objectAtIndex:APP_DELEGATE.tabBarVC.selectedIndex ];
    [navi pushViewController:[TaskTableViewController new ] animated:YES];
}

+(everyDayShowWindow *)share{
    static everyDayShowWindow *window =nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (window == nil) {
            window = [[self alloc] initWithFrame:[UIScreen mainScreen].bounds];
        }
    });
    [window show];
    return window;
}
- (void)show
{
    [self makeKeyWindow];
    self.hidden = NO;
}
-(void)close{
    [self resignKeyWindow];
    self.hidden = YES;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
