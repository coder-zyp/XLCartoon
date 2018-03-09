//
//  TypeCollectionViewController.m
//  XLCartoon
//
//  Created by Amitabha on 2018/1/13.
//  Copyright © 2018年 XLCR. All rights reserved.
//

#import "TypeCollectionViewController.h"
#import "TypeCollectionCell.h"
#import "CartoonInfoModel.h"
#import "CaricatureDetailViewController.h"
#import "MJGifHeader.h"
@interface TypeCollectionViewController ()

@end

@implementation TypeCollectionViewController
static NSString * const reuseIdentifier = @"TypeCollectionCell";
- (instancetype)init
{
    self = [super init];
    if (self) {
        CGFloat w = (SCREEN_WIDTH-41)/3.0;
        CGFloat h = w*1.34 + 30;
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake( w,h);
        
        layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
        layout.minimumInteritemSpacing = 10;
        layout.minimumLineSpacing = 10;
        return [self initWithCollectionViewLayout:layout];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _pageIndex = 0 ;
    _pageToale = 0;
    _modelArr = [NSMutableArray array];
    [self getData];
    self.collectionView.emptyDataSetSource = self;
    self.collectionView.emptyDataSetDelegate = self;
    self.collectionView.backgroundColor = COLOR_SYSTEM_GARY;


    self.collectionView.mj_header = [MJGifHeader headerWithRefreshingBlock:^{
        self.pageIndex = 0;
        [self getData];
    }];
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if (self.pageIndex == self.pageToale) {
            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [self getData];
        }
    }];
    [self.collectionView registerClass:[TypeCollectionCell class] forCellWithReuseIdentifier:reuseIdentifier];
    UINib * nib = [UINib nibWithNibName:reuseIdentifier bundle:[NSBundle mainBundle]];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:reuseIdentifier];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //    [self.collectionView reloadData];
}
- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    
    NSString *text  = @"该分类暂无漫画";
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];
    return attStr;
}
-(void)getData{
    
    NSDictionary * param = @{@"nowPage":[NSString stringWithFormat:@"%d",self.pageIndex+1],
                             @"cartoonType":self.typeId
                             };
    [AfnManager postListDataUrl:URL_CARTOON_LIST_BY_TYPE param:param result:^(NSDictionary *responseObject) {
        if (responseObject) {
            if (self.collectionView.mj_header.isRefreshing) {
                self.modelArr = [NSMutableArray array];
                [self.collectionView.mj_footer resetNoMoreData];
            }
            for (NSDictionary * dict in OBJ(responseObject)) {
                [_modelArr addObject:[CartoonDetailModel mj_objectWithKeyValues:dict]];
                
            }
            self.pageIndex = PAGE_INDEX(responseObject);
            self.pageToale = PAGE_TOTAL(responseObject);
            [self.collectionView reloadData];
        }
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];

    }];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.modelArr.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    ((TypeCollectionCell *)cell).model = self.modelArr[indexPath.row];
    return cell;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    CaricatureDetailViewController * vc = [[CaricatureDetailViewController alloc]init];
    vc.cartoonId = self.modelArr[indexPath.row].cartoon.id;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark <UICollectionViewDelegate>



@end
