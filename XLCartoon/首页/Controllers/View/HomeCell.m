//
//  HomeCell.m
//  XLGame
//
//  Created by Amitabha on 2017/12/8.
//  Copyright © 2017年 In.于楚天. All rights reserved.
//

#import "HomeCell.h"

@interface HomeCell()

@property (nonatomic,strong) UILabel * nameLabel;
@property (nonatomic,strong) UIImageView * ImageView;
@property (nonatomic,strong) UILabel * authorLabel;
@property (nonatomic,strong) UILabel * commentLabel;
@property (nonatomic,strong) UILabel * playLabel;
@property (nonatomic,strong) UIView * tipView;
@property (nonatomic,strong) UIImageView * updateTypeIcon;
@property (nonatomic,strong) UILabel * updateTypeLabel;
@property (nonatomic,strong) UILabel * followLabel;
@end

@implementation HomeCell

+(HomeCell *)cellWithTableView:(UITableView *)tableView{
    static NSString * cellId = @"GameGiftCell";
    HomeCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell ==nil) {
        cell = [[HomeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupView];
    }
    return self;
}


- (void)setupView{
    UIView * backView =[[UIView alloc]init];
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.cornerRadius = 8;
    [self.contentView addSubview:backView];
    
    backView.sd_layout.leftSpaceToView(self.contentView, 15).rightSpaceToView(self.contentView, 15).topEqualToView(self.contentView).bottomSpaceToView(self.contentView, 10);
    
    UIImageView * nameIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed: @"camera"]];
    UIImageView * authorIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed: @"author"]];
    
    UIImageView * commentIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed: @"comment"]];
    UIImageView * playIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed: @"play"]];
    _updateTypeIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed: @"日更"]];
    [backView sd_addSubviews:@[self.nameLabel,self.ImageView,nameIcon
                               ,self.authorLabel,authorIcon,
                               self.commentLabel,self.playLabel,self.followLabel,
                               commentIcon,playIcon ,self.tipView,_updateTypeIcon]];
    
    _followLabel.sd_layout.rightSpaceToView(backView,0).topSpaceToView(backView, 35)
    .widthIs(80).heightIs(30);
    
    self.authorLabel.sd_layout.rightSpaceToView(backView, 10).topEqualToView(backView).heightIs(35);
    [self.authorLabel setSingleLineAutoResizeWithMaxWidth:100];
    
    authorIcon.sd_layout.rightSpaceToView(_authorLabel, 5).centerYIs(37.5/2).heightIs(17).widthIs(17);
    
    nameIcon.sd_layout.leftSpaceToView(backView, 5).widthIs(20).heightIs(20).centerYIs(17.5);
    
    self.nameLabel.sd_layout.leftSpaceToView(backView, 30)
    .heightIs(35).topEqualToView(backView).rightSpaceToView(authorIcon, 10);
    
    self.ImageView.sd_layout.leftEqualToView(backView).rightEqualToView(backView)
    .topSpaceToView(_nameLabel, 0).bottomSpaceToView(backView, 35);
    
    _updateTypeIcon.sd_layout.topSpaceToView(self.nameLabel, 5).heightIs(30).autoWidthRatio(100.0/65).leftSpaceToView(backView, -5.8);
    UILabel *label = [[UILabel alloc] init];
    _updateTypeLabel = label;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
    [_updateTypeIcon addSubview:label];
    label.sd_layout.spaceToSuperView(UIEdgeInsetsMake(3, 10, 0, 0));
    
    _playLabel.sd_layout.rightSpaceToView(backView, 10).heightIs(35).bottomEqualToView(backView);
    [_playLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    playIcon.sd_layout.rightSpaceToView(_playLabel, 2).centerYEqualToView(_playLabel)
    .widthIs(15).heightIs(15);
    
    _commentLabel.sd_layout.rightSpaceToView(playIcon, 5).heightIs(35).bottomEqualToView(backView);
    [_commentLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    commentIcon.sd_layout.rightSpaceToView(_commentLabel, 3).centerYEqualToView(_playLabel)
    .widthIs(15).heightIs(15);
    
    _tipView.sd_layout.leftSpaceToView(backView, 5).rightSpaceToView(commentIcon, 10)
    .centerYEqualToView(commentIcon);
    
    
    
    //测试数据
    
    
}
-(void)setModel:(CartoonDetailModel *)model{
    _model = model;
    [self.ImageView sd_setImageWithURL:[NSURL URLWithString:_model.cartoon.mainPhoto] placeholderImage:Z_PlaceholderImg];
    self.authorLabel.text = _model.cartoon.cartoonAuthor;
    _playLabel.text = _model.cartoon.playCount;
    _commentLabel.text = _model.cartoon.commentCount;
    
    
    _updateTypeLabel.text = _model.cartoon.updateType;
//    _updateTypeIcon.alpha = _model.cartoon.updateType.intValue;
    
    for (UIView * item in _tipView.subviews) {
        [item removeFromSuperview];
    }
    for (cartoonTypeAll * typeModel  in _model.cartoonAllType) {
        UILabel * label = [self getTypeLabel:typeModel.carrtoonType.cartoonType];
        [_tipView addSubview:label];
        label.sd_layout.heightIs(20);
        [label setSingleLineAutoResizeWithMaxWidth:100];
    }
    [_tipView setupAutoWidthFlowItems:_tipView.subviews withPerRowItemsCount:_tipView.subviews.count verticalMargin:0 horizontalMargin:5 verticalEdgeInset:0 horizontalEdgeInset:0];
    [_tipView layoutSubviews];
 
    self.nameLabel.text = model.cartoon.serialState ? model.cartoon.cartoonName : [NSString stringWithFormat:@"%@  更新至%@",model.cartoon.cartoonName, model.cartoon.updateTile];
    
    self.followLabel.text = [NSString stringWithFormat:@"关注：%@\t",model.cartoon.followCount];
}
-(UILabel *)followLabel{
    if (!_followLabel) {
        _followLabel = [UILabel new];
        _followLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
        _followLabel.textColor = [UIColor whiteColor];
        _followLabel.textAlignment = NSTextAlignmentRight;
        CAGradientLayer *layer = [CAGradientLayer layer];
        //设置开始和结束位置(设置渐变的方向)
        layer.startPoint = CGPointMake(1, 0);
        layer.endPoint = CGPointMake(0, 0);
        layer.colors = [NSArray arrayWithObjects:(id)rgba(0, 0, 0, 1).CGColor, rgba(0, 0, 0, 0).CGColor, nil];
        layer.frame = CGRectMake(0, 0, 80, 30);// blackView.bounds; //
        [_followLabel.layer addSublayer:layer];
    }
    return _followLabel;
}
-(UIView *)tipView{
    if (!_tipView) {
        _tipView = [UIView new];
    }
    return _tipView;
}

-(UILabel *)getTypeLabel:(NSString * )text{
    UILabel * label = [UILabel new];
    label.layer.cornerRadius = 10;
    label.layer.borderWidth = 0.5;
    label.textColor = COLOR_NAVI;
    label.layer.borderColor = COLOR_NAVI.CGColor;
    label.font = [UIFont systemFontOfSize:10];
    label.text = [NSString stringWithFormat:@"  %@  ",text];
    return label;
}
-(UILabel *)nameLabel{
    if (_nameLabel == nil) {
        _nameLabel =  [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:15];
    }
    return _nameLabel;
}

-(UIImageView *)ImageView{
    if (_ImageView == nil) {
        _ImageView = [[UIImageView alloc]init];
        _ImageView.backgroundColor = [UIColor lightGrayColor];
    }
    return _ImageView;
}

-(UILabel *)authorLabel{
    if (_authorLabel == nil) {
        _authorLabel = [[UILabel alloc]init];
        _authorLabel.textColor = [UIColor lightGrayColor];
        _authorLabel.font =  [UIFont systemFontOfSize:13];
    }
    return _authorLabel;
}
-(UILabel *)playLabel{
    if (_playLabel == nil) {
        _playLabel = [[UILabel alloc]init];
        _playLabel.textColor = [UIColor lightGrayColor];
        _playLabel.font =  [UIFont systemFontOfSize:13];
    }
    return _playLabel;
}
-(UILabel *)commentLabel{
    if (_commentLabel == nil) {
        _commentLabel = [[UILabel alloc]init];
        _commentLabel.textColor = [UIColor lightGrayColor];
        _commentLabel.font =  [UIFont systemFontOfSize:13];
    }
    return _commentLabel;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
