//
//  PayHistoryCell.m
//  XLCartoon
//
//  Created by Amitabha on 2017/12/19.
//  Copyright © 2017年 XLCR. All rights reserved.
//

#import "PayHistoryCell.h"

@interface PayHistoryCell()

@property (weak, nonatomic) IBOutlet UILabel *orderNumLabel;
@property (nonatomic,weak) IBOutlet UILabel * payContentLabel;
@property (nonatomic,weak) IBOutlet UILabel * timeLabel;
;

@end

@implementation PayHistoryCell


-(void)setModel:(payHistoryModel *)model{
    _model = model;

    _orderNumLabel.text = [NSString stringWithFormat:@"%@订单号:%@",@"",model.orderNum];
    _timeLabel.text = model.orderImplDate;
    _payContentLabel.text = [NSString stringWithFormat:@"%@\t%@元",model.orderRemarks,model.orderMoney];
}
-(void)awakeFromNib{
    [super awakeFromNib];
     _timeLabel.textColor = _orderNumLabel.textColor = [UIColor grayColor];
}

+(CGFloat)cellHeight{
    return 87;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
