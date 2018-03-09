//
//  TypeCollectionCell.m
//  XLCartoon
//
//  Created by Amitabha on 2018/1/13.
//  Copyright © 2018年 XLCR. All rights reserved.
//

#import "TypeCollectionCell.h"

@implementation TypeCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    CAGradientLayer *layer = [CAGradientLayer layer];
//    //设置开始和结束位置(设置渐变的方向)
//    layer.startPoint = CGPointMake(0, 1);
//    layer.endPoint = CGPointMake(0, 0);
//    layer.colors = [NSArray arrayWithObjects:(id)rgba(0, 0, 0, 1).CGColor, rgba(0, 0, 0, 0.02).CGColor, nil];
//    layer.frame = CGRectMake(0, 0, SCREEN_WIDTH, 30);
//    [self.shaowView.layer addSublayer:layer];
    
    [self.shaowView addSubview:self.infoLable];
    self.infoLable.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    
    self.ImageView.layer.masksToBounds = YES;
    self.ImageView.layer.cornerRadius = 5;
}

-(void)setModel:(CartoonDetailModel *)model{
    _model = model;
    [self.ImageView sd_setImageWithURL:[NSURL URLWithString:model.cartoon.midelPhoto] placeholderImage:Z_PlaceholderImg];
    self.nameLabel.text = model.cartoon.cartoonName;
   
    self.infoLable.text = [NSString stringWithFormat:@"更新至%@",model.cartoon.updateTile];
}
-(UILabel *)infoLable{
    if (!_infoLable) {
        _infoLable = [[UILabel alloc]init];
        _infoLable.font = [UIFont systemFontOfSize:11];
        _infoLable.numberOfLines = 2;
        _infoLable.textColor = [UIColor whiteColor];
        _infoLable.textAlignment = NSTextAlignmentCenter;
        _infoLable.shadowColor = [UIColor blackColor];
        _infoLable.shadowOffset = CGSizeMake(-0.5, -0.5);
    }
    return _infoLable;
}

@end
