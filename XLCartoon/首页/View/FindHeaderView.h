//
//  FindHeaderView.h
//  XLCartoon
//
//  Created by Amitabha on 2018/2/24.
//  Copyright © 2018年 XLCR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSCustomButton.h"
@interface FindHeaderView : UICollectionReusableView
@property (nonatomic,strong) CartoonDetailModel * model;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet FSCustomButton *moreBtn;
@end
