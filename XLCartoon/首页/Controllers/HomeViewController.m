//
//  HomeViewController.m
//  XLGame
//
//  Created by yuchutian on 2017/9/28.
//  Copyright © 2017年 In.于楚天. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeNewViewController.h"
//#import "HomeFindTableViewController.h"
#import "FindCollectionViewController.h"
#import "WMPageController.h"
#import <PYSearchViewController.h>
#import "CaricatureDetailViewController.h"
#import "CartoonInfoModel.h"
#import "ReadingHistoryCell.h"
//#import <WRNavigationBar.h>


@interface HomeViewController ()<PYSearchViewControllerDelegate,PYSearchViewControllerDataSource>
@property (nonatomic,strong)  UINavigationController * presentNavi;
@property (nonatomic,strong)  NSMutableArray < cartoon *> * modelArr;
//@property (nonatomic,strong) 
@end

@implementation HomeViewController


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
        _modelArr = [NSMutableArray array];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"search"] style:UIBarButtonItemStyleDone target:self action:@selector(searchItemClick:)];

    self.edgesForExtendedLayout = UIRectEdgeNone;
}
//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    self.title = @"首页";
//}
//-(void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//    self.title = @"";
//}
-(NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController{
    return 2;
}
-(NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index{
    self.titles = @[@"发现", @"推荐"];
    return self.titles[index];
}
- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    switch (index) {
        case 0: return [[FindCollectionViewController alloc] init];
        case 1: return [[HomeNewViewController alloc] init];
    }
    return [[UIViewController alloc] init];
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
    
    return CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}

-(void)searchItemClick:(UIBarButtonItem *)btn{

    [AfnManager postWithUrl:URL_HOT_SEARCH param:nil Sucess:^(NSDictionary *responseObject) {
        [self createSearchController:OBJ(responseObject)];
    }];
}
-(void)createSearchController:(NSArray *)hotSearches{
    PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:hotSearches searchBarPlaceholder: @"输入漫画名称" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        NSLog(@"%@",searchText);
    }];
    searchViewController.delegate = self;
    searchViewController.dataSource = self;
    searchViewController.searchBar.tintColor = self.view.tintColor;
    
//    searchViewController.navigationItem.leftBarButtonItem = [UIBarButtonItem new];
//    //4.添加手势
//    UIScreenEdgePanGestureRecognizer * gesture = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self.navigationController action:@selector(popViewControllerAnimated:)];
//    gesture.edges = UIRectEdgeLeft;
//    [searchViewController.view addGestureRecognizer:gesture];
    
    BaseNavigationController * navi =[[BaseNavigationController alloc]initWithRootViewController:searchViewController];
    [navi.navigationBar setBarTintColor:COLOR_NAVI];
//    [self.navigationController pushViewController:searchViewController animated:NO];
    [self presentViewController:navi animated:YES completion:nil];
}

#pragma mark - PYSearchViewControllerDelegate
-(NSInteger)searchSuggestionView:(UITableView *)searchSuggestionView numberOfRowsInSection:(NSInteger)section{
    return _modelArr.count;
}
-(UITableViewCell *)searchSuggestionView:(UITableView *)searchSuggestionView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ReadingHistoryCell * cell =[ReadingHistoryCell cellWithTableView:searchSuggestionView];
    CartoonDetailModel * model = [CartoonDetailModel new];
    model.cartoon = self.modelArr[indexPath.row];
    cell.model = model;
    return cell;
}
- (void)searchViewController:(PYSearchViewController *)searchViewController didSelectSearchSuggestionAtIndexPath:(NSIndexPath *)indexPath searchBar:(UISearchBar *)searchBar{
    CartoonDetailModel * model = [CartoonDetailModel new];
    CaricatureDetailViewController * vc = [[CaricatureDetailViewController alloc]init];
    model.cartoon = self.modelArr[indexPath.row];
    vc.cartoonId = model.cartoon.id;
//    [self.presentNavi dismissViewControllerAnimated:YES completion:nil];
    [searchViewController.navigationController pushViewController:vc animated:YES];
}
-(void)searchViewController:(PYSearchViewController *)searchViewController didSelectHotSearchAtIndex:(NSInteger)index searchText:(NSString *)searchText{
    [self searchViewController:searchViewController searchTextDidChange:searchViewController.searchBar searchText:searchText];
}
-(void)searchViewController:(PYSearchViewController *)searchViewController didSelectSearchHistoryAtIndex:(NSInteger)index searchText:(NSString *)searchText{
    [self searchViewController:searchViewController searchTextDidChange:searchViewController.searchBar searchText:searchText];
}
-(CGFloat)searchSuggestionView:(UITableView *)searchSuggestionView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [ReadingHistoryCell cellHeight];
}
- (void)searchViewController:(PYSearchViewController *)searchViewController searchTextDidChange:(UISearchBar *)seachBar searchText:(NSString *)searchText
{
    
    if (searchText.length) {

        NSDictionary * param = @{@"content":searchText};
        
        [AfnManager postWithUrl:URL_SEARCH param:param Sucess:^(NSDictionary *responseObject) {
            self.modelArr = [NSMutableArray array];
            for (NSDictionary * dic in OBJ(responseObject)) {
                [self.modelArr addObject:[cartoon mj_objectWithKeyValues:dic]];
            }
            [searchViewController.searchSuggestionView reloadData];
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
