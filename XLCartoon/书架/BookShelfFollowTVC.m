 //
//  BookShelfFollowTVC.m
//  XLCartoon
//
//  Created by Amitabha on 2017/12/29.
//  Copyright © 2017年 XLCR. All rights reserved.
//

#import "BookShelfFollowTVC.h"
#import "CartoonInfoModel.h"
#import "CaricatureDetailViewController.h"
#import "TypeCollectionCell.h"
@interface BookShelfFollowTVC ()
//@property (nonatomic,strong) NSMutableArray <cartoon *>* modelArr;
@end

@implementation BookShelfFollowTVC

static NSString * const reuseIdentifier = @"TypeCollectionCell";
- (instancetype)init
{
    self = [super init];
    if (self) {
        CGFloat w = (SCREEN_WIDTH-41)/3.0;
        CGFloat h = w*1.34 + 30;
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake( w,h);
        
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        layout.minimumInteritemSpacing = 10;
        layout.minimumLineSpacing = 10;
        return [self initWithCollectionViewLayout:layout];

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _modelArr = [NSMutableArray array];

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
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.collectionView.mj_header beginRefreshing];
}

- (BOOL)emptyDataSetShouldAnimateImageView:(UIScrollView *)scrollView {
    return NO;
}


-(void)getData{
    [super getData];
    NSDictionary * param = @{@"nowPage":[NSString stringWithFormat:@"%d",self.pageIndex+1]};
    
    [AfnManager postListDataUrl:URL_BOOKSHELF_FOLLOW param:param result:^(NSDictionary *responseObject) {
        if (responseObject) {
            if (self.collectionView.mj_header.isRefreshing) {
                self.modelArr = [NSMutableArray array];
                [self.collectionView.mj_footer resetNoMoreData];
            }
            for (NSDictionary * dict in OBJ(responseObject)) {
                [self.modelArr addObject:[CartoonDetailModel mj_objectWithKeyValues:dict]];
            }
            [self.collectionView reloadData];
            self.pageIndex = PAGE_INDEX(responseObject);
            self.pageToale = PAGE_TOTAL(responseObject);
        }
        [self.collectionView.mj_footer endRefreshing];
        [self.collectionView.mj_header endRefreshing];
        self.loading = NO;
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
    vc.hidesBottomBarWhenPushed = YES;
    vc.cartoonId = self.modelArr[indexPath.row].cartoon.id;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark <UICollectionViewDelegate>


// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}



// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}



// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
    return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
    
}

@end
