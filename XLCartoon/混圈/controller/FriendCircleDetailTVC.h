//
//  FriendCircleDetailTVC.h
//  XLCartoon
//
//  Created by Amitabha on 2017/12/19.
//  Copyright © 2017年 XLCR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FridenCircliModel.h"
#import "BaseTableViewController.h"
@interface FriendCircleDetailTVC : BaseTableViewController
@property (nonatomic,strong) NSIndexPath * indexPath;
@property (nonatomic,strong) FridenCircliModel * model;
-(void)rightBtnClick;
@end
