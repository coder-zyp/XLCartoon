//
//  CommentDetailTableViewController.h
//  XLCartoon
//
//  Created by Amitabha on 2017/12/18.
//  Copyright © 2017年 XLCR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "commentModel.h"
#import "BaseTableViewController.h"

typedef NS_ENUM(NSInteger, CommentType) {
    CommentByCartoon,
    CommentByEpisode
};
typedef void(^CommentDetailVCPopBlock)(commentModel * model);

@interface CommentDetailTableViewController : BaseTableViewController
@property (nonatomic,strong) commentModel * model;
@property (nonatomic,assign) CommentType commentType;
@property (copy, nonatomic) CommentDetailVCPopBlock  block ;


@end
