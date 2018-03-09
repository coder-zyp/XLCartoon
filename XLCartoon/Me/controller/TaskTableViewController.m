//
//  TaskTableViewController.m
//  XLCartoon
//
//  Created by Amitabha on 2017/12/19.
//  Copyright © 2017年 XLCR. All rights reserved.
//

#import "TaskTableViewController.h"
#import "TaskCell.h"
#import "TaskModel.h"
#import "TypePageController.h"
#import "PayVIPTableViewController.h"
#import "registerViewController.h"
#import "PayCollectionViewController.h"

@interface TaskTableViewController ()
@property (nonatomic,strong) UIView * headerView;
@property (nonatomic,strong) UIView * BtnSuperView;
@property (nonatomic,strong) NSMutableArray <TaskModel *> * modelArr;
@property (nonatomic,strong) TaskModel * signModel;
@property (nonatomic,strong) UIButton * signBtn;

@end

@implementation TaskTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"任务中心";

    self.tableView.tableHeaderView = self.headerView;
    
    self.tableView.mj_header = [MJGifHeader headerWithRefreshingBlock:^{
        [self getData];
    }];
    [self getData];
    
    
}


- (instancetype)initWithPresent
{
    self = [super init];
    if (self) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"CLOSE"] style:UIBarButtonItemStyleDone target:self action:@selector(dismiss)];
    }
    return self;
}
-(void)dismiss{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [APP_DELEGATE getUserInfo];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getData{
    [super getData];
    [SVProgressHUD show];

    [AfnManager postListDataUrl:URL_MY_TASK param:nil result:^(NSDictionary *responseObject) {
        if (responseObject) {
            _modelArr = [NSMutableArray array];
            int i = 0;
            for (NSDictionary * dict in OBJ(responseObject)) {
                if (i==0){
                    self.signModel = [TaskModel mj_objectWithKeyValues:dict];
                    if (self.signModel.userTask.buttonState ==0 && self.signModel.userTask.taskState == 7) {
                        self.signModel.userTask.buttonState = 0;
                        [self updateSignState:@"1"];
                    }else{
                        [self updateSignState:nil];
                    }
                }else{
                    [self.modelArr addObject:[TaskModel mj_objectWithKeyValues:dict]];
                }
                i++;
            }
            [self.tableView reloadData];
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        self.loading = NO;
    }];
}
-(void)updateSignState:(NSString * )signFinsh{
    
    _signBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    _signBtn.size = CGSizeMake(50, 20);
    [_signBtn addTarget:self action:@selector(signBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _signBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    _signBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    
    [_signBtn setTitle:@"签到" forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_signBtn];
    
    for (UIView * item in _BtnSuperView.subviews) {
        if ((item.tag-1000)%7 < self.signModel.userTask.taskState) {
            if ([item isKindOfClass:[UIButton class]]) {
                UIButton * btn = (UIButton *)item;
                btn.backgroundColor = COLOR_NAVI;
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }else if ([item isKindOfClass:[UILabel class]]) {
                UILabel * label = (UILabel *)item;
                label.textColor = COLOR_NAVI;
            }
        }else{
            if ([item isKindOfClass:[UIButton class]]) {
                UIButton * btn = (UIButton *)item;
                btn.backgroundColor = COLOR_SYSTEM_GARY;
                [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            }else if ([item isKindOfClass:[UILabel class]]) {
                UILabel * label = (UILabel *)item;
                label.textColor = [UIColor blackColor];
            }
        }
    }
    if (signFinsh == nil && self.signModel.userTask.taskState<7) {
        UIButton * btn = [_BtnSuperView viewWithTag:self.signModel.userTask.taskState+1000];
        [btn addTarget:self action:@selector(signBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    if (signFinsh) {
        self.signModel.userTask.taskState--;
        NSString * object = @"1";
        if (self.signModel.userTask.taskState == 0){
            object = nil;
        }
        [self performSelector:@selector(updateSignState:) withObject:object afterDelay:0.15];

    }
    if (_signModel.userTask.buttonState) {
        [_signBtn setTitle:@"已签到" forState:UIControlStateNormal];
        _signBtn.enabled = NO;
    }
}

-(void)signBtnClick:(UIButton *)btn{


    [AfnManager postUserAction:URL_SIGN param:@{@"id": _signModel.userTask.id} Sucess:^(NSDictionary *responseObject) {
        [APP_DELEGATE getUserInfo];
        [self getData];
//        self.signModel.userTask.taskState ++;
//        _signModel.userTask.buttonState = 1;
//        [self updateSignState:nil];
        
    }];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modelArr.count;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_modelArr[indexPath.row].userTask.buttonState == 0) {

        switch (_modelArr[indexPath.row].cartoonTask.id) {
            case 3://每日平台
            {
                [shareWindow shareWithModel:nil cartoonSetId:nil sucess:^{
                    [self.tableView.mj_header beginRefreshing];
                }];
                break;
            }
            case 4:
            case 5://分享观看漫画
                [self.navigationController pushViewController:[TypePageController new] animated:YES];
                break;
            case 6://充值
                [self.navigationController pushViewController:[PayCollectionViewController new] animated:YES];
                break;
            case 7:
            {
                registerViewController * vc =[registerViewController new] ;
                vc.viewtype = viewTypeAddPhone;
                [self.navigationController pushViewController:vc animated:YES];
                break;
            }
            default:
                break;
        }
        
    }else if (_modelArr[indexPath.row].userTask.buttonState == 1) {
        [SVProgressHUD show];
        NSDictionary * param = @{@"id":_modelArr[indexPath.row].userTask.id};
        
        [AfnManager postUserAction:URL_MY_TASK_FINISH param:param Sucess:^(NSDictionary *responseObject) {
            _modelArr[indexPath.row].userTask.buttonState = 2;
            [APP_DELEGATE getUserInfo];
            [self.tableView reloadData];
            [SVProgressHUD showSuccessWithStatus:Msg(responseObject)];
        }];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TaskCell * cell = [TaskCell cellWithTableView:tableView];
    cell.contentView.backgroundColor = (indexPath.row%2 == 0) ? [UIColor whiteColor] : rgba(240,239,245,1);
    cell.model = _modelArr[indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [TaskCell cellHeight];
}
-(UIView *)headerView{
    if (!_headerView) {
        _headerView = [UIView new];
        _headerView.backgroundColor = [UIColor whiteColor];
        
        UIImageView * imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"taskheader"]];
        [_headerView addSubview:imageView];
        imageView.sd_layout.xIs(0).yIs(0).widthIs(SCREEN_WIDTH).autoHeightRatio(117.0/375.0);
        
        _BtnSuperView = [UIView new];
        [_headerView addSubview:_BtnSuperView];
        _BtnSuperView.sd_layout.topSpaceToView(imageView, 0).xIs(0).widthIs(SCREEN_WIDTH);

        CGFloat space = 8;
        NSArray * arr = @[@"签",@"满",@"7",@"天",@"就",@"送",@"VIP"];
        for (int i = 1000;i<1014;i++) {
            if (i<7+1000) {
                UIButton * btn =[UIButton buttonWithType:UIButtonTypeCustom];
                btn.backgroundColor = COLOR_SYSTEM_GARY;
                [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                [_BtnSuperView addSubview:btn];
                [btn setTitle:arr[i-1000] forState:UIControlStateNormal];
                btn.sd_layout.autoHeightRatio(1);
                btn.layer.cornerRadius = (SCREEN_WIDTH-space*8)/7.0/2.0;
                btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:22];
                btn.tag = i;

            }else{
                UILabel * label =[[UILabel alloc]init];
                label.tag = i;
                label.text = [NSString stringWithFormat: @"%d天",i-6-1000];
                label.font =  [UIFont systemFontOfSize:11];
                label.textAlignment = NSTextAlignmentCenter;
                [_BtnSuperView addSubview:label];
                label.sd_layout.autoHeightRatio(0);
            }
        }
        [_BtnSuperView setupAutoWidthFlowItems:_BtnSuperView.subviews withPerRowItemsCount:7 verticalMargin:2 horizontalMargin:space verticalEdgeInset:15 horizontalEdgeInset:space];
        
        UIView * line =[UIView new];
        [_headerView addSubview:line];
        line.backgroundColor = COLOR_SYSTEM_GARY;
        line.sd_layout.topSpaceToView(_BtnSuperView, 0).xIs(0).widthIs(SCREEN_WIDTH).heightIs(10);
        
        [_headerView setupAutoHeightWithBottomView:line bottomMargin:0];
        [_headerView layoutSubviews];
    }
    return _headerView;
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
