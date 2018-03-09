//
//  BarrageManager.h
//  XLCartoon
//
//  Created by Amitabha on 2018/3/5.
//  Copyright © 2018年 XLCR. All rights reserved.
//

#import "OCBarrageManager.h"
#import "BarrageSwitchBtn.h"
#import "BarrageModel.h"
#import "EpisodeModel.h"

@interface BarrageManager : OCBarrageManager
@property (nonatomic,strong) BarrageSwitchBtn * barrageSwitchBtn;

@property (nonatomic,assign) BOOL isOpenBarrage;
@property (nonatomic,strong) NSArray * barrageTextArr;
-(void)getBarrageTextWithPhotoId:(NSString *)photoId cartoonId:(cartoonSet *)cartoonSet;
-(void)addBarrageWithPhotoId:(NSString *)photoId cartoonId:(cartoonSet *)cartoonSet;
@end
