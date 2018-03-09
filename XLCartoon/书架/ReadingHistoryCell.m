//
//  ReadingHistoryCell.m
//  XLGame
//
//  Created by Amitabha on 2017/12/11.
//  Copyright © 2017年 In.于楚天. All rights reserved.
//

#import "ReadingHistoryCell.h"
#import <UIButton+WebCache.h>
@interface ReadingHistoryCell()
@property (nonatomic,strong) UILabel * nameLabel;
@property (nonatomic,strong) UIButton * authorIcon;
@property (nonatomic,strong) UILabel * authorNameLabel;
@property (nonatomic,strong) UILabel * playCount;
@property (nonatomic,strong) UILabel * followCount;
@end

@implementation ReadingHistoryCell


+(ReadingHistoryCell *)cellWithTableView:(UITableView *)tableView{
    static NSString * cellId = @"ReadingHistoryCell";
    ReadingHistoryCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    cell = [[ReadingHistoryCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor = COLOR_SYSTEM_GARY;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
            [self setupView];
    }
    return self;
}
#define imageW (SCREEN_WIDTH-30)/2.0
#define imageH imageW*170.0/320.0
- (void)setupView{
    
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.cornerRadius = 8;
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"剧主:";
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    label.textColor = [UIColor colorWithRed:163/255 green:163/255 blue:163/255 alpha:1];
    
    UIView * line = [UIView new];
    line.backgroundColor = [UIColor lightGrayColor];
    
    [self.contentView sd_addSubviews:@[self.nameLabel,self.authorIcon,
                                       self.playCount,self.followCount,
                                       label,line,self.topBlackLabel,self.authorNameLabel]];
    
    
    self.imageView.sd_layout.leftSpaceToView(self.contentView, 15).topSpaceToView(self.contentView, 15)
    .widthIs(imageW).heightIs(imageH);
    
    _topBlackLabel.sd_layout.topSpaceToView(self.contentView, 20).leftSpaceToView(self.contentView, 15).
    widthIs(40).heightIs(20);
    
    _nameLabel.sd_layout.topSpaceToView(self.contentView, 18).leftSpaceToView(self.imageView, 10).rightSpaceToView(self.contentView, 15).autoHeightRatio(0);
    
    label.sd_layout.centerYEqualToView(self.contentView).leftEqualToView(self.nameLabel)
    .autoHeightRatio(0);
    [label setSingleLineAutoResizeWithMaxWidth:100];
    
    _authorIcon.sd_layout.leftSpaceToView(label, 2).centerYEqualToView(label).widthIs(20).heightIs(20);
    
    _authorNameLabel.sd_layout.leftSpaceToView(_authorIcon, 2).centerYEqualToView(label).autoHeightRatio(0);
    [_authorNameLabel setSingleLineAutoResizeWithMaxWidth:300];
    
    _playCount.sd_layout.bottomSpaceToView(self.contentView, 18).leftSpaceToView(self.imageView, 10).autoHeightRatio(0);
    [_playCount setSingleLineAutoResizeWithMaxWidth:200];
    
    _followCount.sd_layout.bottomSpaceToView(self.contentView, 18).rightSpaceToView(self.contentView, 15).autoHeightRatio(0);
    [_followCount setSingleLineAutoResizeWithMaxWidth:200];
    
    line.sd_layout.leftEqualToView(self.contentView).rightEqualToView(self.contentView)
    .bottomEqualToView(self.contentView).heightIs(0.5);
    
    
}
-(void)setModel:(CartoonDetailModel *)model{
    _model = model;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.cartoon.mainPhoto] placeholderImage:Z_PlaceholderImg];
    self.nameLabel.text = model.cartoon.cartoonName;
    [_authorIcon sd_setImageWithURL:[NSURL URLWithString:model.cartoon.cartoonAuthorPic] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"author"]];
    _authorNameLabel.text = model.cartoon.cartoonAuthor;
    _playCount.text = [NSString stringWithFormat:@"播放量：%@",_model.cartoon.playCount] ;
    _followCount.text = [NSString stringWithFormat:@"关注：%@",_model.cartoon.followCount];

}
-(UILabel *)authorNameLabel{
    if (!_authorNameLabel) {
        _authorNameLabel = [UILabel new];
        _authorNameLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    }
    return _authorNameLabel;
}
+(CGFloat)cellHeight{
    return imageH + 30;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(UILabel *)followCount{
    if (!_followCount) {
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        label.textColor = [UIColor colorWithRed:163/255 green:163/255 blue:163/255 alpha:1];
        label.textAlignment = NSTextAlignmentRight;
        _followCount = label;
    }
    return _followCount;

}
-(UILabel *)topBlackLabel{
    if (!_topBlackLabel) {
        _topBlackLabel = [UILabel new];
        _topBlackLabel.backgroundColor = rgba(0, 0, 0, 0.7);
        _topBlackLabel.layer.cornerRadius = 1.5;
        _topBlackLabel.textAlignment = NSTextAlignmentCenter;
        _topBlackLabel.textColor = [UIColor whiteColor];
        _topBlackLabel.font =Font_Medium(13);
        _topBlackLabel.hidden = YES;
    }
    return _topBlackLabel;
}
-(UILabel *)nameLabel{
    if (_nameLabel == nil) {
        UILabel *label = [[UILabel alloc] init];
        label.font = Font_Medium(15);
        _nameLabel = label;
    }
    return _nameLabel;
}
-(UIButton *)authorIcon{
    if (!_authorIcon) {
        _authorIcon = [UIButton buttonWithType:UIButtonTypeCustom];
        _authorIcon.layer.masksToBounds = YES;
        _authorIcon.layer.cornerRadius = 10;
    }
    return _authorIcon;
}
-(UILabel *)playCount{
    if (!_playCount) {
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        label.textColor = [UIColor colorWithRed:163/255 green:163/255 blue:163/255 alpha:1];
        _playCount = label;
    }
    return _playCount;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
