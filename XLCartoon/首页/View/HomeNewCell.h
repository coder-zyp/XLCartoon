//
//  HomeNewCell.h
//  XLCartoon
//
//  Created by Amitabha on 2018/2/9.
//  Copyright © 2018年 XLCR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeNewCell : UITableViewCell

@property (nonatomic,weak) IBOutlet UILabel * nameLabel;
@property (nonatomic,weak) IBOutlet UIImageView * ImageView;
@property (nonatomic,weak) IBOutlet UILabel * authorLabel;
@property (nonatomic,weak) IBOutlet UILabel * playLabel;

@property (nonatomic,weak) IBOutlet UILabel * followLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *authorLabelWidthLayout;

@property (nonatomic,strong) NSMutableArray * tagLabels;
@property (nonatomic, strong) CartoonDetailModel * model;
@end
