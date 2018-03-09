//
//  EpisodeModel.h
//  XLCartoon
//
//  Created by Amitabha on 2017/12/21.
//  Copyright © 2017年 XLCR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReadingCartoonModel.h"

@interface cartoonSet : NSObject
@property (nonatomic,strong) NSString *  barrageCount;//;//"",
@property (nonatomic,strong) NSString *  moneyState;//0,
@property (nonatomic,strong) NSString *  titile;//"第3话",
@property (nonatomic,strong) NSString *  updateDate;//"2017-12-20 10:37:40",
@property (nonatomic,strong) NSString *  buyCount;//0,
@property (nonatomic,strong) NSString *  sort;//3,
@property (nonatomic,strong) NSString *  okCount;//0,
@property (nonatomic,strong) NSString *  watchState;//1,
@property (nonatomic,strong) NSString *  details;//"式和风回合",
@property (nonatomic,strong) NSString *  id;//"hK3Qt3Tqm03eyWm6D0fvSCIU981EXFXF",
@property (nonatomic,strong) NSString *  overTime;//"",
@property (nonatomic,strong) NSString *  showPhoto;//"http://p0oqd5s9w.926@qinruida-yXG6l57q.jpg",
@property (nonatomic,assign) NSInteger   playCount;//0,
@property (nonatomic,strong) NSString *  obj;//"",
@property (nonatomic,strong) NSString *  implDate;//"2017-12-20 10:36:23",
@property (nonatomic,strong) NSString *  commentCount;//0,
@property (nonatomic,strong) NSString *  cartoonId;//"RBDbvzMQoj1ADUrtgokffdG7k5CE1YHr",
@property (nonatomic,strong) NSString *  vip;//0,
@property (nonatomic,strong) NSString *  startTime;//"",
@property (nonatomic,strong) NSString *  updateTitile;//"",
@property (nonatomic,strong) NSString *  price;
@end


@interface EpisodeModel : NSObject

@property (nonatomic,assign) int  watchState;//0没解锁，1看过，2正在看
@property (nonatomic,strong) cartoonSet *  cartoonSet;
@end
