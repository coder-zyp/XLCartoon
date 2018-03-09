//
//  topView.h
//  XLGame
//
//  Created by Amitabha on 2017/12/9.
//  Copyright © 2017年 In.于楚天. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CartoonInfoModel.h"

@interface topView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *TitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *iconLabel;
@property (weak, nonatomic) IBOutlet UILabel *playCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *TopNumLabel;
@property (nonatomic,strong) UIView * lineView;
@property (nonatomic,strong) CartoonDetailModel * model;

@end
