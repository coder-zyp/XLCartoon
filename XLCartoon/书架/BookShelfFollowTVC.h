//
//  BookShelfFollowTVC.h
//  XLCartoon
//
//  Created by Amitabha on 2017/12/29.
//  Copyright © 2017年 XLCR. All rights reserved.
//
#import "BaseCollectionViewController.h"

@interface BookShelfFollowTVC : BaseCollectionViewController
@property (nonatomic,strong) NSString * typeId;
@property (nonatomic,strong) NSMutableArray <CartoonDetailModel *>* modelArr;
@end
