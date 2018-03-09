//
//  CommentTabelViewController.m
//  XLGame
//
//  Created by Amitabha on 2017/12/13.
//  Copyright © 2017年 In.于楚天. All rights reserved.
//

#import "CommentTabelViewController.h"
#import "CaricatureDetailViewController.h"
#import "CommentCell.h"
#import "commentModel.h"
#import "varicatureHeaderView.h"
#import "varicatureHeaderView.h"
#import "CommentDetailTableViewController.h"
//#import "LikeCartoonModel.h"
#import <UIButton+WebCache.h>
#import "CommentWindow.h"
#import "UIResponder+Custom.h"
@interface CommentTabelViewController ()
@property (strong, nonatomic) NSMutableArray <commentModel *>* ModelArr;
@property (nonatomic,strong) varicatureHeaderView * headerView;
@property (nonatomic,strong) NSMutableArray <cartoon *>* LikeModelArr;
@property (nonatomic,assign) int likeIndex;

@end

@implementation CommentTabelViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"详细";
        _LikeModelArr = [NSMutableArray array];
        self.ModelArr = [NSMutableArray array];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(haveCartoonData:) name:@"DataReceiveNotification" object:nil];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.headerView.model = self.model;
    self.tableView.tableHeaderView = self.headerView;
    [self.headerView layoutSubviews];
    //ios 9
    self.tableView.tableHeaderView = self.headerView;
    
    [self getLikeData];
    [self getCommentData];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if (self.pageIndex == self.pageToale) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [self getCommentData];
        }
    }];
//    self.tableView.mj_footer.hidden =;
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
-(void)haveCartoonData:(NSNotification *)notification{
    self.model = [notification.userInfo objectForKey:@"model"];
}
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return -self.tableView.tableHeaderView.frame.size.height;
}
-(void)getCommentData{
    NSDictionary * param =@{@"cartoonId":self.model.cartoon.id,
                           @"nowPage":[NSString stringWithFormat:@"%ld",self.pageIndex+1],
                           @"bestNew":@"0"  //0热度，1 时间
                           };
    [AfnManager postListDataUrl:URL_COMMENT_CARTOON param:param result:^(NSDictionary *responseObject) {
        if (responseObject) {
            for (NSDictionary * dict in OBJ(responseObject)) {
                [_ModelArr addObject:[commentModel mj_objectWithKeyValues:dict]];
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

-(void)getLikeData{
//    SVProgressHUD
    [SVProgressHUD show];
    NSDictionary * param =@{@"nowPage":[NSString stringWithFormat:@"%d",self.likeIndex+1]};
    [AfnManager postWithUrl:URL_LIKE_CARTOON param:param Sucess:^(NSDictionary *responseObject) {
        _LikeModelArr =[NSMutableArray array];
        CGFloat btnW = (SCREEN_WIDTH - 15*4)/3.0;
        CGFloat btnH = btnW * 306.0/200.0;
        [self.headerView.likeScrollViewView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        for (UIView * view in self.headerView.likeScrollViewView.subviews) {
            [view removeFromSuperview];
        }
        if (PAGE_INDEX(responseObject) == PAGE_TOTAL(responseObject)) {
            self.likeIndex = 0;
        }else{
            self.likeIndex = PAGE_INDEX(responseObject);
        }
        
        int i = 0;
        for (NSDictionary * dict in  OBJ(responseObject)) {
            cartoon * model = [cartoon mj_objectWithKeyValues:dict];
            [_LikeModelArr addObject:model];
            UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:model.midelPhoto] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(likeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.headerView.likeScrollViewView addSubview:btn];
            btn.frame = CGRectMake(15 +(btnW+15)*i, 0, btnW, btnH);
            btn.tag = i;
            
            UILabel * label = [[UILabel alloc]init];
            label.text = model.cartoonName;
            label.textAlignment = NSTextAlignmentCenter;
            [self.headerView.likeScrollViewView addSubview:label];
            label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:11.5];
            label.frame = CGRectMake(15+(btnW+15)*i, btnH, btnW, 30);
            i++;
        }
        
        self.headerView.likeScrollViewView.contentSize = CGSizeMake(i*(btnW+15)+15, btnH);
    }];
}
-(void)likeBtnClick:(UIButton *)btn{
    CaricatureDetailViewController * vc = [[CaricatureDetailViewController alloc]init];
    CartoonDetailModel * model = [CartoonDetailModel new];
    model.cartoon = _LikeModelArr[btn.tag];
    vc.cartoonId = model.cartoon.id;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)writeCommentBtnClick{
    if (!self.model) {
        return;
    }
    //__weak typeof(self) weakSelf = self;
    
    [CommentWindow shareWithFinshBlock:^(NSString *text, CommentWindow *window) {
        [self sendComment:text];
    }];
                            
    
}
-(void)sendComment:(NSString *)text{
    [SVProgressHUD show];
    NSDictionary * param = @{@"cartoonId":self.model.cartoon.id,
                             @"commentInfo":text
                             };
    [AfnManager postUserAction:URL_CARTOON_ADD_COMMENT param:param Sucess:^(NSDictionary *responseObject) {
        self.pageIndex = 0;
        self.ModelArr = [NSMutableArray array];
        [self getCommentData];
        [CommentWindow share].textView.text = @"";
    }];
}


#pragma mark- UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.ModelArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentCell *cell = [CommentCell cellWithTableView:tableView  contentViewColor:COLOR_SYSTEM_GARY];
    cell.model = self.ModelArr[indexPath.row];
    cell.PraiseUrl = URL_PRAISE;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    CommentDetailTableViewController * vc = [[CommentDetailTableViewController alloc]initWithStyle:UITableViewStyleGrouped];
    vc.commentType = CommentByCartoon;
    vc.model = [self.ModelArr objectAtIndex:indexPath.row];
    vc.block = ^(commentModel *model) {
        self.ModelArr[indexPath.row] = model;
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    };
    [self.navigationController pushViewController:vc animated:YES];

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //keyPath 为 model 的属性名，
    return [self.tableView cellHeightForIndexPath:indexPath model:self.ModelArr[indexPath.row] keyPath:@"model" cellClass:[CommentCell class] contentViewWidth:SCREEN_WIDTH];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(varicatureHeaderView *)headerView{
    if (_headerView == nil) {
        _headerView = [[varicatureHeaderView alloc]init];
        [_headerView.changeLikeBtn addTarget:self action:@selector(getLikeData) forControlEvents:UIControlEventTouchUpInside];
        [_headerView.writeCommentBtn addTarget:self action:@selector(writeCommentBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _headerView;
}


@end
