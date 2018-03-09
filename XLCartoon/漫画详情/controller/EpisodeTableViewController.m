//
//  EpisodeTableViewController.m
//  XLGame
//
//  Created by Amitabha on 2017/12/11.
//  Copyright © 2017年 In.于楚天. All rights reserved.
//

#import "EpisodeTableViewController.h"
#import "EpisodeCell.h"
#import "EpisodeModel.h"

#import "ReadingCartoonTVC1.h"

@interface EpisodeTableViewController ()
@property (nonatomic,strong) NSMutableArray <EpisodeModel *> * modelArr;
@property (nonatomic,assign) BOOL mode;//正倒序

@end

@implementation EpisodeTableViewController

- (instancetype)init;
{
    self = [super init];
    if (self) {
        self.title = @"选集";
        self.modelArr = [NSMutableArray array];
        _mode = NO;
    }
    return self;
}

-(void)dealloc{
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self getData];
    [SVProgressHUD show];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if (self.pageIndex == self.pageToale) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [self getData];
        }
    }];
    
    [self addTableHeader];
                     
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //相当于吧这个view 加到其他controller上   这个controller 的生命周期被破坏了
   
}

-(void)addTableHeader{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,30)];
    UILabel * label = [UILabel new];
    if (self.model.cartoon.serialState) {
        label.text = [NSString stringWithFormat:@"连载中（更新至%@）",self.model.cartoon.updateTile];
    }else{
        label.text = @"已完结";
    }
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = RGB(88, 88, 88);
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(reloadTabelDataBtnClick:) forControlEvents:UIControlEventTouchUpInside];

    UIImageView * img = [[UIImageView alloc]init];
//    img.backgroundColor = [UIColor redColor];
    [btn addSubview:img];
    img.sd_layout.rightSpaceToView(btn, 10).centerYEqualToView(btn).heightIs(16).widthIs(16);
    img.tag = 2;
    img.image = [UIImage imageNamed:@"倒叙"];
    img.highlightedImage = [UIImage imageNamed:@"正序"];
    
    UILabel * lb = [UILabel new];
    lb.tag = 1;
    [btn addSubview:lb];
    lb.text = @"倒叙";
    lb.font = [UIFont systemFontOfSize:15];
    lb.textColor = RGB(88, 88, 88);
    lb.textAlignment = NSTextAlignmentRight;
    lb.sd_layout.bottomEqualToView(btn).topEqualToView(btn).rightSpaceToView(img, 3);
    [lb setSingleLineAutoResizeWithMaxWidth:100];
    
    
    [view sd_addSubviews:@[label,btn]];
    
    label.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 15, 0, 80));
    btn.sd_layout.leftSpaceToView(label, 0).topEqualToView(view)
    .rightEqualToView(view).bottomEqualToView(view);
    self.tableView.tableHeaderView = view;
}
-(void)reloadTabelDataBtnClick:(UIButton *)btn{
    if (self.modelArr) {
        UILabel * label = [btn viewWithTag:1];
        UIImageView * imageView = [btn viewWithTag:2];
        self.mode = !self.mode;
        imageView.highlighted = self.mode;
        label.text = self.mode ? @"正序" : @"倒叙";
        self.modelArr = [NSMutableArray array];
        self.pageIndex = 0;
        [SVProgressHUD showWithStatus: [NSString stringWithFormat:@"切换至%@",self.mode ?  @"倒叙":@"正序" ]];
        [self getData];
    }
    
}
-(void)getData{

    NSDictionary * param =@{@"Id":self.model.cartoon.id,
                            @"nowPage":[NSString stringWithFormat:@"%ld",self.pageIndex+1],
                            @"mode":[NSString stringWithFormat:@"%d",self.mode]  //0正叙，1 倒叙
                            };
    
    [AfnManager postListDataUrl:URL_EPISODE_CARTOON param:param result:^(NSDictionary *responseObject) {
        if (responseObject) {
            for (NSDictionary * dict in OBJ(responseObject)) {
                [_modelArr addObject:[EpisodeModel mj_objectWithKeyValues:dict]];
            }
            [self.tableView reloadData];
            self.pageIndex = PAGE_INDEX(responseObject);
            self.pageToale = PAGE_TOTAL(responseObject);
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        self.tableView.mj_footer.hidden =NO;
        self.loading = NO;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

#pragma mark- UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modelArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
 
    EpisodeCell *cell = [EpisodeCell cellWithTableView:tableView];
    //// 此步设置用于实现cell的frame缓存，可以让tableview滑动更加流畅 //////
    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    cell.model = self.modelArr[indexPath.row];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    ReadingCartoonTVC1 * vc = [[ReadingCartoonTVC1 alloc]init];
    vc.episodeIndex = indexPath.row;
    vc.episodes = self.modelArr;
    
    vc.cartoonModel = self.model;
    [self.navigationController pushViewController:vc animated:YES];
    vc.popBlcok = ^(NSArray *cartoonIds) {
            [self.tableView reloadData];
    };

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [EpisodeCell cellHeight];
}
@end
