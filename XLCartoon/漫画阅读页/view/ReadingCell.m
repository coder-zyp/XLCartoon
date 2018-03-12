//
//  ReadingCell.m
//  XLCartoon
//
//  Created by Amitabha on 2017/12/27.
//  Copyright © 2017年 XLCR. All rights reserved.
//

#import "ReadingCell.h"
@interface ReadingCell()
@property (nonatomic,strong) UIImageView * picImageView;

@end
@implementation ReadingCell{
//    UIImageView * kakaView;
}

+(ReadingCell *)cellWithTableView:(UITableView *)tableView{
    static NSString * cellId = @"ReadingCell";
    ReadingCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell ==nil) {
        cell = [[ReadingCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return cell;
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = COLOR_SYSTEM_GARY;
        for (UIView * item in self.contentView.subviews) {
            [item removeFromSuperview];
        }
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _testLabel = [UILabel new];
        [self.contentView addSubview:_testLabel];
        _testLabel.textAlignment = NSTextAlignmentCenter;
        _testLabel.font  = [UIFont fontWithName:@"JJianzi" size:70];;
        _testLabel.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
        
        _picImageView = [[UIImageView alloc]init];//WithImage:Z_PlaceholderImg];
        [self.contentView addSubview:_picImageView];
        _picImageView.sd_layout.topEqualToView(self.contentView)
        .widthRatioToView(self.contentView, 1)
        .leftEqualToView(self.contentView);
        
        [self setupAutoHeightWithBottomView:_picImageView bottomMargin:0];
        
    }
    return self;
}

-(void)setModel:(PhotoModel *)model{
    _model = model;
    _picImageView.sd_layout.autoHeightRatio(model.h/model.w);
//    if (model.image) {
//        _picImageView.image = model.image;
//    }else{
        [_picImageView sd_setImageWithURL:[NSURL URLWithString:model.src]];
//    }
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
