//
//  BaseCollectionViewController.h
//  XLCartoon
//
//  Created by Amitabha on 2018/2/28.
//  Copyright © 2018年 XLCR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

@interface BaseCollectionViewController : UICollectionViewController <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic, getter=isLoading) BOOL loading;
@property (nonatomic,assign) int pageIndex;
@property (nonatomic,assign) int pageToale;
-(void)getData;
@end
