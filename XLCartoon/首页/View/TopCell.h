//
//  topView.h
//  XLGame
//
//  Created by Amitabha on 2017/12/9.
//  Copyright © 2017年 In.于楚天. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CartoonInfoModel.h"

@interface TopCell : UITableViewCell

@property (nonatomic,strong) CartoonDetailModel * model;
@property (nonatomic,strong) UILabel * topBlackLabel;
@property (weak, nonatomic) IBOutlet UIImageView * photoView;
@property (weak, nonatomic) IBOutlet UILabel *TitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UIImageView *playIcon;
@property (weak, nonatomic) IBOutlet UILabel *playCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *TopNumLabel;
@property (nonatomic,strong) UIView * lineView;


@end
