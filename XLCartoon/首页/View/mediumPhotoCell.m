//
//  mediumPhotoCell.m
//  XLCartoon
//
//  Created by Amitabha on 2018/2/28.
//  Copyright © 2018年 XLCR. All rights reserved.
//

#import "mediumPhotoCell.h"

@implementation mediumPhotoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.contentView addSubview:self.infoLable];
//    self.photoView.layer.cornerRadius = 5;
//    self.photoView.layer.masksToBounds = YES;
    self.nameLabel.font = Font_Regular(14);
    self.infoLable.sd_layout.leftEqualToView(self.contentView).rightEqualToView(self.contentView)
    .heightIs(30).bottomEqualToView(self.photoView);
    // Initialization code
}
-(void)setModel:(CartoonDetailModel *)model{
    _model = model;
    [self.photoView sd_setImageWithURL:[NSURL URLWithString:model.cartoon.smallPhoto] placeholderImage:Z_PlaceholderImg];

    NSMutableAttributedString * text = [[NSMutableAttributedString alloc]initWithString:model.cartoon.cartoonName];
    [text appendAttributedString:[[NSAttributedString alloc]initWithString:@"\n"]];
    NSString * str = [NSString stringWithFormat:@"更新至%@",model.cartoon.updateTile];
    NSAttributedString * aStr = [[NSAttributedString alloc]initWithString:str attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor grayColor]} ];
    [text appendAttributedString:aStr];

    self.nameLabel.attributedText = text;

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
