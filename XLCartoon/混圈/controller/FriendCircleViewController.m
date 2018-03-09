//
//  FriendCircleViewController.m
//  XLGame
//
//  Created by Amitabha on 2017/12/16.
//  Copyright © 2017年 In.于楚天. All rights reserved.
//

#import "FriendCircleViewController.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "sendFriendCircleViewController.h"
#import "FriendCircleDetailTVC.h"
#import "FridenCircliModel.h"
#import "FridenCircleCell.h"
#import "CommentWindow.h"
#define delegateMyCircle

@interface FriendCircleViewController ()<FridenCircleCellDelegate>
@property (nonatomic, strong) NSMutableArray <FridenCircliModel *>*dataArray;
@end

@implementation FriendCircleViewController

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //为self.view 添加背景颜色设置
    
    self.view.backgroundColor = COLOR_SYSTEM_GARY;
    
    
    UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"相机"] style:UIBarButtonItemStyleDone target:self action:@selector(rightItemClick)];
    self.navigationItem.rightBarButtonItem = item;

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
    }];;
    [self getData];
    if (_isMyFriend) {
        self.title = @"我的混圈";
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)getData{
    [super getData];
    NSString * url =_isMyFriend ? URL_FRIEND_MY : URL_FRIEND_ALL;
    NSDictionary * param = @{@"nowPage":[NSString stringWithFormat:@"%ld",self.pageIndex+1]
                             };

    if (!_isMyFriend) {
        NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:param];
        [dic setObject:@"1"forKey:@"newHot"];
        param = dic;
    }
    [AfnManager postListDataUrl:url param:param result:^(NSDictionary *responseObject) {
        if (responseObject) {
            if (self.tableView.mj_header.isRefreshing) {
                self.dataArray = [NSMutableArray array];
                [self.tableView.mj_footer resetNoMoreData];
            }
            for (NSDictionary * dict in OBJ(responseObject)) {
                FridenCircliModel * model = [FridenCircliModel mj_objectWithKeyValues:dict];
                if (_isMyFriend) {
                    model.user = [userModel mj_objectWithKeyValues:[responseObject objectForKey:@"spare"]];
                }
                [self.dataArray addObject:model];
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


-(void )rightItemClick{
    sendFriendCircleViewController * vc = [sendFriendCircleViewController new];
    vc.hidesBottomBarWhenPushed = YES;
    vc.block = ^{
        [self.tableView.mj_header beginRefreshing];
    };
    [self.navigationController pushViewController:vc animated:YES];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FridenCircleCell *cell = [FridenCircleCell cellWithTableView:tableView];
    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    cell.model = self.dataArray[indexPath.row];
    cell.delegate = self;
    return cell;
}
#pragma mark- cell Delegate
-(void)FridenCircleCellImageBtnClickWithPreviewVC:(UIViewController *)vc{
    [self presentViewController:vc animated:YES completion:nil];
}
-(void)FridenCommentBtnClickWithModel:(FridenCircliModel *)model{
    [CommentWindow shareWithFinshBlock:^(NSString *text, CommentWindow *window) {
        [self sendComment:text model:model];
        window.textView.text = nil;
    }];
    
}
-(void)sendComment:(NSString *)text model:(FridenCircliModel *)model{
    [SVProgressHUD show];
    NSDictionary * param = @{@"friendCircleId":model.friendsCircle.id,
                             @"commentInfo":text
                             };
    [AfnManager postUserAction:URL_FRIEND_COMMENT_SEND param:param Sucess:^(NSDictionary *responseObject) {
        [CommentWindow share].textView.text = @"";
        FriendCircleDetailTVC * vc= [[FriendCircleDetailTVC alloc]init];
        if (![model.friendsCircle.commentCount containsString:@"万"] ||![model.friendsCircle.commentCount containsString:@"w"]) {
            model.friendsCircle.commentCount = [NSString stringWithFormat:@"%ld",model.friendsCircle.commentCount.integerValue +1];
        }
        vc.model = model;
        [self.navigationController pushViewController:vc animated:YES];
        
        [self.tableView reloadData];
    }];
}
-(void)FridenDeleteBtnClickWithModel:(FridenCircliModel *)model{
    
    UIAlertController * ac = [UIAlertController alertControllerWithTitle:nil message:@"是否删除此混圈" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * aa = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [SVProgressHUD show];
        NSDictionary * param = @{@"id":model.friendsCircle.id};
        [AfnManager postWithUrl:URL_FRIEND_DELETE param:param Sucess:^(NSDictionary *responseObject) {
            [self.dataArray removeObject:model];
            [self.tableView reloadData];
            if (_isMyFriend) {
                UINavigationController * navi = APP_DELEGATE.tabBarVC.viewControllers[2];
                FriendCircleViewController * vc = [navi.viewControllers firstObject];
                [vc.tableView.mj_header beginRefreshing];
            }
        }];
    }];
    UIAlertAction * aa2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [ac addAction:aa];
    [ac addAction:aa2];
    [self presentViewController:ac  animated:YES completion:nil];
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FriendCircleDetailTVC * vc= [[FriendCircleDetailTVC alloc]init];
    vc.model = self.dataArray[indexPath.row];
    vc.indexPath = indexPath;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id model = self.dataArray[indexPath.row];
    return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[FridenCircleCell class] contentViewWidth:[self cellContentViewWith]];
}


- (CGFloat)cellContentViewWith
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    // 适配ios7横屏
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
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
