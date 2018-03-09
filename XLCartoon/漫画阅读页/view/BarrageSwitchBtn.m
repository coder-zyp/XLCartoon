//
//  BarrageSwitchBtn.m
//  XLCartoon
//
//  Created by Amitabha on 2018/1/15.
//  Copyright © 2018年 XLCR. All rights reserved.
//

#import "BarrageSwitchBtn.h"


@implementation BarrageSwitchBtnView
-(void)awakeFromNib{
    [super awakeFromNib];
}
@end

@implementation BarrageSwitchBtn

- (instancetype)init
{
    self = [super init];
    if (self) {
        BarrageSwitchBtnView * view = [[[NSBundle mainBundle] loadNibNamed:@"BarrageSwitchBtn" owner:self options:nil] firstObject];
        [self addSubview:view];
        view.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
        self.icon = view.icon;
    }
    return self;
}


@end
