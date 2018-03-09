//
//  TypeCollectionCell.h
//  XLCartoon
//
//  Created by Amitabha on 2018/1/13.
//  Copyright © 2018年 XLCR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CartoonInfoModel.h"
#import <YYText.h>

@interface TypeCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *ImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIView *shaowView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageLayout;
@property (nonatomic,strong) CartoonDetailModel * model;
@property (nonatomic,strong) UILabel * infoLable;
//+(TypeCollectionCell *)cellWithTableView:(UITableView *)tableView;

@end
