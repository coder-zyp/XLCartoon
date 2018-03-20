//
//  SliderView.m
//  XLCartoon
//
//  Created by Amitabha on 2018/3/7.
//  Copyright © 2018年 XLCR. All rights reserved.
//

#import "SliderView.h"

@implementation SliderView

- (void)awakeFromNib {
    [super awakeFromNib];
//    UINavigationControllerHideShowBarDuration
    self.frame = [UIScreen mainScreen].bounds;
    self.isShowReadProgress = NO;
    UIImage * thumbImage =[UIImage imageNamed:@"滑块"];
    [self.slider setThumbImage:thumbImage forState:UIControlStateNormal];
    [self.slider setThumbImage:thumbImage forState:UIControlStateSelected];
    [self.slider setThumbImage:thumbImage forState:UIControlStateHighlighted];
    self.slider.superview.backgroundColor =rgba(30, 30, 30, 0.95);
    self.slider.popUpViewColor =rgba(30, 30, 30, 0.95);
    self.slider.minimumTrackTintColor = [UIColor whiteColor];
    self.slider.font = [UIFont systemFontOfSize:16];
    
    self.slider.popUpViewArrowLength = 20;
    self.slider.popUpViewCornerRadius = 1;
    self.slider.popUpViewWidthPaddingFactor = 1.25;
    

//
    
//    self.slider.delegate = self;
//    self.slider.dataSource = self;
    // Initialization code
}
- (IBAction)dismissBtnClick:(id)sender {
    
    self.viewBottomConstraint.constant = -50;
    [UIView animateWithDuration:UINavigationControllerHideShowBarDuration animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        self.dismisssBlock();
    }];
    
}
- (IBAction)upDownBtnClick:(UIButton *)sender {
    if (self.slider.tag == 3) {
        self.upDownClick(sender.tag == 2);
    }
    
}



@end
