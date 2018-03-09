//
//  LockCartoonCell.h
//  XLCartoon
//
//  Created by Amitabha on 2018/3/3.
//  Copyright © 2018年 XLCR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReadingCartoonModel.h"
#import "EpisodeModel.h"
@protocol LockCartoonCellDelegate <NSObject>

@required

-(void)LockCartoonCellUnlockSucess;

@end

@interface LockCartoonCell : UITableViewCell
@property (nonatomic, weak) id <LockCartoonCellDelegate> delegate;
@property (nonatomic, strong) ReadingCartoonModel * model;

+(instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;
@end
