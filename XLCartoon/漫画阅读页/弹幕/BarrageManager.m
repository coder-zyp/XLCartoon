//
//  BarrageManager.m
//  XLCartoon
//
//  Created by Amitabha on 2018/3/5.
//  Copyright © 2018年 XLCR. All rights reserved.
//

#import "BarrageManager.h"
#import "OCBarrageGradientBackgroundColorDescriptor.h"
#import "OCBarrageGradientBackgroundColorCell.h"
#import "CommentWindow.h"

@interface BarrageManager()
@property (nonatomic,strong) NSMutableDictionary * barrageDict;//弹幕缓存  key 为cartoonSetId
@end
@implementation BarrageManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.renderView.frame = CGRectMake(0.0, NaviHeight, SCREEN_WIDTH, SCREEN_HEIGHT/3.f);
        self.renderView.userInteractionEnabled = NO;
    }
    return self;
}
-(BOOL)isOpenBarrage{
    [self start];
    return [USER_BarrageState boolValue];
}
-(void)setIsOpenBarrage:(BOOL)isOpenBarrage{
    USER_BarrageState_Set(@(isOpenBarrage));
    [self stop];
}
-(BarrageSwitchBtn *)barrageSwitchBtn{
    if (!_barrageSwitchBtn) {
        _barrageSwitchBtn = [[BarrageSwitchBtn alloc]init];
        _barrageSwitchBtn.frame = CGRectMake(0, SCREEN_HEIGHT-TabbarHeight-24.5, 80, 25);
        _barrageSwitchBtn.selected = self.isOpenBarrage;
        _barrageSwitchBtn.icon.highlighted = self.isOpenBarrage;
        [_barrageSwitchBtn addTarget:self action:@selector(barrageSwitchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _barrageSwitchBtn;
}
-(void)barrageSwitchBtnClick:(BarrageSwitchBtn *)btn{
    
    btn.selected = !btn.isSelected;
    NSLog(@"action-----");
    btn.icon.highlighted = btn.selected;
    if (btn.selected) {
        self.isOpenBarrage = YES;
        self.barrageTextArr = self.barrageTextArr;
    }else{
        self.isOpenBarrage = NO;
    }
}
-(void)getBarrageTextWithPhotoId:(NSString *)photoId cartoonId:(cartoonSet *)cartoonSet{
    NSArray * barrageModels = [_barrageDict objectForKey:photoId];
    if (barrageModels) {
        self.barrageTextArr = barrageModels;
    }else{
        NSDictionary * param = @{@"cartoonSetId": cartoonSet.id,
                                 @"cartoonId" : cartoonSet.cartoonId,
                                 @"cartoonPhotoId" : photoId
                                 };
        [AfnManager postWithUrl:URL_BARRAGE_GET param:param Sucess:^(NSDictionary *responseObject) {
            NSMutableArray * arr = [NSMutableArray array];
            for (NSDictionary * dic in OBJ(responseObject)) {
                [arr addObject:[BarrageModel mj_objectWithKeyValues:dic]];
            }
            [_barrageDict setObject:arr forKey:photoId];
            self.barrageTextArr = arr;
        }];
    }
}
-(void)addBarrageWithPhotoId:(NSString *)photoId cartoonId:(cartoonSet *)cartoonSet{
    [CommentWindow share].title = @"发弹幕";
    [CommentWindow share].textView.placeholder = @"你也要来一发吗，很好玩的哦~";
    [CommentWindow shareWithFinshBlock:^(NSString *text, CommentWindow *window) {
        [SVProgressHUD show];
        NSDictionary * param = @{@"cartoonSetId":  cartoonSet.id,
                                 @"cartoonId":  cartoonSet.cartoonId,
                                 @"contentInfo": text,
                                 @"cartoonPhotoId" :photoId
                                 };
        [AfnManager postWithUrl:URL_BARRAGE_ADD param:param Sucess:^(NSDictionary *responseObject) {
            window.textView.text= @"";
            BarrageModel * model = [BarrageModel mj_objectWithKeyValues:OBJ(responseObject)];
            NSArray * arr = [self.barrageDict objectForKey:model.id];
            if (arr.count) {
                NSMutableArray * arr2 = [NSMutableArray arrayWithArray:arr];
                [arr2 addObject:model];
                [_barrageDict setObject:arr2 forKey:model.id];
            }else{
                [_barrageDict setObject:@[model] forKey:model.id];
            }
            self.barrageTextArr =@[model];
        }];
    }];
}
-(void)setBarrageTextArr:(NSArray *)barrageTextArr{
    if (self.isOpenBarrage == NO) {
        return;
    }
    _barrageTextArr = barrageTextArr;
    int i = 0;
    for (BarrageModel * model  in barrageTextArr) {
        OCBarrageTextDescriptor *textDescriptor = [[OCBarrageTextDescriptor alloc] init];
        
        NSString * text;
        NSLog(@"%@",USER_ID);
        if ([model.userId isEqualToString: USER_ID]) {
            textDescriptor.borderWidth = 1;
            text = [NSString stringWithFormat:@"  %@  ",model.contentInfo];
        }else{
            text = model.contentInfo;
            textDescriptor.borderWidth = 0;
        }
        textDescriptor.borderColor = [UIColor whiteColor];
        textDescriptor.text = text;
        textDescriptor.textColor = [UIColor whiteColor];
        textDescriptor.cornerRadius = 5;
        textDescriptor.positionPriority = OCBarragePositionLow;
        textDescriptor.textFont = [UIFont systemFontOfSize:18.0];
        textDescriptor.textShadowOpened = YES;
        textDescriptor.strokeColor = [[UIColor blackColor] colorWithAlphaComponent:1];
        textDescriptor.strokeWidth = -1;
        textDescriptor.animationDuration =  arc4random()%3 + 5;
        textDescriptor.barrageCellClass = [OCBarrageTextCell class];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(i*0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self renderBarrageDescriptor:textDescriptor];
        });
        
        i ++;
    }
}

@end
