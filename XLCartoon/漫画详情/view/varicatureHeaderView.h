//
//  EpisodeHaderView.h
//  XLGame
//
//  Created by Amitabha on 2017/12/13.
//  Copyright © 2017年 In.于楚天. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSCustomButton.h"
#import "CartoonInfoModel.h"
@interface varicatureHeaderView : UIView

@property (nonatomic,strong) CartoonDetailModel * model;

@property (nonatomic,strong) UILabel * summaryLabel;
@property (nonatomic,strong) UIImageView * authorIcon;
@property (nonatomic,strong) UILabel * authorLabel;
@property (nonatomic,strong) FSCustomButton * writeCommentBtn;
@property (nonatomic,strong) UIScrollView * likeScrollViewView;
@property (nonatomic,strong) FSCustomButton * changeLikeBtn;
@end
