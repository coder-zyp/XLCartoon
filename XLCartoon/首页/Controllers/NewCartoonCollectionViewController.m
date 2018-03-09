//
//  NewCartoonCollectionViewController.m
//  XLCartoon
//
//  Created by Amitabha on 2018/2/28.
//  Copyright © 2018年 XLCR. All rights reserved.
//

#import "NewCartoonCollectionViewController.h"
#import "mediumPhotoCell.h"
#import "CartoonInfoModel.h"
#import "CaricatureDetailViewController.h"
#import "MJGifHeader.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
@interface NewCartoonCollectionViewController ()
@property (nonatomic,strong) NSMutableArray <CartoonDetailModel *>* modelArr;

@end

@implementation NewCartoonCollectionViewController

static NSString * const reuseIdentifier = @"mediumPhotoCell";

- (instancetype)init
{
    self = [super init];
    if (self) {
        CGFloat w = (SCREEN_WIDTH-2)/2.0;
        CGFloat h = w*170.0/320 + 50;
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake( w,h);
        
        layout.sectionInset = UIEdgeInsetsMake(10, 0, 10, 0);
        layout.minimumInteritemSpacing = 1;
        layout.minimumLineSpacing = 5;
        return [self initWithCollectionViewLayout:layout];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

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
   
    UINib * nib = [UINib nibWithNibName:reuseIdentifier bundle:[NSBundle mainBundle]];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:reuseIdentifier];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //    [self.collectionView reloadData];
}

-(void)getData{
    [super getData];
    NSDictionary * param = @{@"nowPage":[NSString stringWithFormat:@"%d",self.pageIndex+1],
                             };
    [AfnManager postListDataUrl:URL_NEW_CARTOON param:param result:^(NSDictionary *responseObject) {
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

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.modelArr.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    mediumPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.model = self.modelArr[indexPath.row];
    return cell;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    CaricatureDetailViewController * vc = [[CaricatureDetailViewController alloc]init];
    vc.cartoonId = self.modelArr[indexPath.row].cartoon.id;
    [self.navigationController pushViewController:vc animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
