//
//  UnlockCartoonView.m
//  XLCartoon
//
//  Created by Amitabha on 2018/1/25.
//  Copyright © 2018年 XLCR. All rights reserved.
//

#import "UnlockCartoonView.h"
#import "TaskTableViewController.h"
#import "PayCollectionViewController.h"

@interface UnlockCartoonView()
@property (nonatomic,strong) UIView * backView;
@property (nonatomic,strong) IBOutlet UILabel * needIntegralLabel;
@property (nonatomic,strong) IBOutlet UILabel * myIntegralLabel;
@property (weak, nonatomic) IBOutlet UILabel *vipNeedLabel;
@property (weak, nonatomic) IBOutlet UIButton *taskBtn;
@property (weak, nonatomic) IBOutlet UIButton *stateIconBtn;

@property (nonatomic, copy) sucess sucess;
@property (nonatomic, copy) failed failed;
@end
@implementation UnlockCartoonView

-(void)awakeFromNib{
    [super awakeFromNib];
    _myIntegralLabel.backgroundColor = COLOR_LIGHT_GARY;
    self.layer.cornerRadius = 10;
    self.taskBtn.layer.borderColor = COLOR_NAVI.CGColor;
    [self.stateIconBtn setSelected:USER_MODEL.hobby];
//    self.stateIconBtn.adjustsImageWhenHighlighted
}
-(void)setModel:(EpisodeModel *)model sucess:(sucess)sucess failed:(failed)failed{
    _model = model;
    
    self.myIntegralLabel.text = USER_MODEL.integral;
    [self.stateIconBtn setSelected:USER_MODEL.hobby];
    self.sucess = sucess;
    self.failed = failed;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CGFloat needPrice = model.cartoonSet.price.floatValue;
        
        NSMutableAttributedString * needText = [[NSMutableAttributedString alloc]initWithString:@"观看本集需要："];
        [needText appendAttributedString:[[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%.0f咔咔豆",needPrice] attributes:@{NSForegroundColorAttributeName:COLOR_NAVI}]];
        
        NSMutableAttributedString * vipNeed =[[NSMutableAttributedString alloc]initWithString:@"vip仅需："];
        
        [vipNeed appendAttributedString:[[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%.0f咔咔豆",needPrice*0.7] attributes:@{NSForegroundColorAttributeName:COLOR_NAVI}]];
        
        if ([[USER_INFO objectForKey:@"vipId"] boolValue]) {
            needPrice *= 0.7;
        }
        NSMutableAttributedString * paytext =  [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"消费%.0f咔咔豆解锁",needPrice]];
        [paytext addAttribute:NSForegroundColorAttributeName value:COLOR_NAVI range:NSMakeRange(2, model.cartoonSet.price.length)];
        //异步返回主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.needIntegralLabel.attributedText = needText;
            self.vipNeedLabel.attributedText = vipNeed;
            [self.stateIconBtn setAttributedTitle:paytext forState:UIControlStateNormal];
        });
        
    });
}

- (IBAction)autoUnlockbtnClick:(id)sender {
    NSDictionary * param = @{@"hobby":[NSString stringWithFormat:@"%d",!self.stateIconBtn.isSelected]};
    [AfnManager postUserAction:URL_SAVE_USER_INFO param:param Sucess:^(NSDictionary *responseObject) {
        self.stateIconBtn.selected = !self.stateIconBtn.isSelected;
        [APP_DELEGATE getUserInfo];
    }];
}
- (IBAction)unlockBtnClick:(id)sender {
    [SVProgressHUD show];
    NSDictionary * param = @{@"price":self.model.cartoonSet.price,
                             @"integral": USER_MODEL.integral,
                             @"cartoonSetId": self.model.cartoonSet.id,
                             @"cartoonId": self.model.cartoonSet.cartoonId
                             };
    [AfnManager postUserAction:URL_CARTOON_UNLOCK param:param Sucess:^(NSDictionary *responseObject) {
        [APP_DELEGATE getUserInfo];
        [self.superview removeFromSuperview];
        _model.watchState = 1;
        self.sucess();
    }];
}


-(IBAction)vipBtnClick{
    [self.superview removeFromSuperview];
    self.failed([[PayCollectionViewController alloc]init]);
}
-(IBAction)taskBtnClick{
    [self.superview removeFromSuperview];
    self.failed([[TaskTableViewController alloc]init]);
}
- (IBAction)closeBtnClick:(id)sender {
    [self.superview removeFromSuperview];
    self.failed(nil);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
