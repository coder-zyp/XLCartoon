 //
//  HomeNewViewController.m
//  XLGame
//
//  Created by Amitabha on 2017/12/9.
//  Copyright © 2017年 In.于楚天. All rights reserved.
//

#import "HomeNewViewController.h"
#import "SDCycleScrollView.h"
#import "UIImageView+WebCache.h"
#import "UIButton+JKImagePosition.h"
#import "FSCustomButton.h"
#import "HomeNewCell.h"
#import "CaricatureDetailViewController.h"
#import "BannerModel.h"
#import "CartoonInfoModel.h"
#import "TopTableViewController.h"



@interface HomeNewViewController ()


@property (nonatomic,strong) NSMutableArray <CartoonDetailModel *>* modelArr;

@end

@implementation HomeNewViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.modelArr = [NSMutableArray array];
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    adjustsScrollViewInsets_NO(self.tableView, self);
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.mj_header = [MJGifHeader headerWithRefreshingBlock:^{
        self.pageIndex = 0;
        [self getData];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if (self.pageIndex == self.pageToale) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [self getCartoonListData];
        }
    }];
    [self getData];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;


    [self.tableView registerNib:[UINib nibWithNibName:@"HomeNewCell" bundle:[NSBundle mainBundle] ] forCellReuseIdentifier:@"HomeNewCell"];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
-(void)getData{
    [super getData];
    
    [self getCartoonListData];
}

- (void)getCartoonListData{
    
    NSDictionary * param = @{@"nowPage": [NSString stringWithFormat:@"%d",self.pageIndex+1]};
    
    
    [AfnManager postListDataUrl:URL_HOME_CARTOON_LIST param:param result:^(NSDictionary *responseObject) {
        if (responseObject) {
            if (self.tableView.mj_header.isRefreshing) {
                self.modelArr = [NSMutableArray array];
                [self.tableView.mj_footer resetNoMoreData];
            }
            for (NSDictionary * dict in [responseObject objectForKey:@"obj"]) {
                [_modelArr addObject:[CartoonDetailModel mj_objectWithKeyValues:dict]];
                
            }
            self.pageIndex = PAGE_INDEX(responseObject);
            self.pageToale = PAGE_TOTAL(responseObject);
            [self.tableView reloadData];
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        self.loading = NO;
        
    }];
}


#pragma mark - UITableViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.modelArr.count;
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeNewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"HomeNewCell" forIndexPath:indexPath];
    cell.model = self.modelArr[indexPath.row];

    return  cell;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
//    ((HomeNewCell *)cell).model = self.modelArr[indexPath.row];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    return [tableView cellHeightForIndexPath:indexPath model:self.modelArr[indexPath.row] keyPath:@"model" cellClass:[HomeCell class] contentViewWidth:SCREEN_WIDTH];
    return (SCREEN_WIDTH-30)*0.382+80;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CaricatureDetailViewController * vc =[CaricatureDetailViewController new];
//    vc.cartoonId = _modelArr[indexPath.row].cartoon.id;
    vc.cartoonId = _modelArr[indexPath.row].cartoon.id;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
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
