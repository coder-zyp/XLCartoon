//
//  CartoonSetPageViewController.m
//  XLCartoon
//
//  Created by Amitabha on 2017/12/23.
//  Copyright © 2017年 XLCR. All rights reserved.
//

#import "CartoonSetPageViewController.h"
#import "HistoryTVC.h"
#import "BookShelfFollowTVC.h"
@interface CartoonSetPageViewController ()

@property (nonatomic,strong) NSArray * titleArr;

@end

@implementation CartoonSetPageViewController

-(instancetype)init{
    if (self = [super init]) {
        self.menuViewStyle  = WMMenuViewStyleLine;
        /** 是否自动通过字符串计算 MenuItem 的宽度，默认为 NO. */
        self.automaticallyCalculatesItemWidths = YES;
        self.progressHeight = 1;
        self.titleColorSelected = COLOR_NAVI;
        self.showOnNavigationBar= YES;
        self.titleColorNormal = [UIColor grayColor];
        self.titleColorSelected = [UIColor whiteColor];
        self.titleColorNormal = rgba(255, 255, 255, 0.7);
        self.titleSizeNormal = 18.3;
        self.titleSizeSelected = 18.3;
        self.progressViewBottomSpace = 7;
        _titleArr = @[@"收藏",@"历史"];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    [self setSelectIndex:1];
}
-(NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController{
    return  _titleArr.count;
}
-(NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index{
    return  _titleArr[index];
}
- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    UIViewController * vc;
    switch (index) {
        case 0:
            vc = [[BookShelfFollowTVC alloc] init];
            break;
        case 1:
            vc = [[HistoryTVC alloc] init];
        default:
            break;
    }
    return vc;
}

-(CGFloat)menuView:(WMMenuView *)menu widthForItemAtIndex:(NSInteger)index{
    CGFloat width = [super menuView:menu widthForItemAtIndex:index];
    return width+5;
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    CGFloat leftMargin = self.showOnNavigationBar ? 80 : 0;
    CGFloat originY = self.showOnNavigationBar ? 0 : CGRectGetMaxY(self.navigationController.navigationBar.frame);
    return CGRectMake(leftMargin, originY, self.view.frame.size.width - 2*leftMargin, 44);
}
- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    
    CGFloat bottomSpace = TabbarHeight;
    if (@available(iOS 11.0, *)) {
        bottomSpace = 0;
    }
    return CGRectMake(0, NaviHeight, self.view.frame.size.width, self.view.frame.size.height - NaviHeight-bottomSpace);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
