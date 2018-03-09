//
//  MyMessageCell.h
//  XLCartoon
//
//  Created by Amitabha on 2018/1/16.
//  Copyright © 2018年 XLCR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyMessageModel.h"
@interface MyMessageCell : UITableViewCell

@property (nonatomic,strong) MyMessageModel * model;

+(MyMessageCell *)cellWithTableView:(UITableView *)tableView;

@end
