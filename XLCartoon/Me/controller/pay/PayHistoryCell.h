//
//  PayHistoryCell.h
//  XLCartoon
//
//  Created by Amitabha on 2017/12/19.
//  Copyright © 2017年 XLCR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "payHistoryModel.h"
@interface PayHistoryCell : UITableViewCell
@property (nonatomic,strong) payHistoryModel * model;

+(CGFloat)cellHeight;

@end
