//
//  EpisodeCell.m
//  XLGame
//
//  Created by Amitabha on 2017/12/13.
//  Copyright © 2017年 In.于楚天. All rights reserved.
//

#import "EpisodeCell.h"
#import <YYText.h>
@interface EpisodeCell()
@property (nonatomic,strong) UILabel * EpisodeNameLabel;
@property (nonatomic,strong) UILabel * timeLabel;
@property (nonatomic,strong) UIButton * praiseBtn;
@property (nonatomic,strong) UILabel  * praiseCountLabel;
@property (nonatomic,strong) UIImageView * EpisodeImageView;
@property (nonatomic,strong) YYLabel * moneyLabel;

@end


@implementation EpisodeCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+(EpisodeCell *)cellWithTableView:(UITableView *)tableView{
    static NSString * cellId = @"EpisodeCell";
    EpisodeCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell ==nil) {
        cell = [[EpisodeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = COLOR_SYSTEM_GARY;
        cell.backgroundColor = COLOR_SYSTEM_GARY;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return cell;
}

#define imageH  (SCREEN_WIDTH*96.0/375.0-22)

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        

        _moneyLabel = [YYLabel new];
        _moneyLabel.font = [UIFont systemFontOfSize:12];
        
        
        _praiseCountLabel = [UILabel new];
        _praiseCountLabel.font = Font_Regular(12);
        _praiseCountLabel.numberOfLines = 0;
        
        [self.contentView sd_addSubviews:@[self.EpisodeNameLabel,self.timeLabel,//self.praiseBtn,
                                           self.EpisodeImageView,_moneyLabel,_praiseCountLabel,self.playHistoryView]];
        
        _EpisodeImageView.sd_layout.leftSpaceToView(self.contentView, 15).topSpaceToView(self.contentView, 11)
        .heightIs(imageH).widthIs(imageH*140.0/75.0);
        
        self.EpisodeNameLabel.sd_layout.topEqualToView(self.EpisodeImageView).leftSpaceToView(self.EpisodeImageView, 15)
        .rightSpaceToView(self.contentView, 28).heightIs(20);
        
//        self.praiseBtn.sd_layout.rightSpaceToView(self.contentView, 28).widthIs(70)
//        .heightIs(20).bottomEqualToView(_EpisodeImageView);
        
        self.timeLabel.sd_layout.bottomEqualToView(self.EpisodeImageView).leftSpaceToView(self.EpisodeImageView, 15).heightIs(20);
        [self.timeLabel setSingleLineAutoResizeWithMaxWidth:200];

        _praiseCountLabel.sd_layout.centerYEqualToView(self.timeLabel).autoHeightRatio(0).rightSpaceToView(self.contentView, 10);
        [_praiseCountLabel setSingleLineAutoResizeWithMaxWidth:200];
        
        
        _moneyLabel.sd_layout.centerYEqualToView(_EpisodeImageView).
        leftEqualToView(self.EpisodeNameLabel).heightIs(20).rightSpaceToView(self.contentView, 20);
    }
    return self;
}
-(void)setModel:(EpisodeModel *)model{
    _model = model;
    [_EpisodeImageView sd_setImageWithURL:[NSURL URLWithString:model.cartoonSet.showPhoto] placeholderImage:Z_PlaceholderImg];
    self.EpisodeNameLabel.text = [NSString stringWithFormat:@"%@  %@", model.cartoonSet.titile,model.cartoonSet.details];
    self.timeLabel.text = model.cartoonSet.updateDate;
//    self.praiseCountLabel.text = [NSString stringWithFormat:@"%ld", model.cartoonSet.okCount];
    
    if (model.watchState == 2){
        self.EpisodeNameLabel.textColor = COLOR_NAVI;
        self.timeLabel.textColor = COLOR_NAVI;
        self.praiseCountLabel.textColor = COLOR_NAVI;
        self.playHistoryView.alpha =1;
    }else{
        self.EpisodeNameLabel.textColor = [UIColor blackColor];
        self.timeLabel.textColor = [UIColor blackColor];
        self.praiseCountLabel.textColor = [UIColor blackColor];
        self.playHistoryView.alpha =0;
    }
    
    if (model.cartoonSet.price.intValue>0 && model.watchState == 0) {
        UIImage *image = [UIImage imageNamed:@"金币"];
        NSMutableAttributedString * aStr = [NSMutableAttributedString yy_attachmentStringWithContent:image contentMode:UIViewContentModeCenter attachmentSize:CGSizeMake(13, 13) alignToFont:self.moneyLabel.font alignment:YYTextVerticalAlignmentCenter];
        NSString * str = [NSString stringWithFormat:@"%@咔咔豆",model.cartoonSet.price];
        [aStr appendAttributedString:[[NSAttributedString alloc]initWithString:str attributes:@{NSForegroundColorAttributeName:COLOR_NAVI}]];
        aStr.yy_font = [UIFont systemFontOfSize:12];
        self.moneyLabel.attributedText = aStr;

    }else{
        self.moneyLabel.attributedText = [NSAttributedString new];
    }
    NSString * str =[NSString stringWithFormat:@"点赞:%@",_model.cartoonSet.okCount];//,_model.cartoonSet.commentCount];
//    NSMutableAttributedString * text = [[NSMutableAttributedString alloc]initWithString:str];
//    text.yy_lineSpacing = 3;
//    CGFloat  width = [str boundingRectWithSize:CGSizeMake(MAXFLOAT, 45) options:0 attributes:@{NSFontAttributeName:_praiseCountLabel.font} context:nil].size.width;
    _praiseCountLabel.text = str;
    
//    NSMutableAttributedString * aStr = [[NSMutableAttributedString alloc]initWithAttributedString: self.moneyLabel.attributedText];
//    if (model.watchState == 0) {
//        [aStr addAttribute:NSForegroundColorAttributeName value:COLOR_NAVI range:NSMakeRange(0, aStr.length)];
//    }else{
//        [aStr addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0, aStr.length)];
//        [aStr addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, aStr.length)];
//        [aStr addAttribute:NSStrikethroughColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, aStr.length)];
//    }
//    self.moneyLabel.attributedText = aStr;
}
-(UIImageView *)EpisodeImageView{
    if (!_EpisodeImageView) {
        _EpisodeImageView = [UIImageView new];
        _EpisodeImageView.layer.masksToBounds = YES;
        _EpisodeImageView.layer.cornerRadius = 8;
    }
    return _EpisodeImageView;
}
-(UILabel *)EpisodeNameLabel{
    if (!_EpisodeNameLabel) {
        _EpisodeNameLabel = [UILabel new];
        _EpisodeNameLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    }
    return _EpisodeNameLabel;
}
-(UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
        _timeLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    }
    return _timeLabel;
}
-(UIButton *)praiseBtn{
    if (!_praiseBtn) {
        _praiseBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        
        UIImageView * imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"praise"]];
        [_praiseBtn addSubview:imageView];
        imageView.sd_layout.rightSpaceToView(_praiseBtn, 0).centerYEqualToView(_praiseBtn).widthIs(13).heightIs(13);
        
        UILabel * label = [UILabel new];
        
        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:11.2];
        label.textColor = [UIColor lightGrayColor];
        [_praiseBtn addSubview:label];
        _praiseCountLabel = label;
        [_praiseBtn setEnabled:NO];
        
        label.sd_layout.autoHeightRatio(0).centerYEqualToView(imageView).rightSpaceToView(imageView, 5).leftSpaceToView(_praiseCountLabel, 5);
        [label setSingleLineAutoResizeWithMaxWidth:100];
        
        [_praiseBtn addTarget:self action:@selector(praiseBtnClick:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _praiseBtn;
}
-(UIView *)playHistoryView{
    if (_playHistoryView == nil) {
        _playHistoryView = [UIView new];
        _playHistoryView.frame = CGRectMake(SCREEN_WIDTH-32, 13, 32+25/2.0, 25);
        _playHistoryView.backgroundColor = RGB(246,204,23);
        _playHistoryView.layer.cornerRadius = 25/2.0;
        
        UIImageView * imageView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"time"]];
        [_playHistoryView addSubview:imageView];
        imageView.sd_layout.widthIs(17).heightIs(17)
        .leftSpaceToView(_playHistoryView, 4).centerYEqualToView(_playHistoryView);
    }
    return _playHistoryView;
}
+(CGFloat)cellHeight{
    return imageH + 22;
}
-(void)praiseBtnClick:(UIButton * )btn{
    NSLog(@"clicked");
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
