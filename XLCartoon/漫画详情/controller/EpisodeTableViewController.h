//
//  EpisodeTableViewController.h
//  XLGame
//
//  Created by Amitabha on 2017/12/11.
//  Copyright © 2017年 In.于楚天. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EpisodeModel.h"
#import "ZJPageViewController.h"


@interface EpisodeTableViewController : ZJPageViewController
@property (nonatomic,strong) NSString * continueReadingId;
@property (nonatomic,strong) NSMutableArray <EpisodeModel *> * modelArr;

@end
