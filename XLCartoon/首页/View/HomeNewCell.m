//
//  HomeNewCell.m
//  XLCartoon
//
//  Created by Amitabha on 2018/2/9.
//  Copyright © 2018年 XLCR. All rights reserved.
//

#import "HomeNewCell.h"

@implementation HomeNewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _followLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
    _followLabel.textColor = [UIColor whiteColor];
    _followLabel.layer.masksToBounds = YES;
    
    UIView * backView = [UIView new];
    backView.size = _followLabel.size;
    
    [self.contentView insertSubview:backView belowSubview:_followLabel];
    backView.sd_layout.centerXEqualToView(_followLabel).centerYEqualToView(_followLabel);
    
    CAGradientLayer *layer = [CAGradientLayer layer];
    //设置开始和结束位置(设置渐变的方向)
    layer.startPoint = CGPointMake(1, 0);
    layer.endPoint = CGPointMake(0, 0);
    layer.colors = [NSArray arrayWithObjects:(id)rgba(0, 0, 0, 1).CGColor, rgba(0, 0, 0, 0).CGColor, nil];
    layer.frame = _followLabel.bounds;
    [backView.layer addSublayer:layer];
    
    self.backgroundView.backgroundColor = COLOR_SYSTEM_GARY;
    self.contentView.frame = CGRectMake(15, 0, SCREEN_WIDTH-30, self.frame.size.height-80);
    self.layer.cornerRadius = 8;
    self.selectionStyle= UITableViewCellSelectionStyleNone;
    [self tagLabels];
}
- (void)setFrame:(CGRect)frame{
    frame.origin.x += 15;
    frame.origin.y += 10;
    frame.size.height -= 15;
    frame.size.width -= 30;
    [super setFrame:frame];
}

-(void)setModel:(CartoonDetailModel *)model{
    _model = model;
    [self.ImageView sd_setImageWithURL:[NSURL URLWithString:_model.cartoon.mainPhoto] placeholderImage:Z_PlaceholderImg];
    self.followLabel.text = [NSString stringWithFormat:@"关注：%@",self.model.cartoon.followCount];

    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //子线程异步执行，防止主线程卡顿
        
        
        NSMutableAttributedString *authorLabelText = [[NSMutableAttributedString alloc]initWithString:_model.cartoon.cartoonAuthor];
        
        NSTextAttachment *attach = [[NSTextAttachment alloc] init];
        attach.image = [UIImage imageNamed:@"author"];
        attach.bounds = CGRectMake(0, -3, 18, 18);
        [authorLabelText insertAttributedString:[NSAttributedString attributedStringWithAttachment:attach] atIndex:0];
        
        
        NSMutableAttributedString * playText = [[NSMutableAttributedString alloc]initWithString:_model.cartoon.commentCount];
        
        attach = [[NSTextAttachment alloc] init];
        attach.bounds = CGRectMake(0, -5, 18, 18);
        attach.image = [UIImage imageNamed:@"comment"];
        
        [playText insertAttributedString:[NSAttributedString attributedStringWithAttachment:attach] atIndex:0];
        
        [playText appendAttributedString:[[NSAttributedString alloc]initWithString:@"  "]];
        
        attach = [[NSTextAttachment alloc] init];
        attach.bounds = CGRectMake(0, -5, 18, 18);
        attach.image = [UIImage imageNamed:@"play"];
        [playText appendAttributedString:[NSAttributedString attributedStringWithAttachment:attach]];
        
        [playText appendAttributedString:[[NSAttributedString alloc]initWithString: _model.cartoon.playCount]];
        
        NSMutableAttributedString * nameText = [[NSMutableAttributedString alloc]initWithString:_model.cartoon.cartoonName];
        
        NSString * str = [NSString stringWithFormat:@"  更新至:%@", _model.cartoon.updateTile];
        [nameText appendAttributedString:[[NSAttributedString alloc]initWithString:str attributes:@{NSForegroundColorAttributeName:[UIColor grayColor],NSFontAttributeName:[UIFont systemFontOfSize:13]}]];
        
        
        //异步返回主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            self.authorLabelWidthLayout.constant = [authorLabelText.string sizeWithAttributes:@{NSFontAttributeName:self.authorLabel.font}].width+20;
            self.authorLabel.attributedText = authorLabelText;
            self.playLabel.attributedText = playText;
            self.nameLabel.attributedText = nameText;
        });
    });
    
    int i = 0;
    CGFloat x = 5;
    CGFloat y = CGRectGetMaxY(self.contentView.frame);
    for (UILabel * label in self.tagLabels) {
        if (i<_model.cartoonAllType.count) {
            NSString * str = _model.cartoonAllType[i].carrtoonType.cartoonType;
            //            label.text = [NSString stringWithFormat:@"  %@  ",str];
            label.text = str;
            CGFloat width = [str sizeWithAttributes:@{NSFontAttributeName : label.font}].width +15;
            
            label.frame = CGRectMake(x, y-20-7.5, width, 20);
            x+= width+5;
        }else{
            label.frame = CGRectZero;
            label.text = @"";
        }
        i++;
    }
    
    
    
}
-(NSMutableArray *)tagLabels{
    
    if(_tagLabels == nil){
        NSMutableArray * arr = [NSMutableArray array];
        for (int i =0; i<5; i++) {
            UILabel * label = [UILabel new];
            [arr addObject:label];
            label.layer.cornerRadius = 10;
            label.layer.borderWidth = 0.5;
            label.textColor = COLOR_BUTTON;
            label.textAlignment = NSTextAlignmentCenter;
            label.layer.borderColor = COLOR_BUTTON.CGColor;
            label.font = [UIFont systemFontOfSize:10];
            [self.contentView addSubview:label];
        }
        _tagLabels = arr;
    }
    return _tagLabels;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
