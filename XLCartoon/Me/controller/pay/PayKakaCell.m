//
//  PayKakaCell.m
//  XLCartoon
//
//  Created by Amitabha on 2018/2/12.
//  Copyright © 2018年 XLCR. All rights reserved.
//

#import "PayKakaCell.h"

@interface PayKakaCell()

@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *saleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *hotIcon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *productNameWidth;
@end

@implementation PayKakaCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.layer.cornerRadius = 8;
    self.layer.borderWidth = 1;
    self.backgroundColor = COLOR_SYSTEM_GARY;
    // Initialization code
}
-(void)setModel:(PayProductModel *)model{
    _model = model;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString * str = [NSString stringWithFormat:@"%.0f元  ",model.price];
        NSMutableAttributedString * moneyText = [[NSMutableAttributedString alloc]initWithString:str attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:[UIColor redColor]}];
        if (model.saleState) {
            NSString * str2 = [NSString stringWithFormat:@"%.0f元",model.oldPrice];
            NSDictionary * attribute = @{
                                         NSFontAttributeName:[UIFont systemFontOfSize:14],
                                         NSForegroundColorAttributeName:[UIColor grayColor],
                                         NSStrikethroughStyleAttributeName : @(NSUnderlinePatternSolid | NSUnderlineStyleSingle),
                                         NSStrikethroughColorAttributeName:[UIColor grayColor],
                                         NSBaselineOffsetAttributeName:@(0)
                                         };
            NSAttributedString * aStr =[[NSAttributedString alloc]initWithString:str2 attributes:attribute];
            [moneyText appendAttributedString:aStr];
        }

        
        //异步返回主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.moneyLabel.attributedText = moneyText;
        });
    });

    self.productNameLabel.text = model.introduc;
    self.productNameWidth.constant = [model.introduc sizeWithAttributes:@{NSFontAttributeName:self.productNameLabel.font}].width+10;
    if (model.hot) {
        self.hotIcon.hidden = NO;
        self.layer.borderColor = [UIColor redColor].CGColor;
    }else{
        self.hotIcon.hidden = YES;
        self.layer.borderColor = [UIColor clearColor].CGColor;
    }
    if (model.saleState) {
        self.saleLabel.text = [NSString stringWithFormat:@"%.1f折",model.sale];
        self.saleLabel.hidden = NO;
    }else{
        self.saleLabel.hidden = YES;
    }
    

}
//-(void)setSelected:(BOOL)selected{
//    [super setSelected:selected];
//    if (self.selected) {
//        
//        self.model.hot = YES;
//    }else{
//        
//        self.model.hot = NO;
//    }
//}
@end
