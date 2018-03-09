//
//  everyDayShowView.m
//  XLCartoon
//
//  Created by Amitabha on 2018/1/22.
//  Copyright © 2018年 XLCR. All rights reserved.
//

#import "everyDayShowView.h"
#import "CartoonInfoModel.h"
#import <UIButton+WebCache.h>

@interface everyDayShowView()

@end

@implementation everyDayShowView

-(void)awakeFromNib{
    [super awakeFromNib];
    _modelArr = [NSMutableArray array];
    for (UIView * view in _btnView.subviews) {
        [view removeFromSuperview];
    }
    [self layoutIfNeeded];
    [self getUpdateCartoonData];
    
}
-(void)setModelArr:(NSMutableArray *)modelArr{
    _modelArr = modelArr;
    CGPoint center = _btnView.center;
    int j = 0;
    for (CartoonDetailModel * model in self.modelArr) {
        
        UIButton * btn  = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnView addSubview:btn];
        [btn sd_setImageWithURL:[NSURL URLWithString:model.cartoon.midelPhoto] forState:UIControlStateNormal];
        btn.frame = CGRectMake(j*70, 0, 60, 85);
        btn.tag = 1000 + j;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 65, 60, 20)];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = model.cartoon.updateTile;
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = [ UIColor whiteColor];
        label.shadowColor = [UIColor blackColor];
        label.shadowOffset = CGSizeMake(-1, -1);
        [btn addSubview:label];
        j++;
    }
    if (j ==0 ) {
        
        _updateTipLabel.hidden = YES;
        _btnView.hidden = YES;
        [_backVIew setupAutoHeightWithBottomView:_btn bottomMargin:20];
        [_backVIew layoutSubviews];
    }else{
        _btnView.size = CGSizeMake(60*j+10*(j-1), 85);
    }
    _btnView.center = center;
}
-(void)getUpdateCartoonData{
//    URL_EVERYDAY_UPDATA
   
//    return;
    [AfnManager postWithUrl:URL_EVERYDAY_UPDATA param:nil Sucess:^(NSDictionary *responseObject) {
        
    }];
}
-(void)btnClick:(UIButton *)btn{
    self.clickBlock(self.modelArr[btn.tag-1000]);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
