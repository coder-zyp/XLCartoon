//
//  ReadingTabBar.m
//  XLCartoon
//
//  Created by Amitabha on 2018/3/5.
//  Copyright © 2018年 XLCR. All rights reserved.
//

#import "ReadingTabBar.h"
@interface ReadingTabBar()<UITabBarDelegate>
@end
@implementation ReadingTabBar
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, SCREEN_HEIGHT-TabbarHeight, SCREEN_WIDTH, TabbarHeight);
        self.barTintColor = COLOR_NAVI;
        self.tintColor = [UIColor whiteColor];
        self.delegate = self;
        self.translucent = NO;
        self.barStyle = UIBarStyleBlack;
        self.layer.borderColor = [COLOR_NAVI CGColor];
        //        [_tabBar setBackgroundImage:[[UIImage alloc]init]];
        
        NSArray * titles = @[@"发弹幕",@"评论",@"目录",@"进度",@"亮度"];
        
        int i = 0;
        NSMutableArray * items = [NSMutableArray array];
        for (NSString * title in titles) {
            UIImage * image = [[UIImage imageNamed:[NSString stringWithFormat:@"reading-%@", title]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            UITabBarItem * item = [[UITabBarItem alloc]initWithTitle:title image:image tag:i];
            [items addObject:item];
            [item setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.f],NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
            [self setSelectedItem:item];
            i++;
        }
        [self setItems:items];
    }
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
