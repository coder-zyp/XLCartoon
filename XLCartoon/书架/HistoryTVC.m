//
//  HistoryTVC.m
//  XLCartoon
//
//  Created by Amitabha on 2017/12/29.
//  Copyright © 2017年 XLCR. All rights reserved.
//

#import "HistoryTVC.h"
#import "ReadingHistoryCell.h"
#import "CartoonInfoModel.h"
#import "CaricatureDetailViewController.h"
@interface HistoryTVC ()
@property (nonatomic,strong) NSMutableArray <cartoon *>* modelArr;
@end

@implementation HistoryTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _modelArr = [NSMutableArray array];

    
    self.tableView.mj_header = [MJGifHeader headerWithRefreshingBlock:^{
        self.pageIndex = 0;
        [self getData];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if (self.pageIndex == self.pageToale) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [self getData];
        }
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView.mj_header beginRefreshing];
}
-(void)getData{
    [super getData];
    NSDictionary * param = @{@"nowPage":[NSString stringWithFormat:@"%ld",self.pageIndex+1]};

    [AfnManager postListDataUrl:URL_BOOKSHELF_HISTORY param:param result:^(NSDictionary *responseObject) {
        if (responseObject) {
            if (self.tableView.mj_header.isRefreshing) {
                self.modelArr = [NSMutableArray array];
                [self.tableView.mj_footer resetNoMoreData];
            }
            for (NSDictionary * dict in OBJ(responseObject)) {
                [_modelArr addObject:[cartoon mj_objectWithKeyValues:dict]];
            }
            [self.tableView reloadData];
            NSLog(@"%@",_modelArr[0].updateType);
            self.pageIndex = PAGE_INDEX(responseObject);
            self.pageToale = PAGE_TOTAL(responseObject);
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        self.loading = NO;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modelArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  [ReadingHistoryCell cellWithTableView:tableView];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [ReadingHistoryCell cellHeight];
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    CartoonDetailModel * model = [CartoonDetailModel new];
    model.cartoon = self.modelArr[indexPath.row];
    ((ReadingHistoryCell *)cell).model = model;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CartoonDetailModel * model = [CartoonDetailModel new];
    model.cartoon = self.modelArr[indexPath.row];
    CaricatureDetailViewController * vc = [[CaricatureDetailViewController alloc]init];
    vc.cartoonId = model.cartoon.id;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


@end
