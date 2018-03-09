//
//  TaskCell.h
//  XLCartoon
//
//  Created by Amitabha on 2017/12/19.
//  Copyright © 2017年 XLCR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskModel.h"
@interface TaskCell : UITableViewCell

@property (nonatomic,strong) TaskModel * model;

+(instancetype )cellWithTableView:(UITableView *)tableView;

+(CGFloat)cellHeight;
@end
