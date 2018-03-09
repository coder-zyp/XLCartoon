//
//  BaseTableViewController.h
//  XLCartoon
//
//  Created by Amitabha on 2017/12/21.
//  Copyright © 2017年 XLCR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>


typedef void(^BasTableNoDataBlock)(void);

@interface BaseTableViewController : UITableViewController <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic, getter=isLoading) BOOL loading;
@property (nonatomic,assign) int pageIndex;
@property (nonatomic,assign) int pageToale;
-(void)getData;
@end
