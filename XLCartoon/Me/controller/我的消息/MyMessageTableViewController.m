//
//  MyMessageTableViewController.m
//  XLCartoon
//
//  Created by Amitabha on 2018/1/12.
//  Copyright © 2018年 XLCR. All rights reserved.
//

#import "MyMessageTableViewController.h"
#import "MyMessageCell.h"
#import "MyMessageModel.h"
@interface MyMessageTableViewController ()
@property (nonatomic,strong) NSMutableArray * modelArr;
@end

@implementation MyMessageTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的消息";
    _modelArr = [NSMutableArray array];
    [self getData];
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
-(void)getData{
    [super getData];
    NSDictionary * param = @{@"nowPage":[NSString stringWithFormat:@"%ld",self.pageIndex+1]};
    
    [AfnManager postListDataUrl:URL_MY_MESSAGE param:param result:^(NSDictionary *responseObject) {
        if (responseObject) {
            if (self.tableView.mj_header.isRefreshing) {
                self.modelArr = [NSMutableArray array];
                [self.tableView.mj_footer resetNoMoreData];
            }
            for (NSDictionary * dict in OBJ(responseObject)) {
                [_modelArr addObject:[MyMessageModel mj_objectWithKeyValues:dict]];
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
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView cellHeightForIndexPath:indexPath model:_modelArr[indexPath.row] keyPath:@"model" cellClass:[MyMessageCell class] contentViewWidth:SCREEN_WIDTH];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _modelArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [MyMessageCell cellWithTableView:tableView];
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{

    ((MyMessageCell *)cell).model = _modelArr[indexPath.row];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
