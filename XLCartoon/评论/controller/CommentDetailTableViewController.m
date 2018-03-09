//
//  CommentDetailTableViewController.m
//  XLCartoon
//
//  Created by Amitabha on 2017/12/18.
//  Copyright © 2017年 XLCR. All rights reserved.
//

#import "CommentDetailTableViewController.h"
#import "CommentCell.h"
#import "CommentWindow.h"
@interface CommentDetailTableViewController ()
@property (nonatomic,strong) commentModel * sectionOneModel;//去掉二级评论
@property (nonatomic,strong) NSMutableArray <commentModel *>* modelArr;
@property (nonatomic,assign) BOOL superViewControllerNeedReload;
@property (nonatomic,assign) int commentCount;
@end

@implementation CommentDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sectionOneModel = [self.model copy];
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
    
    self.commentCount = self.model.cartoonComment.commentCount;
}
-(void)rightBtnClick{
    CommentWindow * window = [CommentWindow share];
    [window show];
    window.block = ^(NSString *text,CommentWindow * window) {
        [self sendComment:text];
    };
}

-(void)getData{
    [SVProgressHUD show];
    NSDictionary * param = @{@"id":self.model.cartoonComment.id,
                             @"nowPage":[NSString stringWithFormat:@"%ld",self.pageIndex+1]
                             };
    NSString * url = self.commentType == CommentByCartoon ? URL_COMMENT_BY_COMMENT : URL_GET_COMMENT_Episode_SON;
    
    [AfnManager postListDataUrl:url param:param result:^(NSDictionary *responseObject) {
        if (responseObject) {
            if (self.tableView.mj_header.isRefreshing) {
                self.modelArr = [NSMutableArray array];
            }
            for (NSDictionary * dict in OBJ(responseObject)) {
                [_modelArr addObject:[commentModel mj_objectWithKeyValues:dict]];
            }
            [self.tableView reloadData];
            self.pageIndex = PAGE_INDEX(responseObject);
            self.pageToale = PAGE_TOTAL(responseObject);
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_footer resetNoMoreData];
        self.tableView.mj_footer.hidden =NO;
        self.loading = NO;
    }];
}
-(void)sendComment:(NSString *)text{
    [SVProgressHUD show];
    NSDictionary * param = @{@"id":self.model.cartoonComment.id,
                             @"commentInfo":text
                             };
    NSString * url = self.commentType == CommentByCartoon ? URL_COMMENT_ADD_COMMENT : URL_ADD_COMMENT_Episode_COMMENT;
    
    [AfnManager postUserAction:url param:param Sucess:^(NSDictionary *responseObject) {
        self.pageIndex = 0;
        self.modelArr = [NSMutableArray array];
        [self getData];
        [CommentWindow share].textView.text = @"";
        self.commentCount ++;
        self.sectionOneModel.cartoonComment.commentCount ++;
        _superViewControllerNeedReload = YES;
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
    CommentCell *cell = [CommentCell cellWithTableView:tableView contentViewColor:[UIColor whiteColor]];
    cell.praiseBtn.alpha = 0;
    return cell;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        ((CommentCell *)cell).model = self.sectionOneModel;
    }else{
        
        ((CommentCell *)cell).model = self.modelArr[indexPath.row];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    commentModel * model = indexPath.section ? self.modelArr[indexPath.row] :self.sectionOneModel;
    return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[CommentCell class] contentViewWidth:SCREEN_WIDTH];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.01;
    }
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 10;
    }else {
        return 0.01;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==1) {
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (_superViewControllerNeedReload) {
        self.sectionOneModel.list = self.modelArr;
        self.block(self.sectionOneModel);
    }
}



@end
