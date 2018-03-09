//
//  CommentPageController.m
//  XLCartoon
//
//  Created by Amitabha on 2018/1/24.
//  Copyright © 2018年 XLCR. All rights reserved.
//

#import "CommentPageController.h"
#import "CommentListTableViewController.h"
@interface CommentPageController ()

@end

@implementation CommentPageController


-(instancetype)init{
    if (self = [super init]) {
        self.menuViewStyle  = WMMenuViewStyleLine;
        /** 是否自动通过字符串计算 MenuItem 的宽度，默认为 NO. */
        self.automaticallyCalculatesItemWidths = YES;
        self.showOnNavigationBar = YES;
        self.progressHeight = 1;
        self.progressViewBottomSpace = 7;
        self.titleColorSelected = [UIColor whiteColor];
        self.titleColorNormal = rgba(255, 255, 255, 0.7);
        self.titleSizeNormal = 18.3;
        self.titleSizeSelected = 18.3;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    // Do any additional setup after loading the view.
}
-(NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController{
    return 2;
}
-(NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index{
    self.titles = @[@"最热", @"最新"];
    return self.titles[index];
}
- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    CommentListTableViewController * vc =[[CommentListTableViewController alloc] init];
    vc.type = index ? @"1" :@"0";
    vc.cartoonId = self.cartoonId;
    vc.cartoonSetId = self.cartoonSetId;
    return vc;
}

-(CGFloat)menuView:(WMMenuView *)menu widthForItemAtIndex:(NSInteger)index{
    CGFloat width = [super menuView:menu widthForItemAtIndex:index];
    return width+5;
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    CGFloat leftMargin = self.showOnNavigationBar ? 50 : 0;
    CGFloat originY = self.showOnNavigationBar ? 0 : CGRectGetMaxY(self.navigationController.navigationBar.frame);
    return CGRectMake(leftMargin, originY, self.view.frame.size.width - 2*leftMargin, 44);
}
- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    
    return CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
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
