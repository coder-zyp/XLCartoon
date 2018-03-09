//
//  ReadingEpisodeCell.h
//  XLCartoon
//
//  Created by Amitabha on 2018/3/6.
//  Copyright © 2018年 XLCR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EpisodeModel.h"

@interface ReadingEpisodeCell : UITableViewCell
@property (nonatomic,strong) EpisodeModel * model;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@end
