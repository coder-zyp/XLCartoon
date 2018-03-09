//
//  everyDayShowView.h
//  XLCartoon
//
//  Created by Amitabha on 2018/1/22.
//  Copyright © 2018年 XLCR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CartoonInfoModel.h"
//typedef void(^clickBlock)(CartoonDetailModel * model);
@interface everyDayShowView : UIView
@property (weak, nonatomic) IBOutlet UILabel *updateTipLabel;
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet UIView *btnView;
@property (weak, nonatomic) IBOutlet UIView *backVIew;
@property (weak, nonatomic) IBOutlet UIImageView *addMoneyImageView;
@property (nonatomic,strong) NSMutableArray * modelArr;
@property (nonatomic,copy) void(^clickBlock)(CartoonDetailModel * model);

@end
