//
//  TypeCollectionViewController.h
//  XLCartoon
//
//  Created by Amitabha on 2018/1/13.
//  Copyright © 2018年 XLCR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

@interface TypeCollectionViewController : UICollectionViewController <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic,strong) NSString * typeId;
@property (nonatomic,strong) NSMutableArray <CartoonDetailModel *>* modelArr;
@property (nonatomic,assign) int pageIndex;
@property (nonatomic,assign) int pageToale;
@end
