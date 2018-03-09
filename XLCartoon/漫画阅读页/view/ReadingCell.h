//
//  ReadingCell.h
//  XLCartoon
//
//  Created by Amitabha on 2017/12/27.
//  Copyright © 2017年 XLCR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReadingCartoonModel.h"
@interface ReadingCell : UITableViewCell

@property(strong, nonatomic) PhotoModel * model;
+(ReadingCell *)cellWithTableView:(UITableView *)tableView;
@property (nonatomic,strong) UILabel * testLabel;
//+(CGFloat)cellHeight;

@end
