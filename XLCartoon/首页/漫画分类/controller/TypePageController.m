//
//  TypePageController.m
//  XLCartoon
//
//  Created by Amitabha on 2017/12/23.
//  Copyright © 2017年 XLCR. All rights reserved.
//

#import "TypePageController.h"
#import "CartoonTypeModel.h"
#import "CartoonInfoModel.h"
#import "TypeCollectionViewController.h"
@interface TypePageController ()

@property (nonatomic,strong) NSMutableArray < CartoonTypeModel *>* typeModelArr;

@end

@implementation TypePageController

-(instancetype)init{
    if (self = [super init]) {
        self.menuViewStyle  = WMMenuViewStyleLine;
        /** 是否自动通过字符串计算 MenuItem 的宽度，默认为 NO. */
        self.automaticallyCalculatesItemWidths = YES;
        self.progressHeight = 2.5;
        self.titleColorSelected = COLOR_NAVI;
        self.titleColorNormal = [UIColor grayColor];
        self.titleSizeNormal = 16.3;
        self.titleSizeSelected = 16.3;
        _typeModelArr = [NSMutableArray array];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self getType];
    self.title = @"所有分类";
    self.edgesForExtendedLayout =UIRectEdgeNone;

}
-(NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController{
    return  _typeModelArr.count;
}
-(NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index{
    return  _typeModelArr[index].cartoonType;
}
- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {

    TypeCollectionViewController * vc = [[TypeCollectionViewController alloc] init];
    vc.typeId = _typeModelArr[index].id;
    return vc;
}

-(CGFloat)menuView:(WMMenuView *)menu widthForItemAtIndex:(NSInteger)index{
    CGFloat width = [super menuView:menu widthForItemAtIndex:index];
    return width+20;
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    CGFloat leftMargin = self.showOnNavigationBar ? 50 : 0;
//    CGFloat originY = self.showOnNavigationBar ? 0 : CGRectGetMaxY(self.navigationController.navigationBar.frame);
    return CGRectMake(leftMargin, 0, self.view.frame.size.width - 2*leftMargin, 44);
}
- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    
    CGFloat originY = CGRectGetMaxY([self pageController:pageController preferredFrameForMenuView:self.menuView]);
    return CGRectMake(0, originY, self.view.frame.size.width, self.view.frame.size.height - originY);
}
-(void)getType{

    NSDictionary * param = @{@"nowPage":@"1"};
    [AfnManager postWithUrl:URL_TYPE param:param Sucess:^(NSDictionary *responseObject) {
        for (NSDictionary * dict in OBJ(responseObject)) {
            [_typeModelArr addObject: [CartoonTypeModel mj_objectWithKeyValues:dict]];
        }
        [self reloadData];
    }];
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

