//
//  EpisodeHaderView.m
//  XLGame
//
//  Created by Amitabha on 2017/12/13.
//  Copyright © 2017年 In.于楚天. All rights reserved.
//

#import "varicatureHeaderView.h"


@implementation varicatureHeaderView

-(instancetype)init{
    if (self = [super init]) {
        
        
        UILabel * label = [[UILabel alloc]init];
        label.text = @"作品简介";
        label.textColor = RGB(44, 44, 44);
        label.font = Font_Medium(15);
        [self addSubview:label];
        label.sd_layout.topSpaceToView(self, 10).leftSpaceToView(self, 15).rightSpaceToView(self, 15).autoHeightRatio(0);
        
        _summaryLabel = [UILabel new];
        _summaryLabel.font = Font_Regular(13.5);
        [self addSubview:_summaryLabel];
        _summaryLabel.textColor = RGB(99, 99, 99);
        _summaryLabel.numberOfLines = 0;
        _summaryLabel.sd_layout.leftEqualToView(label).rightEqualToView(label)
        .autoHeightRatio(0).topSpaceToView(label, 10);
        
        label = [UILabel new];
        label.text = @"作者：";
        label.textColor = RGB(88, 88, 88);
        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        [self addSubview:label];
        
        
        label.sd_layout.leftEqualToView(_summaryLabel)
        .topSpaceToView(_summaryLabel, 12).autoHeightRatio(0);
        [label setSingleLineAutoResizeWithMaxWidth:100];
        
        [self addSubview:self.authorIcon];
        _authorIcon.sd_layout.centerYEqualToView(label).leftSpaceToView(label, 0).widthIs(20).heightIs(20);
        
        _authorLabel = [UILabel new];
        _authorLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        [self addSubview:_authorLabel];
        _authorLabel.textColor = RGB(88, 88, 88);
        _authorLabel.sd_layout.leftSpaceToView(_authorIcon, 5).autoHeightRatio(0).centerYEqualToView(_authorIcon);
        [_authorLabel setSingleLineAutoResizeWithMaxWidth:200];
        
        UIView * line = [UIView new];
        line.backgroundColor =  COLOR_LIGHT_GARY;
        [self addSubview:line];
        
        line.sd_layout.topSpaceToView(label, 15).leftEqualToView(self).rightEqualToView(self).heightIs(4);
        
        
        label = [[UILabel alloc] init];
        label.text = @"猜你喜欢";
        label.font = [UIFont fontWithName:@"PingFangSC-Medium" size:13];
        [self addSubview:label];
        label.sd_layout.topSpaceToView(line, 0).leftSpaceToView(self, 15).widthIs(SCREEN_WIDTH).heightIs(30);
        
        UIView * blueBlock = [[UIView alloc] init];
        blueBlock.backgroundColor = COLOR_NAVI;
        [self addSubview:blueBlock];
        blueBlock.sd_layout.centerYEqualToView(label).heightIs(12).
        widthIs(3).leftEqualToView(self);
        
        _changeLikeBtn = [FSCustomButton buttonWithType:UIButtonTypeCustom];
        [_changeLikeBtn setTitle:@" 换一批" forState:UIControlStateNormal];
        [_changeLikeBtn setImage:[UIImage imageNamed:@"AnotherBatch"] forState:UIControlStateNormal];
        [_changeLikeBtn setTitleColor:COLOR_NAVI forState:UIControlStateNormal];
        _changeLikeBtn.titleLabel.textAlignment = NSTextAlignmentRight;
        _changeLikeBtn.titleLabel.font =  [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        [self addSubview:_changeLikeBtn];
        
        _changeLikeBtn.sd_layout.widthIs(80).heightIs(20).centerYEqualToView(blueBlock).rightSpaceToView(self, 5);
        _changeLikeBtn.buttonImagePosition = FSCustomButtonImagePositionLeft;
        
        
        
        
        CGFloat btnW = (SCREEN_WIDTH - 15*4)/3.0;
        CGFloat btnH = btnW * 306.0/200.0;
     
        [self likeScrollViewView];
        _likeScrollViewView.sd_layout.leftEqualToView(self)
        .rightEqualToView(self).topSpaceToView(label, 0).heightIs(btnH+30);
        
        line = [UIView new];
        line.backgroundColor =  COLOR_LIGHT_GARY;
        [self addSubview:line];
        line.sd_layout.topSpaceToView(_likeScrollViewView, 3).leftEqualToView(self).rightEqualToView(self).heightIs(4);
        
        
        label = [[UILabel alloc] init];
        label.text = @"评论";
        label.font = [UIFont fontWithName:@"PingFangSC-Medium" size:13];
        [self addSubview:label];
        label.sd_layout.topSpaceToView(line, 0).leftSpaceToView(self, 15).widthIs(SCREEN_WIDTH).heightIs(30);
        
        blueBlock = [[UIView alloc] init];
        blueBlock.backgroundColor = COLOR_NAVI;
        [self addSubview:blueBlock];
        blueBlock.sd_layout.centerYEqualToView(label).heightIs(12).widthIs(3)
        .leftEqualToView(self);
        
        FSCustomButton * btn = [FSCustomButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"bi"] forState:UIControlStateNormal];
        [btn setTitle: @" 写评论" forState:UIControlStateNormal];
        [btn setTitleColor:COLOR_NAVI forState:UIControlStateNormal];
        btn.titleLabel.textAlignment = NSTextAlignmentRight;
        btn.titleLabel.font =  [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        [self addSubview:btn];
        _writeCommentBtn = btn;
        btn.sd_layout.rightSpaceToView(self, 5).centerYEqualToView(blueBlock).heightIs(20).widthIs(80);
        btn.buttonImagePosition = FSCustomButtonImagePositionLeft;
    
        line = [UIView new];
        line.backgroundColor =  COLOR_LINE;
        [self addSubview:line];
        
        line.sd_layout.topSpaceToView(label, 0).leftEqualToView(self).rightEqualToView(self).heightIs(0.6);
        
        [self setupAutoHeightWithBottomView:line bottomMargin:0];
        
        
    }
    return self;
}
-(void)setModel:(CartoonDetailModel *)model{
    self.summaryLabel.text = model.cartoon.introduc;
    [_authorIcon sd_setImageWithURL:[NSURL URLWithString:model.cartoon.cartoonAuthorPic] placeholderImage:[UIImage imageNamed:@"authorIcon"]];
    _authorLabel.text = model.cartoon.cartoonAuthor;
    [self layoutSubviews];
}

-(UIScrollView *)likeScrollViewView{
    if (!_likeScrollViewView) {
        _likeScrollViewView =[UIScrollView new];
        _likeScrollViewView.showsHorizontalScrollIndicator = NO;
        [self addSubview:_likeScrollViewView];
    }
    return _likeScrollViewView;
}
-(UIImageView *)authorIcon{
    if (!_authorIcon) {
        _authorIcon = [[UIImageView alloc]init];
        _authorIcon.layer.masksToBounds = YES;
        _authorIcon.layer.cornerRadius = 10;
    }
    return _authorIcon;
}

@end
