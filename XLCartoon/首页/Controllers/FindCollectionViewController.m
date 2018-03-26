//
//  FindCollectionViewController.m
//  XLCartoon
//
//  Created by Amitabha on 2018/2/24.
//  Copyright © 2018年 XLCR. All rights reserved.
//

#import "FindCollectionViewController.h"
#import "TypeCollectionCell.h"
#import "CartoonInfoModel.h"
#import "CaricatureDetailViewController.h"
#import "MJGifHeader.h"
#import <SDCycleScrollView.h>
#import "FindHeaderView.h"
#import "TopTableViewController.h"
#import "TypePageController.h"
#import <UIButton+WebCache.h>
#import "BannerModel.h"
#import "TaskTableViewController.h"
#import "NewCartoonCollectionViewController.h"
#import "TypePageController.h"

@interface FindCollectionViewController ()<SDCycleScrollViewDelegate,UICollectionViewDelegateFlowLayout,SDCycleScrollViewDelegate>

@property (nonatomic,strong) NSMutableArray <NSMutableArray <CartoonDetailModel * > *>* modersArr;
@property (nonatomic,strong) NSMutableArray <BannerModel *>* bannerModelArr;
@property (nonatomic,strong) NSArray <NSString *>* urls;
@property (nonatomic, strong)UIView * headerView;
@property (nonatomic, strong)SDCycleScrollView * bannerScrollView;

@property (nonatomic,getter=isHaveData) BOOL  haveData;
@end

@implementation FindCollectionViewController

static NSString * const reuseIdentifier = @"TypeCollectionCell";
static NSString * const reuseIdentifierSectionOne = @"reuseIdentifierSectionOne";
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        layout.minimumInteritemSpacing = 2;
        layout.minimumLineSpacing = 5;
        
        self.urls =  @[URL_HOT_CARTOON,URL_CARTOON_TOP,URL_CARTOON_TOP_BY_FOLLOW];
        self.bannerModelArr = [NSMutableArray array];
        return [self initWithCollectionViewLayout:layout];
    }
    return self;
}
-(NSMutableArray<NSMutableArray<CartoonDetailModel *> *> *)modersArr{
    if (_modersArr == nil) {
        _modersArr = [NSMutableArray array];
        for (int i =0 ; i<4; i++) {
            [_modersArr addObject:[NSMutableArray array]];
        }
    }
    return _modersArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self getData];
    self.collectionView.emptyDataSetSource = self;
    self.collectionView.emptyDataSetDelegate = self;
    self.collectionView.backgroundColor = COLOR_SYSTEM_GARY;
    
    self.collectionView.mj_header = [MJGifHeader headerWithRefreshingBlock:^{
        self.pageIndex = 0;
        [self getData];
    }];
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier: reuseIdentifierSectionOne];
    
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FindFooterView"];
    
    UINib * nib = [UINib nibWithNibName:reuseIdentifier bundle:[NSBundle mainBundle]];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:reuseIdentifier];
    
    nib =  [UINib nibWithNibName:@"FindHeaderView" bundle:[NSBundle mainBundle]];
    [self.collectionView registerNib:nib forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"FindHeaderView"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    
    NSString *text  = @"暂无数据";
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];
    return attStr;
}

-(void)getData{
    [super getData];
    [self getBannerDate];
    int i = 1;
    for (NSString * url in self.urls) {
        [self getDataWithUrl:url withSection:i];
        i++;
    }

}
-(void)getDataWithUrl:(NSString *)url withSection:(NSInteger)section{
    
    [AfnManager postListDataUrl:url param:nil result:^(NSDictionary *responseObject) {
        if (responseObject) {
            
            [self.modersArr[section] removeAllObjects];
            int i = 0;
            for (NSDictionary * dict in OBJ(responseObject)) {
                cartoon * model  = [cartoon mj_objectWithKeyValues:dict];
                CartoonDetailModel * detailModel = [CartoonDetailModel new];
                detailModel.cartoon = model;
                [_modersArr[section] addObject:detailModel];
                if (i==5) break;
                i++;
            }
            [self.collectionView reloadData];
        }
        [self.collectionView.mj_header endRefreshing];
    }];
}

