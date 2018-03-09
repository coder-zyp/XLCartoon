//
//  TaskCell.m
//  XLCartoon
//
//  Created by Amitabha on 2017/12/19.
//  Copyright © 2017年 XLCR. All rights reserved.
//

#import "TaskCell.h"

@interface TaskCell()
@property (nonatomic,strong) UIImageView * icon;
@property (nonatomic,strong) UILabel * title;
@property (nonatomic,strong) UILabel * contentLabel;
@property (nonatomic,strong) UILabel * taskStateLabel;
@property (nonatomic,strong) UILabel * moneyLabel;
@property (nonatomic,strong) UILabel * taskTypeLabel;
@end

@implementation TaskCell

+(TaskCell *)cellWithTableView:(UITableView *)tableView{
    static NSString * cellId = @"PayHistoryCell";
    TaskCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    cell = [[TaskCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    return cell;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _icon = [[UIImageView alloc]init];
        
        _title = [[UILabel alloc] init];
        _title.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = rgba(152,152,152,1);
        _contentLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"金币"];
        
        _taskStateLabel = [UILabel new];
        _taskStateLabel.textAlignment = NSTextAlignmentCenter;
        _taskStateLabel.layer.borderWidth = 0.6;
        _taskStateLabel.layer.cornerRadius = 12;
        _taskStateLabel.layer.masksToBounds = YES;
        _taskStateLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12.5];
        
        //加+20剧点
        _moneyLabel = [[UILabel alloc] init];
        _moneyLabel.textColor = COLOR_NAVI;
        _moneyLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        
        //新手
        _taskTypeLabel = [UILabel new];
        _taskTypeLabel.textColor = [UIColor whiteColor];
        _taskTypeLabel.textAlignment = NSTextAlignmentCenter;
        _taskTypeLabel.font  = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
        
        
        [self.contentView sd_addSubviews:@[_icon,_title,_contentLabel,imageView,
                                           _taskStateLabel,_moneyLabel,_taskTypeLabel]];
        
        _icon.sd_layout.widthEqualToHeight().yIs(12.5).xIs(12.5).bottomSpaceToView(self.contentView, 12.5);
        
        _title.sd_layout.topSpaceToView(self.contentView, 15).leftSpaceToView(_icon, 10).autoHeightRatio(0);
        [_title setSingleLineAutoResizeWithMaxWidth:200];
        
        imageView.sd_layout.widthEqualToHeight().heightIs(14.5).centerYEqualToView(_title)
        .leftSpaceToView(_title, 8);
        
        _moneyLabel.sd_layout.bottomEqualToView(imageView).leftSpaceToView(imageView, 1).autoHeightRatio(0);
        [_moneyLabel setSingleLineAutoResizeWithMaxWidth:200];
        
        _taskStateLabel.sd_layout.widthIs(57).heightIs(24)
        .rightSpaceToView(self.contentView, 15).centerYEqualToView(self.contentView);
        
        _contentLabel.sd_layout.leftEqualToView(_title).rightSpaceToView(_taskStateLabel,10)
        .heightIs(20).topSpaceToView(_title, 3);
        
        _taskTypeLabel.sd_layout.topEqualToView(_icon).leftEqualToView(_icon)
        .rightEqualToView(_icon).bottomEqualToView(_icon);
        
        
    }
    return self;
}
-(void)setModel:(TaskModel *)model{
    _model = model;
    _title.text = model.cartoonTask.taskName;
    _contentLabel.text = model.cartoonTask.taskInfo;
    _moneyLabel.text = [NSString stringWithFormat:@"+%@咔咔豆",model.cartoonTask.taskAward];
    
//
    
    switch (model.cartoonTask.taskType) {
        case 1:
            _taskTypeLabel.text = @"新手";
            _icon.image = [UIImage imageNamed:@"粉勋章"];
            break;
        case 2:
            _taskTypeLabel.text = @"每日";
            _icon.image = [UIImage imageNamed:@"蓝勋章"];
            break;
        case 3:
            _taskTypeLabel.text = @"登录";
            _icon.image = [UIImage imageNamed:@"紫勋章"];
            break;
    }
//    _taskTypeLabel.text = ;
    
    UIColor * selectColor = COLOR_Orange_Red;
    UIColor * normalColor = [UIColor grayColor];
    switch (model.userTask.buttonState) {
        case 0:
            _taskStateLabel.text = @"去完成";
            _taskStateLabel.textColor = selectColor;
            _taskStateLabel.layer.borderColor = selectColor.CGColor;
            _taskStateLabel.backgroundColor = [UIColor whiteColor];
            break;
        case 1:
            _taskStateLabel.text = @"领奖励";
            _taskStateLabel.textColor = [UIColor whiteColor];
            _taskStateLabel.layer.borderColor = selectColor.CGColor;
            _taskStateLabel.backgroundColor = selectColor;
            break;
        case 2:
            _taskStateLabel.text = @"已完成";
            _taskStateLabel.textColor = normalColor;
            _taskStateLabel.layer.borderColor = normalColor.CGColor;
            _taskStateLabel.backgroundColor = [UIColor whiteColor];
            break;
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+(CGFloat)cellHeight{
    return 70;
}

@end
