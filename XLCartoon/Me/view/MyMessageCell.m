//
//  MyMessageCell.m
//  XLCartoon
//
//  Created by Amitabha on 2018/1/16.
//  Copyright © 2018年 XLCR. All rights reserved.
//

#import "MyMessageCell.h"
@interface MyMessageCell()
@property (nonatomic,strong) NSArray <UILabel *>* labels;
@end

@implementation MyMessageCell

+(MyMessageCell *)cellWithTableView:(UITableView *)tableView{
    static NSString * cellId = @"MyMessageCell";
    MyMessageCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    cell = [[MyMessageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
//    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    return cell;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        [self.contentView setupAutoWidthFlowItems:self.labels withPerRowItemsCount:1 verticalMargin:10 horizontalMargin:0 verticalEdgeInset:15 horizontalEdgeInset:20];
        [self setupAutoHeightWithBottomView:[_labels lastObject] bottomMargin:10];
    }
    return self;
}
-(void)setModel:(MyMessageModel *)model{
    _model = model;
    NSArray * texts = @[model.title,model.content,model.implDate];
    int i = 0;
    for (UILabel * label in _labels) {
        label.text = [texts objectAtIndex:i];
        i++;
    }
}
-(NSArray<UILabel *> *)labels{
    if (!_labels) {
        NSArray * fontSizes = @[@15.5,@15,@13];
        NSMutableArray * arr = [NSMutableArray array];
        for (int i =0 ; i<3; i++) {
            UILabel * label = [UILabel new];
            if (i==0) {
                label.textColor = RGB(93, 107, 147);
            }else{
                label.textColor = [UIColor grayColor];
            }
            [self.contentView addSubview:label];
            label.font = [UIFont systemFontOfSize:[fontSizes[i] floatValue]];
            label.sd_layout.autoHeightRatio(0);
            [arr addObject:label];
        }
        _labels = arr;
    }
    return _labels;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
