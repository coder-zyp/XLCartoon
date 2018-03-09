//
//  CommentCell.h
//  XLGame
//
//  Created by Amitabha on 2017/12/11.
//  Copyright © 2017年 In.于楚天. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "commentModel.h"



@interface CommentCell : UITableViewCell
@property (nonatomic,strong) commentModel * model;
@property (nonatomic,strong) UIButton * praiseBtn;
@property (nonatomic,strong) NSString * PraiseUrl;
@property (nonatomic,strong) UIView * otherCommentView;

+(instancetype )cellWithTableView:(UITableView *)tableView contentViewColor:(UIColor *)color;

@end
