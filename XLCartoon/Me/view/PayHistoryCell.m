//
//  PayHistoryCell.m
//  XLCartoon
//
//  Created by Amitabha on 2017/12/19.
//  Copyright © 2017年 XLCR. All rights reserved.
//

#import "PayHistoryCell.h"

@interface PayHistoryCell()
@property (nonatomic,strong) UILabel * orderNumLabel;
@property (nonatomic,strong) UILabel * payContentLabel;
@property (nonatomic,strong) UILabel * timeLabel;
@property (nonatomic,strong) UILabel * fromLabel;
@property (nonatomic,strong) UILabel * moneyLabel;

@end

@implementation PayHistoryCell

+(PayHistoryCell *)cellWithTableView:(UITableView *)tableView{
    static NSString * cellId = @"PayHistoryCell";
    PayHistoryCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    cell = [[PayHistoryCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    return cell;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = COLOR_SYSTEM_GARY;
        UIView * line = [UIView new];
        line.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:line];
        line.sd_layout.topEqualToView(self.contentView).leftEqualToView(self.contentView)
        .rightEqualToView(self.contentView).heightIs(10);
        
        _orderNumLabel = [UILabel new];
        [self.contentView addSubview:_orderNumLabel];
        _orderNumLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
        _orderNumLabel.sd_layout.xIs(15).topSpaceToView(line, 0).widthIs(SCREEN_WIDTH-30).heightIs(18);
        
        line = [UIView new];
        line.backgroundColor = COLOR_LINE;
        [self.contentView addSubview:line];
        line.sd_layout.topSpaceToView(_orderNumLabel, 0).leftEqualToView(self.contentView)
        .rightEqualToView(self.contentView).heightIs(1);
        
        _payContentLabel = [[UILabel alloc] init];
        _payContentLabel.font = Font_Medium(13);
        
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = [UIColor grayColor];
        _timeLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
        
        _fromLabel = [[UILabel alloc] init];
        _fromLabel.textColor = [UIColor grayColor];
        _fromLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
        
        [self.contentView sd_addSubviews:@[_payContentLabel,_timeLabel,_fromLabel]];
         
        _payContentLabel.sd_layout.leftSpaceToView(self.contentView, 15).
        topSpaceToView(line, 16).autoHeightRatio(0);
        [_payContentLabel setSingleLineAutoResizeWithMaxWidth:300];
        
        _timeLabel.sd_layout.leftEqualToView(_payContentLabel).autoHeightRatio(0).bottomSpaceToView(self.contentView, 15);
        [_timeLabel setSingleLineAutoResizeWithMaxWidth:300];
        
        _fromLabel.sd_layout.leftSpaceToView(_timeLabel, 30).centerYEqualToView(_timeLabel)
        .autoHeightRatio(0).widthIs(300);
        
        _orderNumLabel.text = @"订单编号：397011445163896";
        _payContentLabel.text = @"充值:1000剧点\t金额：10元";
        _timeLabel.text = @"2017-12-12 18:54";
        _fromLabel.text = @"来源：充值中心";
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+(CGFloat)cellHeight{
    return 110;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
