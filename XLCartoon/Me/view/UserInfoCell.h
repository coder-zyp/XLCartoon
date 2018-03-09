//
//  UserInfoCell.h
//  XLCartoon
//
//  Created by Amitabha on 2018/1/29.
//  Copyright © 2018年 XLCR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"
@interface UserInfoCell : UITableViewCell

@property (nonatomic,strong) UserModel * model;

+(instancetype )cellWithTableView:(UITableView *)tableView;

@end
