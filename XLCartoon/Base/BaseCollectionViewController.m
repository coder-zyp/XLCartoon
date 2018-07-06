//
//  BaseCollectionViewController.m
//  XLCartoon
//
//  Created by Amitabha on 2018/2/28.
//  Copyright © 2018年 XLCR. All rights reserved.
//

#import "BaseCollectionViewController.h"
#import "UIColor+Hexadecimal.h"

@interface BaseCollectionViewController ()

@end

@implementation BaseCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad]; 
    
    self.collectionView.emptyDataSetSource = self;
    self.collectionView.emptyDataSetDelegate = self;
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setLoading:(BOOL)loading
{
    if (self.isLoading == loading) {
        return;
    }
    _loading = loading;
    // 每次 loading 状态被修改，就刷新空白页面。
    [self.collectionView reloadEmptyDataSet];
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    if (self.isLoading) {
        // 圆形加载图片
        return [UIImage imageNamed:@"loading_imgBlue_78x78"];
    }else {
        // 默认静态图片
        return [UIImage imageNamed:@"empty_placeholder"];
    }
}

#pragma mark 图片旋转动画
- (CAAnimation *)imageAnimationForEmptyDataSet:(UIScrollView *)scrollView
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    animation.toValue = [NSValue valueWithCATransform3D: CATransform3DMakeRotation(M_PI_2, 0.0, 0.0, 1.0) ];
    animation.duration = 0.25;
    animation.cumulative = YES;
    animation.repeatCount = MAXFLOAT;
    
    return animation;
}

#pragma mark - DZNEmptyDataSetDelegate
#pragma mark 是否开启动画
- (BOOL)emptyDataSetShouldAnimateImageView:(UIScrollView *)scrollView {
    return self.isLoading;
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    
    NSString *text  = @"暂无数据，请点击重试哦~";
    if (APP_DELEGATE.notNet) text = @"没有网络，请点击重试哦~";
    if (self.isLoading) {
        text = @"";
    }
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];
    // 设置所有字体大小为 #15
    [attStr addAttribute:NSFontAttributeName
                   value:[UIFont systemFontOfSize:15.0]
                   range:NSMakeRange(0, text.length)];
    // 设置所有字体颜色为浅灰色
    [attStr addAttribute:NSForegroundColorAttributeName
                   value:[UIColor lightGrayColor]
                   range:NSMakeRange(0, text.length)];
    // 设置指定4个字体为蓝色
    if (text.length >10) {
        [attStr addAttribute:NSForegroundColorAttributeName
                       value:[UIColor colorWithHex:@"#007EE5"]
                       range:NSMakeRange(6, 4)];
    }
    
    
    return attStr;
}
- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button {
    // 空白页面被点击时开启动画，reloadEmptyDataSet
    [self getData];
}
-(void)getData{
    self.loading = YES;
    //子类访问网络
}

#pragma mark <UICollectionViewDelegate>


@end
