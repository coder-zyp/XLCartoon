//
//  HomeFindTableViewController.m
//  XLCartoon
//
//  Created by Amitabha on 2018/1/20.
//  Copyright © 2018年 XLCR. All rights reserved.
//


#import "HomeFindTableViewController.h"
#import "TopCell.h"
#import "CaricatureDetailViewController.h"
#import "FSCustomButton.h"
#import <UIButton+WebCache.h>
#import "TypePageController.h"
#import "HomeFindTableViewController.h"
#import "TopTableViewController.h"

@interface HomeFindTableViewController ()

@property (nonatomic,strong) NSMutableArray <UIButton *>* hotBtnArr;
@property (nonatomic,strong) NSMutableArray <UILabel *>* hotLabelArr;

@property (nonatomic,strong) NSMutableArray <cartoon *> * hotModelArr;
@property (nonatomic,strong) NSMutableArray <cartoon * >* followModelArr;
@property (nonatomic,strong) NSMutableArray <cartoon * >* playModelArr;
@property (nonatomic,getter=isHaveData) BOOL  haveData;
@property (nonatomic,strong) UIView * headerView;


@end

@implementation HomeFindTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _hotLabelArr = [NSMutableArray array];
    _hotBtnArr = [NSMutableArray array];
    _hotModelArr= [NSMutableArray array];
    
    _followModelArr = [NSMutableArray array];
    _playModelArr = [NSMutableArray array];
    
    [self headerView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.mj_header = [MJGifHeader headerWithRefreshingBlock:^{
        self.pageIndex = 0;
        [self getData];
    }];
    
    [self getData];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TopCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"TopCell"];
}
-(void)getData{
    [super getData];

    [self getHotData];
    [self getDataWithUrl:URL_CARTOON_TOP withModelArr:self.playModelArr];
    [self getDataWithUrl:URL_CARTOON_TOP_BY_FOLLOW withModelArr:self.followModelArr];
}
-(void)getDataWithUrl:(NSString *)url withModelArr:( NSMutableArray *)modelArr{
    
    [AfnManager postListDataUrl:url param:nil result:^(NSDictionary *responseObject) {
        if (responseObject) {
            
            [modelArr removeAllObjects];
            int i = 0;
            for (NSDictionary * dict in OBJ(responseObject)) {
                [modelArr addObject:[cartoon mj_objectWithKeyValues:dict]];
                if (i==4) break;
                i++;
            }
            if (self.isHaveData){
                [self.tableView reloadData];
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
        [self.tableView.mj_header endRefreshing];
        self.loading = NO;
    }];
}
-(BOOL)isHaveData{
    if (self.playModelArr.count && self.followModelArr.count) {
        return YES;
    }
    return NO;
}

-(void)getHotData{
    
    [AfnManager postWithUrl:URL_HOT_CARTOON param:nil Sucess:^(NSDictionary *responseObject) {
        int i =0;
        for (NSDictionary * dict in OBJ(responseObject)) {
            cartoon * model =[cartoon mj_objectWithKeyValues:dict];
            [_hotModelArr addObject: model];
            [_hotBtnArr[i] sd_setImageWithURL:[NSURL URLWithString:model.midelPhoto] forState:UIControlStateNormal];
            _hotLabelArr[i].text = model.cartoonName;
            i++;
            if (i==3)break;
            if (self.tableView.tableHeaderView == nil) {
                self.tableView.tableHeaderView = self.headerView;
            }
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark- Clicked

-(void)hotBtnClick:(UIButton *)btn{
    CaricatureDetailViewController * vc = [[CaricatureDetailViewController alloc]init];
    CartoonDetailModel * model = [CartoonDetailModel new];
    model.cartoon = _hotModelArr[btn.tag];
    vc.cartoonId = model.cartoon.id;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

-(UIView *)headerView{
    if (!_headerView) {
        _headerView = [UIView new];
        
        CGFloat BtnW = (SCREEN_WIDTH - 15*4)/3.0;
        CGFloat BtnH = BtnW * 153.0/105.0;
        
            
        UIImageView * hotIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hotIcon"]];
        [_headerView addSubview:hotIcon];
        hotIcon.frame = CGRectMake(15, (40-18.5)/2.0, 18.5, 18.5);
        
        UILabel *label = [[UILabel alloc] init];
        label.text = @"热门漫画";
        label.font = Font_Medium(15);// [UIFont boldSystemFontOfSize:15];
        label.frame = CGRectMake(15+19+4, 0, 200, 40);
        [_headerView addSubview:label];
        
        FSCustomButton * moreBtn = [FSCustomButton new];
        [moreBtn setTitle:@"所有分类" forState:UIControlStateNormal];
        [moreBtn setImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal];
        [moreBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        moreBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15.2];
        moreBtn.buttonImagePosition = FSCustomButtonImagePositionRight;
        [moreBtn addTarget:self action:@selector(MoreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        moreBtn.tag = 2;
        [moreBtn sizeToFit];
        [_headerView addSubview:moreBtn];
        moreBtn.sd_layout.widthIs(75).rightSpaceToView(_headerView, 15)
        .heightIs(40).centerYEqualToView(hotIcon);
        
        for (int i = 0; i<3; i++) {
            UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(15+(BtnW+15)*i, CGRectGetMaxY(label.frame), BtnW, BtnH);
            btn.layer.cornerRadius = 10;
            btn.tag = i;
            btn.layer.masksToBounds = YES;
            btn.layer.cornerRadius = 3;
            [_headerView addSubview:btn];
            [btn addTarget:self action:@selector(hotBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            
            UILabel * label = [UILabel new];
            label.font = [UIFont fontWithName:@"PingFangSC-Medium" size:13];
            [_headerView addSubview:label];
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = rgba(0, 0, 0, 0.8);
            label.frame = CGRectMake(15+(BtnW+15)*i, CGRectGetMaxY(btn.frame)+4, BtnW, 20);
            
            [_hotBtnArr addObject:btn];
            [_hotLabelArr addObject:label];
        }
        UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, BtnH+40+30+5, SCREEN_WIDTH, 10)];
        line.backgroundColor = rgba(223, 223, 223, 1);
        [_headerView addSubview:line];
        
        _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH,CGRectGetMaxY(line.frame)+5);
        
    }
    return _headerView;
}
#pragma mark - Table view data source
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    UILabel * topLabel = [[UILabel alloc] init];
    topLabel.text = section ?  @"人气榜":@"关注榜" ;
    topLabel.font = Font_Medium(15) ;
    topLabel.textColor = [UIColor colorWithRed:0/255 green:0/255 blue:0/255 alpha:1];
    topLabel.frame = CGRectMake(15+19+5, 0, 200, 30);
    [view addSubview:topLabel];
    
    UIImageView * topIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"排行榜"]];
    [view addSubview:topIcon];
    topIcon.frame = CGRectMake(15, 5, 20, 20);
    
    FSCustomButton * moreBtn = [FSCustomButton new];
    [moreBtn setTitle:@"查看更多" forState:UIControlStateNormal];
    [moreBtn setImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal];
    [moreBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    moreBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15.2];
    moreBtn.buttonImagePosition = FSCustomButtonImagePositionRight;
    [moreBtn addTarget:self action:@selector(MoreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    moreBtn.tag = section;
    [moreBtn sizeToFit];
    [_headerView addSubview:moreBtn];
    moreBtn.sd_layout.widthIs(75).rightSpaceToView(view, 15)
    .heightIs(40).centerYEqualToView(view);
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.isHaveData) {
        return 2;
    }else{
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.followModelArr.count;
    }else{
        return self.playModelArr.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TopCell" forIndexPath:indexPath];
    return  cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SCREEN_WIDTH/3.7;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    TopCell * topCell = (TopCell *)cell;
    CartoonDetailModel * model = [CartoonDetailModel new];
    model.cartoon = indexPath.section ? self.playModelArr[indexPath.row] : self.followModelArr[indexPath.row];
    topCell.model = model;
    topCell.TopNumLabel.text = [NSString stringWithFormat:@"%02ld",indexPath.row+1];
    NSArray * colorArr = @[RGB(253, 111, 55),RGB(253, 156, 43),rgba(250, 210, 60, 1)];
    UIColor * color = indexPath.row <3? colorArr[indexPath.row] : RGB(174, 213, 244);
//    topCell.contentView.backgroundColor = color;
    topCell.backgroundColor = color;
    topCell.lineView.backgroundColor =color;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    CaricatureDetailViewController * vc = [[CaricatureDetailViewController alloc]init];
    vc.cartoonId = indexPath.section ? self.playModelArr[indexPath.row].id: self.followModelArr[indexPath.row].id;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


@end
