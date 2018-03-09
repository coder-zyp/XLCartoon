//
//  CommentListTableViewController.h
//  XLCartoon
//
//  Created by Amitabha on 2018/1/24.
//  Copyright © 2018年 XLCR. All rights reserved.
//

#import "BaseTableViewController.h"

@interface CommentListTableViewController : BaseTableViewController
@property (nonatomic,strong) NSString * cartoonSetId;
@property (nonatomic,strong) NSString * cartoonId;
@property (nonatomic,strong) NSString * type;//0热度，1 时间
@end
