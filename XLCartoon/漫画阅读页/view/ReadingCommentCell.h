//
//  ReadingCommentCell.h
//  XLCartoon
//
//  Created by Amitabha on 2018/3/5.
//  Copyright © 2018年 XLCR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "commentModel.h"
@interface ReadingCommentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (nonatomic,strong) commentModel * model;

+(instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;
@end
