//
//  ReadingCartoonTVC.h
//  XLCartoon
//
//  Created by Amitabha on 2017/12/25.
//  Copyright © 2017年 XLCR. All rights reserved.
//

#import "EpisodeModel.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>


typedef void(^ReadingVCpop)(NSArray * cartoonIds);

@interface ReadingCartoonTVC1 : UIViewController<DZNEmptyDataSetSource, DZNEmptyDataSetDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) CartoonDetailModel * cartoonModel;
@property (nonatomic,copy) ReadingVCpop  popBlcok;
@property (nonatomic,assign) NSInteger episodeIndex;
@property (nonatomic,strong) NSArray <EpisodeModel *>* episodes;

@end
