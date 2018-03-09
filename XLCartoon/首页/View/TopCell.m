//
//  TopCell.m
//  XLGame
//
//  Created by Amitabha on 2017/12/9.
//  Copyright © 2017年 In.于楚天. All rights reserved.
//

#import "TopCell.h"

@implementation TopCell

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.layer.cornerRadius = 7;
    self.photoView.layer.masksToBounds = YES;
    self.photoView.layer.cornerRadius = 7;
    self.TitleLabel.font = [UIFont systemFontOfSize:16.2];
    self.numberLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12.2];
    self.playCountLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14.2];

    self.TopNumLabel.font = [UIFont fontWithName:@"JJianzi" size:35];
    _lineView = [UIView new];
    [self addSubview:_lineView];
    _lineView.sd_layout.topEqualToView(self).bottomEqualToView(self)
    .widthIs(7).rightEqualToView(self.photoView);
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
-(void)setModel:(CartoonDetailModel *)model{
    _model = model;
    [self.photoView sd_setImageWithURL:[NSURL URLWithString:model.cartoon.smallPhoto] placeholderImage:Z_PlaceholderImg];
    self.TitleLabel.text = model.cartoon.cartoonName;
    self.playCountLabel.text = model.cartoon.playCount;
    self.numberLabel.text = model.cartoon.updateTile;
}
-(void)setFrame:(CGRect)frame{
    frame.origin.x += 15;
    frame.origin.y += 10;
    frame.size.height -= 10;
    frame.size.width -= 30;
    [super setFrame:frame];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
