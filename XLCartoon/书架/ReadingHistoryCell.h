//
//  ReadingHistoryCell.h
//  XLGame
//
//  Created by Amitabha on 2017/12/11.
//  Copyright © 2017年 In.于楚天. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CartoonInfoModel.h"
@interface ReadingHistoryCell : UITableViewCell
@property (nonatomic,strong) CartoonDetailModel * model;
@property (nonatomic,strong) UILabel * topBlackLabel;
+(ReadingHistoryCell *)cellWithTableView:(UITableView *)tableView;
+(CGFloat)cellHeight;
@end
