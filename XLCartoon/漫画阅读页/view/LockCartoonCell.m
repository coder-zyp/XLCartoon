//
//  LockCartoonCell.m
//  XLCartoon
//
//  Created by Amitabha on 2018/3/3.
//  Copyright © 2018年 XLCR. All rights reserved.
//

#import "LockCartoonCell.h"

@interface LockCartoonCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *needKakaLabel;
@property (weak, nonatomic) IBOutlet UILabel *vipNeedLabel;
@property (weak, nonatomic) IBOutlet UILabel *myKakaLabel;
@property (weak, nonatomic) IBOutlet UIButton *unlockBtn;
@property (weak, nonatomic) IBOutlet UIButton *autoBuyBtn;

@end

@implementation LockCartoonCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.unlockBtn.layer.cornerRadius = 8;
    self.needKakaLabel.layer.masksToBounds = YES;
    self.needKakaLabel.layer.cornerRadius = 8;
}

+(instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    static NSString * cellId = @"LockCartoonCell";
    LockCartoonCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];

    return cell;
}
-(void)setModel:(ReadingCartoonModel *)model{
    _model = model;
    
    self.titleLabel.text = model.episodeModel.cartoonSet.titile;
    self.myKakaLabel.text = USER_MODEL.integral;
    [self.autoBuyBtn setSelected:USER_MODEL.hobby];
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CGFloat needPrice = model.episodeModel.cartoonSet.price.floatValue;
        
        NSMutableAttributedString * needText = [[NSMutableAttributedString alloc]initWithString:@"观看本集需要："];
        [needText appendAttributedString:[[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%.0f咔咔豆",needPrice] attributes:@{NSForegroundColorAttributeName:COLOR_NAVI}]];
        
        NSMutableAttributedString * vipNeed =[[NSMutableAttributedString alloc]initWithString:@"vip仅需："];
        
        [vipNeed appendAttributedString:[[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%.0f咔咔豆",needPrice*0.7] attributes:@{NSForegroundColorAttributeName:COLOR_NAVI}]];
        
        if ([[USER_INFO objectForKey:@"vipId"] boolValue]) {
            needPrice *= 0.7;
        }
        NSMutableAttributedString * paytext =  [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"消费%.0f咔咔豆解锁",needPrice]];
        [paytext addAttribute:NSForegroundColorAttributeName value:COLOR_NAVI range:NSMakeRange(2, model.episodeModel.cartoonSet.price.length)];
        //异步返回主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.needKakaLabel.attributedText = needText;
            self.vipNeedLabel.attributedText = vipNeed;
            [self.unlockBtn setAttributedTitle:paytext forState:UIControlStateNormal];
        });
        
    });
    
    
    
    
}
- (IBAction)unlockBtnClick:(id)sender {
    NSDictionary * param = @{@"price":self.model.episodeModel.cartoonSet.price,
                             @"integral": USER_MODEL.integral,
                             @"cartoonSetId": self.model.episodeModel.cartoonSet.id,
                             @"cartoonId": self.model.episodeModel.cartoonSet.cartoonId
                             };
    [AfnManager postUserAction:URL_CARTOON_UNLOCK param:param Sucess:^(NSDictionary *responseObject) {
        [APP_DELEGATE getUserInfo];
        self.model.episodeModel.watchState = 1;
        if (self.delegate && [self.delegate respondsToSelector:@selector(LockCartoonCellUnlockSucess)]) {

            [self.delegate LockCartoonCellUnlockSucess];
        }
//        NSDictionary * param = @{
//                                 @"cartoonId": self.model.episodeModel.cartoonSet.cartoonId,
//                                 @"cartoonSetId": self.model.episodeModel.cartoonSet.id,
//                                 @"up":@"0"
//                                 };
//        NSLog(@"getImageData%@",param);
//        [AfnManager postListDataUrl:URL_CARTOON_PIC param:param result:^(NSDictionary *responseObject) {
//            if (responseObject) {
//                
//                ReadingCartoonModel * model = [ReadingCartoonModel mj_objectWithKeyValues:responseObject];
//                self.model.episodeModel.watchState = 1;
//                self.model.photos = model.photos;
//                
//                if (self.delegate && [self.delegate respondsToSelector:@selector(LockCartoonCellUnlockSucess)]) {
//                    
//                    [self.delegate LockCartoonCellUnlockSucess];
//                }
//            }
//        }];
    }];
}
- (IBAction)addKakaBtnClick:(id)sender {
}
- (IBAction)autoBuyBtnClick:(id)sender {
    NSDictionary * param = @{@"hobby":[NSString stringWithFormat:@"%d",!self.autoBuyBtn.isSelected]};
    [AfnManager postUserAction:URL_SAVE_USER_INFO param:param Sucess:^(NSDictionary *responseObject) {
        self.autoBuyBtn.selected = !self.autoBuyBtn.isSelected;
        [APP_DELEGATE getUserInfo];
    }];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
