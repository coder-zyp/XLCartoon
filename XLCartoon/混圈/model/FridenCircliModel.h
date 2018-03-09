//
//  FridenCircliModel.h
//  XLCartoon
//
//  Created by Amitabha on 2017/12/29.
//  Copyright © 2017年 XLCR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface friendsCircle : NSObject
@property (nonatomic,strong) NSString * id;//I0z2e0qkL57JnnRONCdQrb7aqh8VX6AS",
@property (nonatomic,strong) NSString * releaseInfo;//说点什么",
@property (nonatomic,strong) NSString * okCount;//":0,
@property (nonatomic,strong) NSString * releaseDate;//昨天",
@property (nonatomic,strong) NSString * implDate;//2017-12-28 11:00:58",
@property (nonatomic,strong) NSString * state;//":1,
@property (nonatomic,strong) NSString * aite;//0",
@property (nonatomic,strong) NSString * deleteState;//":0,
@property (nonatomic,strong) NSString * overTime;//",
@property (nonatomic,strong) NSString * userId;//1",
@property (nonatomic,strong) NSString * commentCount;//":1,
@property (nonatomic,strong) NSString * startTime;//",
@property (nonatomic,strong) NSString * photo;//http://p0oqd5s9w.b,2064",
@property (nonatomic,strong) NSString * obj;//"
@end


@interface friendsComment : NSObject

@property (nonatomic,strong) NSString * commentInfo;
@property (nonatomic,strong) NSString * friendCircleId;
@property (nonatomic,strong) NSString * commentDate;

@end


@interface photoModel : NSObject
@property (nonatomic,strong) NSString * src;//http://p0oqd5s9w.bkt.clouddn.com/1514429927807@qinruida-2a1HlfHU.jpg",
@property (nonatomic,assign) CGFloat  w;//1440",
@property (nonatomic,assign) CGFloat  h;//2560"
@end

@interface userModel : NSObject
@property (nonatomic,strong) NSString * headimgurl;//http://wx.qlogo.cn/mmopen/vi_32/Q0j4TwGTfTIVfDSpzAd2ZlnThHAIJZicM6TPib31ibT7VaEDCaN12MgN1mVJVpia786JARwrEdibOb4uUP8gYWkgfsg/0",
@property (nonatomic,strong) NSString * userId;//1",
@property (nonatomic,strong) NSString * username;//":null
@end

@interface FridenCircliModel : NSObject
@property (nonatomic,strong) userModel * user;
@property (nonatomic,strong) friendsCircle * friendsCircle;
@property (nonatomic,strong) friendsComment * friendsComment;
@property (nonatomic,strong) NSArray < photoModel *>* photo;
@property (nonatomic,strong) NSString * veryOk;
@property (nonatomic,strong) NSString * photosize;
//限制文本高度
@property (nonatomic,assign) BOOL isDetail;
@end







