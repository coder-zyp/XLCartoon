//
//  FriendCircleDetailTVC.m
//  XLCartoon
//
//  Created by Amitabha on 2017/12/19.
//  Copyright © 2017年 XLCR. All rights reserved.
//

#import "FriendCircleDetailTVC.h"
#import "FridenCircleCell.h"
#import "CommentWindow.h"
#import "FriendCircleViewController.h"

@interface FriendCircleDetailTVC ()<FridenCircleCellDelegate>

@property (nonatomic,strong) NSMutableArray< FridenCircliModel * >* modelArr;
@property (nonatomic,assign) int commentCount;

@end

@implementation FriendCircleDetailTVC
- (void)viewDidLoad {
    [super viewDidLoad];
    _model.isDetail = YES;
    _modelArr = [NSMutableArray array];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.mj_header = [MJGifHeader headerWithRefreshingBlock:^{
        self.pageIndex = 0;
        [self getData];
    }];
    [self getData];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if (self.pageIndex == self.pageToale) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            
            [self getData];
        }
    }];
    self.title = @"所有评论";
    self.tableView.mj_footer.hidden =YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithTitle:@"回复" style:UIBarButtonItemStyleDone target:self action:@selector(rightBtnClick)];
    self.navigationItem.rightBarButtonItem = item;
}

-(void)rightBtnClick{

    [CommentWindow shareWithFinshBlock:^(NSString *text, CommentWindow *window) {
        [self sendComment:text];
        window.textView.text = nil;
    }];
}

-(void)getData{
    [super getData];
    NSDictionary * param = @{@"id":self.model.friendsCircle.id,
                             @"nowPage":[NSString stringWithFormat:@"%ld",self.pageIndex+1]
                             };
    
    [AfnManager postListDataUrl:URL_FRIEND_COMMENT_BY_ID param:param result:^(NSDictionary *responseObject) {
        if (responseObject) {
            self.commentCount = [[responseObject objectForKey:@"spare"] intValue];
            if (self.tableView.mj_header.isRefreshing) {
                self.modelArr = [NSMutableArray array];
                [self.tableView.mj_footer resetNoMoreData];
            }
            for (NSDictionary * dict in OBJ(responseObject)) {
                [_modelArr addObject:[FridenCircliModel mj_objectWithKeyValues:dict]];
            }
            self.pageIndex = PAGE_INDEX(responseObject);
            self.pageToale = PAGE_TOTAL(responseObject);
            [self.tableView reloadData];
        }
        self.tableView.mj_footer.hidden =NO;
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        self.loading = NO;
    }];

}
-(void)sendComment:(NSString *)text{
    [SVProgressHUD show];
    NSDictionary * param = @{@"friendCircleId":self.model.friendsCircle.id,
                             @"commentInfo":text
                             };
    [AfnManager postUserAction:URL_FRIEND_COMMENT_SEND param:param Sucess:^(NSDictionary *responseObject) {
        [self.tableView.mj_header beginRefreshing];
        [CommentWindow share].textView.text = @"";
        //刷新混圈列表
        if (self.indexPath) {
            if (![self.model.friendsCircle.commentCount containsString:@"万"] ||![self.model.friendsCircle.commentCount containsString:@"w"]) {
                self.model.friendsCircle.commentCount = [NSString stringWithFormat:@"%ld",self.model.friendsCircle.commentCount.integerValue +1];
            }
            UINavigationController * navi = APP_DELEGATE.tabBarVC.viewControllers[2];
            FriendCircleViewController * vc = [navi.viewControllers firstObject];
            [vc.tableView reloadRowsAtIndexPaths:@[self.indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return 1;
    }else{
        return self.modelArr.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FridenCircleCell *cell = [FridenCircleCell cellWithTableView:tableView];
    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.userCommentLabel.sd_layout.maxHeightIs(500);
    [cell.contentView layoutSubviews];
    cell.delegate = self;
    if (indexPath.section!=0){
        cell.deleteBtn.alpha = 0;
    }else{
        cell.deleteBtn.alpha = 1;
    }
    [cell praiseBtnHiden:YES];
    return cell;
}
#pragma mark- cell Delegate
-(void)FridenCircleCellImageBtnClickWithPreviewVC:(UIViewController *)vc{
    [self presentViewController:vc animated:YES completion:nil];
}
-(void)FridenDeleteBtnClickWithModel:(FridenCircliModel *)model{
    
    UIAlertController * ac = [UIAlertController alertControllerWithTitle:nil message:@"是否删除此混圈" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * aa = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [SVProgressHUD show];
        NSDictionary * param = @{@"id":model.friendsCircle.id};
        [AfnManager postWithUrl:URL_FRIEND_DELETE param:param Sucess:^(NSDictionary *responseObject) {
            [self.navigationController popViewControllerAnimated:YES];
            UINavigationController * navi = APP_DELEGATE.tabBarVC.viewControllers[2];
            FriendCircleViewController * vc = [navi.viewControllers firstObject];
            [vc.tableView.mj_header beginRefreshing];
        }];
    }];
    UIAlertAction * aa2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [ac addAction:aa];
    [ac addAction:aa2];
    [self presentViewController:ac  animated:YES completion:nil];
    
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    FridenCircleCell * FridenCell = (FridenCircleCell *)cell;
    if (indexPath.section == 0) {
        FridenCell.model = self.model;
    }else{
        
        FridenCell.model = self.modelArr[indexPath.row];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    FridenCircliModel * model = indexPath.section ? self.modelArr[indexPath.row] : self.model;

    return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[FridenCircleCell class] contentViewWidth:SCREEN_WIDTH];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return 0;
    }
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 10;
    }else {
        return 0;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==1 && self.modelArr.count) {
        UIView * view = [[UIView alloc]init];
        view.frame = CGRectMake(15, 0, SCREEN_WIDTH, 40);
        UILabel * label = [[UILabel alloc]initWithFrame:view.frame];
        
        label.text = [NSString stringWithFormat:@"全部回复（%d）",self.commentCount];
        label.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
        [view addSubview:label];
        view.backgroundColor = [UIColor whiteColor];
        return view;
    }
    return [UIView new];
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    return [UIView new];
}

@end
