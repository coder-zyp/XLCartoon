//
//  BookShelfFollowTVC.h
//  XLCartoon
//
//  Created by Amitabha on 2017/12/29.
//  Copyright © 2017年 XLCR. All rights reserved.
//
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

@interface BookShelfFollowTVC : UICollectionViewController <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic,strong) NSString * typeId;
@property (nonatomic,strong) NSMutableArray <CartoonDetailModel *>* modelArr;
@property (nonatomic,assign) int pageIndex;
@property (nonatomic,assign) int pageToale;

@end
