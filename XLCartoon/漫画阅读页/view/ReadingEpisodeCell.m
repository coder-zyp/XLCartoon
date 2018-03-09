//
//  ReadingEpisodeCell.m
//  XLCartoon
//
//  Created by Amitabha on 2018/3/6.
//  Copyright © 2018年 XLCR. All rights reserved.
//

#import "ReadingEpisodeCell.h"
@interface ReadingEpisodeCell()


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLeadingConstraint;

@end

@implementation ReadingEpisodeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.contentView.backgroundColor = [UIColor clearColor];
    
    CALayer * line = [[CALayer alloc]init];
    line.backgroundColor = [UIColor grayColor].CGColor;
    line.frame = CGRectMake(15, CGRectGetMaxY(self.frame), CGRectGetMaxX(self.frame), 0.5);
    [self.contentView.layer addSublayer:line];
    // Initialization code
}
-(void)setModel:(EpisodeModel *)model{
    _model = model;
    _nameLabel.text = [NSString stringWithFormat:@"%@%@",_nameLabel.text,model.cartoonSet.titile] ;
    if (self.icon.hidden) {
        _nameLabel.textColor = [UIColor whiteColor];
        self.nameLeadingConstraint.constant = 20;
    }else{
        _nameLabel.textColor = COLOR_NAVI;
        self.nameLeadingConstraint.constant = 40;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
