//
//  FridenCircleCell.h
//  XLCartoon
//
//  Created by Amitabha on 2017/12/29.
//  Copyright © 2017年 XLCR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FridenCircliModel.h"
#import <YYText.h>
@protocol FridenCircleCellDelegate <NSObject>

@required

-(void)FridenCircleCellImageBtnClickWithPreviewVC:(UIViewController *)vc;
-(void)FridenDeleteBtnClickWithModel:(FridenCircliModel *)model;
-(void)FridenCommentBtnClickWithModel:(FridenCircliModel *)model;

@end

@interface FridenCircleCell : UITableViewCell

@property (nonatomic,strong) FridenCircliModel * model;

@property (nonatomic,strong) UIButton * commentBtn;
@property (nonatomic,strong) UILabel * userCommentLabel;
@property (nonatomic,weak) id<FridenCircleCellDelegate> delegate;
+(FridenCircleCell *)cellWithTableView:(UITableView *)tableView;
@property (nonatomic,strong) UIButton * deleteBtn;

-(void)praiseBtnHiden:(BOOL)isHidden;

@end
