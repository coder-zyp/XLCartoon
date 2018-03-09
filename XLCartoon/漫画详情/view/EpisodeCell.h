//
//  EpisodeCell.h
//  XLGame
//
//  Created by Amitabha on 2017/12/13.
//  Copyright © 2017年 In.于楚天. All rights reserved.
// 选章节页面

#import <UIKit/UIKit.h>
#import "EpisodeModel.h"
@interface EpisodeCell : UITableViewCell

@property(strong, nonatomic) UIView * playHistoryView;
@property(strong, nonatomic) EpisodeModel * model;
+(EpisodeCell *)cellWithTableView:(UITableView *)tableView;
+(CGFloat)cellHeight;

@end
