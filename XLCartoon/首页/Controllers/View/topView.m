//
//  topView.m
//  XLGame
//
//  Created by Amitabha on 2017/12/9.
//  Copyright © 2017年 In.于楚天. All rights reserved.
//

#import "topView.h"

@implementation topView


-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.layer.cornerRadius = 7;
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.cornerRadius = 7;
    self.TitleLabel.font = [UIFont fontWithName:@"PingFang-SC-Bold" size:16.2];
    self.numberLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12.2];
    self.iconLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:10.2];
    self.playCountLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14.2];
    self.iconLabel.layer.cornerRadius = 10;
    self.TopNumLabel.font = [UIFont fontWithName:@"JJianzi" size:35];
    _lineView = [UIView new];
    [self addSubview:_lineView];
    _lineView.sd_layout.topEqualToView(self).bottomEqualToView(self)
    .widthIs(7).rightEqualToView(self.imageView);
}
-(void)setModel:(CartoonDetailModel *)model{
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.cartoon.smallPhoto] placeholderImage:Z_PlaceholderImg];
    self.TitleLabel.text = model.cartoon.cartoonName;
    self.playCountLabel.text = model.cartoon.followCount;
    self.numberLabel.text = model.cartoon.updateTile;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
