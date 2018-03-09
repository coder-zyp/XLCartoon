//
//  MeViewController.m
//  XLGame
//
//  Created by yuchutian on 2017/9/28.
//  Copyright © 2017年 In.于楚天. All rights reserved.
//

#import "MeViewController.h"
//#import "UIFont+runtime.h"
#import "PayVIPTableViewController.h"
#import "UIImageView+WebCache.h"
#import "LoginViewController.h"
#import "PayCollectionViewController.h"

#import "PayVIPTableViewController.h"
#import "TaskTableViewController.h"
#import "FeedBackViewController.h"
#import "ClearCacheTableViewCell.h"
#import "FriendCircleViewController.h"
#import "UserInfoViewController.h"
#import "shareWindow.h"
#import "MyMessageTableViewController.h"
#import "UserInfoCell.h"
#import "AboutUsViewController.h"

@interface MeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSArray <NSArray <NSString *>* >* cellTextArr;
@property (nonatomic,strong) NSArray <NSArray <NSString *>* >* cellDetailTextArr;
@property (nonatomic,strong) UILabel * LoginLabel;
@property (nonatomic,strong) UITableView * tableView;
@end

@implementation MeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title= @"我的";
    [self setupUI];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"share"] style:UIBarButtonItemStyleDone target:self action:@selector(shareBtnClick)];

}
-(void)shareBtnClick{
    [shareWindow shareWithModel:nil cartoonSetId:nil];
}
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    USER_MODEL = nil;
    [APP_DELEGATE userModel];
    self.cellTextArr = nil;
    self.cellDetailTextArr = nil;
    NSLog(@"%@",USER_MODEL);
    [self.tableView reloadData];
}

-(void)setupUI {
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.cellTextArr[section].count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.00001;
    }else {
        return 8;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.00001;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.cellTextArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.section == 0  && USER_INFO) {
        return [UserInfoCell cellWithTableView:tableView];
    }else{
        static NSString * tableViewID = @"UserCenterTableViewController";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:tableViewID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:tableViewID];
            
            cell.textLabel.text = @" ";
            cell.detailTextLabel.text = @" ";
            cell.detailTextLabel.textColor = rgba(204,204,204,1);
            cell.textLabel.font = [UIFont systemFontOfSize: 17];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
            cell.textLabel.backgroundColor = [UIColor clearColor];
            if (indexPath.section == 4) {
                if (indexPath.row == 2) {
                    cell = [[ClearCacheTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"ClearCacheTableViewCell"];
                }
            }
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIViewController * vc;

    if (indexPath.section==0) {
        if (USER_MODEL) {
            vc = [[UserInfoViewController alloc]initWithStyle:UITableViewStyleGrouped];
        }else{
            vc = [[LoginViewController alloc] init];
        }
    }else if (indexPath.section == 1){
        vc = [PayVIPTableViewController new];
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            vc = [PayCollectionViewController new];
        }else{
            vc = [[TaskTableViewController alloc] init];
        }
    }else if (indexPath.section == 3){
        if (indexPath.row == 0) {
            FriendCircleViewController * viewController = [[FriendCircleViewController alloc]init];
            viewController.isMyFriend = YES;
            vc= viewController;
        }else{
            vc = [[MyMessageTableViewController alloc]init];
        }
    }else if (indexPath.section == 4){
        if (indexPath.row == 0) {
            vc = [[FeedBackViewController alloc] init];
        }else if (indexPath.row == 1){
            vc = [[AboutUsViewController alloc] init];
        }
    }
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([cell isKindOfClass:[UserInfoCell class]] ) {
        ((UserInfoCell * )cell).model = USER_MODEL;
    }else{
        cell.textLabel.text = self.cellTextArr[indexPath.section][indexPath.row];
        cell.imageView.image = [UIImage imageNamed:_cellTextArr[indexPath.section][indexPath.row]];
        cell.detailTextLabel.text = self.cellDetailTextArr[indexPath.section][indexPath.row];
    }
}
-(NSArray<NSArray<NSString *> *> *)cellTextArr{
    
    if (_cellTextArr == nil) {
        _cellTextArr = @[@[@"\t   点击登录"],
                         @[@"vip特权"],
                         @[@"充值",@"任务中心"],
                         @[@"我的混圈",@"我的消息"],
                         @[@"意见反馈",@"关于我们",@"清除缓存"]];
    }
    return _cellTextArr;
}
-(NSArray<NSArray<NSString *> *> *)cellDetailTextArr{
    
    if (_cellDetailTextArr == nil) {
        NSString * vipDate = USER_MODEL.vipId ? [NSString stringWithFormat: @"%@到期",USER_MODEL.endDate] : @"观看漫画，优惠折扣";
        
        _cellDetailTextArr = @[@[@""],
                         @[vipDate],
                         @[@"去充值",@"做任务领咔咔豆"],
                         @[@"",@""],
                         @[@"",@"",@""]];
    }
    return _cellDetailTextArr;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 80;
    }else{
        return 50;
    }
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
