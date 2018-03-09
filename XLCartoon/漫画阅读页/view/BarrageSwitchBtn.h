//
//  BarrageSwitchBtn.h
//  XLCartoon
//
//  Created by Amitabha on 2018/1/15.
//  Copyright © 2018年 XLCR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BarrageSwitchBtnView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *icon;

@end

@interface BarrageSwitchBtn : UIButton
@property (strong, nonatomic) UIImageView *icon;
@end
