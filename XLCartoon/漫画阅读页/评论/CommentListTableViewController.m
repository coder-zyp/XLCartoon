//
//  CommentListTableViewController.m
//  XLCartoon
//
//  Created by Amitabha on 2018/1/24.
//  Copyright © 2018年 XLCR. All rights reserved.
//

#import "CommentListTableViewController.h"
#import "commentModel.h"
#import "CommentWindow.h"
#import "CommentCell.h"
#import "CommentDetailTableViewController.h"

@interface CommentListTableViewController ()
@property (strong, nonatomic) NSMutableArray <commentModel *>* modelArr;
@end

@implementation CommentListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.hidesBottomBarWhenPushed = YES;
    
    self.modelArr = [NSMutableArray array];
    self.tableView.mj_header  = [MJGifHeader headerWithRefreshingBlock:^{
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
    [self getData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)getData{
    [super getData];
    NSDictionary * param = @{@"nowPage":[NSString stringWithFormat:@"%ld",self.pageIndex+1],
                             @"cartoonSetId": _cartoonSetId,
                             @"cartoonId" : _cartoonId,
                             @"bestNew": _type
                             };

    [AfnManager postListDataUrl:URL_GET_COMMENT_Episode param:param result:^(NSDictionary *responseObject) {
        if (responseObject) {
            if (self.tableView.mj_header.isRefreshing) {
                self.modelArr = [NSMutableArray array];
                [self.tableView.mj_footer resetNoMoreData];
            }
            for (NSDictionary * dict in OBJ(responseObject)) {
                [self.modelArr addObject:[commentModel mj_objectWithKeyValues:dict]];
            }
            [self.tableView reloadData];
            self.pageIndex = PAGE_INDEX(responseObject);
            self.pageToale = PAGE_TOTAL(responseObject);
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        self.loading = NO;
    }];
}
#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modelArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentCell *cell = [CommentCell cellWithTableView:tableView  contentViewColor:[UIColor whiteColor]];
    cell.model = self.modelArr[indexPath.row];
    cell.PraiseUrl = URL_PRAISE;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //keyPath 为 model 的属性名，
    return [self.tableView cellHeightForIndexPath:indexPath model:self.modelArr[indexPath.row] keyPath:@"model" cellClass:[CommentCell class] contentViewWidth:SCREEN_WIDTH];
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentDetailTableViewController * vc = [[CommentDetailTableViewController alloc]initWithStyle:UITableViewStyleGrouped];
    
    vc.commentType = CommentByEpisode;
    vc.model = [self.modelArr objectAtIndex:indexPath.row];
    vc.block = ^(commentModel * model) {
        self.modelArr[indexPath.row] = model;
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    };
    [self.navigationController pushViewController:vc animated:YES];
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
