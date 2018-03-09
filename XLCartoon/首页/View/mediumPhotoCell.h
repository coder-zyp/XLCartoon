//
//  mediumPhotoCell.h
//  XLCartoon
//
//  Created by Amitabha on 2018/2/28.
//  Copyright © 2018年 XLCR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface mediumPhotoCell : UICollectionViewCell
@property (nonatomic,strong) CartoonDetailModel * model;
@property (nonatomic,strong) UILabel * infoLable;
@property (weak, nonatomic) IBOutlet UIImageView *photoView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@end