-(void)setupCustomCell:(UICollectionViewCell *)cell forIndex:(NSInteger)index cycleScrollView:(SDCycleScrollView *)view{
    NSLog(@"%@,%@",view,cell);
}
-(UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, (SCREEN_WIDTH-71)/3.0*1.24+30)];
    view.backgroundColor = kRandomColor;
    NSLog(@"%@",view);
    return view;
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    
    return 4;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section) {
        return _modersArr[section].count;
    }
    return 1;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return CGSizeMake(SCREEN_WIDTH, self.headerView.height);
    }else{
        CGFloat w = (SCREEN_WIDTH-4)/3.0;
        CGFloat h = w*1.34 + 30;
        return  CGSizeMake( w,h);
    }
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section) {
        TypeCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
        cell.ImageView.layer.cornerRadius = 0;
        // Configure the cell
        cell.model = self.modersArr[indexPath.section][indexPath.row];
        return cell;
    }else{
        UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierSectionOne forIndexPath:indexPath];
        [cell.contentView addSubview:self.headerView];
        return cell;
    }
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section) {
        CaricatureDetailViewController * vc = [[CaricatureDetailViewController alloc]init];
        vc.cartoonId = self.modersArr[indexPath.section][indexPath.row].cartoon.id;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        
    }
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGFloat h = 50;
    if (section == 0 || _modersArr[section].count<1 ) {//
        h = 0;
    }
    return CGSizeMake(SCREEN_WIDTH,h);
    
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    
    CGFloat h = 10;
    switch (section) {
        case 0: case 3:
            h = 0;
            break;
        default:
            break;
    }
    return CGSizeMake(SCREEN_WIDTH,h);
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    if (kind == UICollectionElementKindSectionHeader) {
        if (indexPath.section == 0) {
            return [UICollectionReusableView new];
        }
        static NSString *CellIdentifier = @"FindHeaderView";
        FindHeaderView * view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:CellIdentifier forIndexPath:indexPath];
        //从缓存中获取 Headercell
        NSArray * names = @[@"",@"主编推荐",@"热门排行",@"关注排行"];
        view.nameLabel.text = names[indexPath.section];
        
        view.nameLabel.text = names[indexPath.section];
        view.moreBtn.tag = indexPath.section;
        [view.moreBtn addTarget:self action:@selector(MoreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        return view;
    }else{
        UICollectionReusableView * view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FindFooterView" forIndexPath:indexPath];
        view.backgroundColor =  COLOR_LIGHT_GARY;
        return view;
        
    }
    
}
- (SDCycleScrollView *)bannerScrollView{
    
    if (!_bannerScrollView) {
        
        _bannerScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0,SCREEN_WIDTH, SCREEN_WIDTH*0.4) delegate:self placeholderImage:Z_PlaceholderImg];
        _bannerScrollView.currentPageDotColor = COLOR_NAVI;
        _bannerScrollView.autoScrollTimeInterval = 5;
        _bannerScrollView.backgroundColor = [UIColor whiteColor];
    }
    return _bannerScrollView;
}
#pragma mark- geter seter
-(UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH, CGRectGetMaxY(self.bannerScrollView.frame)+100)];
        
        [_headerView addSubview:self.bannerScrollView];
        
        //        NSString * 🔥 = @"🔥"
        UIView *btnView = [[UIView alloc] init];
        //        btnView.backgroundColor = [UIColor whiteColor];
        [_headerView addSubview:btnView];
        btnView.frame = CGRectMake(0, self.bannerScrollView.height+10, SCREEN_WIDTH, 100);
        
        NSArray * titles = @[@"人气",@"最新",@"任务",@"分类"];
        for ( int i =0; i<4; i++) {
            UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setImage:[UIImage imageNamed:titles[i]] forState:UIControlStateNormal];
            btn.frame = CGRectMake(SCREEN_WIDTH/4*i, 0, SCREEN_WIDTH/4, 90);
            [btnView addSubview:btn];
            btn.tag = i;
            [btn addTarget:self action:@selector(headerBtnsClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        
    }
    return _headerView;
}
- (void)getBannerDate{
    
    [AfnManager postWithUrl:URL_GETBANNER param:nil Sucess:^(NSDictionary *responseObject) {
        NSMutableArray * URLArr = [NSMutableArray array];
        self.bannerModelArr = [NSMutableArray array];
        for (NSDictionary * dict in OBJ(responseObject)) {
            BannerModel * model =[BannerModel mj_objectWithKeyValues:dict];
            [_bannerModelArr addObject:model];
            [URLArr addObject:model.httpImg];
        }
        [self.bannerScrollView setImageURLStringsGroup:URLArr];
    }];
}
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    CaricatureDetailViewController * vc =[CaricatureDetailViewController new];
    CartoonDetailModel * model= [CartoonDetailModel new];
    model.cartoon = [cartoon new];
    model.cartoon.id =_bannerModelArr[index].cartoonId;
    vc.cartoonId= model.cartoon.id;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)MoreBtnClick:(UIButton *)btn{
    NSArray * names = @[@"",@"主编推荐",@"热门排行",@"关注排行"];
    UIViewController *vc = [[TopTableViewController alloc]initWithUrl:_urls[btn.tag-1]];
    vc.title = names[btn.tag];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark- action
-(void)headerBtnsClick:(UIButton *)btn{
    UIViewController * vc;
    switch (btn.tag) {
        case 0:
            vc=[[TopTableViewController alloc]initWithUrl:_urls[1]];
            vc.title = @"人气榜";
            break;
        case 1:
            vc=[[NewCartoonCollectionViewController alloc]init];
            vc.title = @"最近更新";
            break;
        case 2:
            vc=[[TaskTableViewController alloc]init];
            break;
        case 3:
            vc = [TypePageController new];
            break;
        default:
            vc = [UIViewController new];
            break;
    }
    [self.navigationController pushViewController:vc animated:YES];
}
@end

