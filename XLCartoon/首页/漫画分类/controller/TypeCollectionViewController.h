//
//  TypeCollectionViewController.h
//  XLCartoon
//
//  Created by Amitabha on 2018/1/13.
//  Copyright © 2018年 XLCR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseCollectionViewController.h"


@interface TypeCollectionViewController : BaseCollectionViewController
@property (nonatomic,strong) NSString * typeId;
@property (nonatomic,strong) NSMutableArray <CartoonDetailModel *>* modelArr;

@end
