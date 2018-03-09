//
//  ReadingCommentCell.m
//  XLCartoon
//
//  Created by Amitabha on 2018/3/5.
//  Copyright © 2018年 XLCR. All rights reserved.
//

#import "ReadingCommentCell.h"

@implementation ReadingCommentCell

+(instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    static NSString * cellId = @"ReadingCommentCell";
    ReadingCommentCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UIView * line = [UIView new];
    line.backgroundColor = COLOR_LIGHT_GARY;
    line.frame = CGRectMake(0, 80, SCREEN_WIDTH, 0.5);

}
-(void)setModel:(commentModel *)model{
    [self.icon sd_setImageWithURL:[NSURL URLWithString:model.user.headimgurl] placeholderImage:[UIImage imageNamed:@"usericonwithlogin"]] ;
    self.nameLabel.text = model.user.username;
    self.commentLabel.text = model.cartoonComment.commentInfo;
    self.timeLabel.text = model.cartoonComment.commentDate;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
