//
//  SliderView.h
//  XLCartoon
//
//  Created by Amitabha on 2018/3/7.
//  Copyright © 2018年 XLCR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ASValueTrackingSlider.h>
//typedef void(^dismissBlock)(void);


@interface SliderView : UIView

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewBottomConstraint;
@property (weak, nonatomic) IBOutlet ASValueTrackingSlider *slider;
//@property (copy, nonatomic) SelectedBlock selectedBlock;
@property (copy, nonatomic) void(^dismisssBlock)(void);
@end
