//
//  commentModel.h
//  XLGame
//
//  Created by Amitabha on 2017/12/13.
//  Copyright © 2017年 In.于楚天. All rights reserved.
//

#import <Foundation/Foundation.h>

/***漫画的评论人***/
@interface user : NSObject

@property (nonatomic,strong) NSString * userId;//1",
@property (nonatomic,strong) NSString * headimgurl;//http://wx.ql
@property (nonatomic,strong) NSString * username;//1",

@end
/***漫画的评论***/
@interface cartoonComment : NSObject
@property (nonatomic,strong) NSString * obj;//",
@property (nonatomic,strong) NSString * startTime;//",
@property (nonatomic,strong) NSString * overTime;//",
@property (nonatomic,strong) NSString * id;//1o5gXTrbP2AOAegA7mfsYskR8hpFIBb1",
@property (nonatomic,strong) NSString * cartoonId;//RBDbvzMQoj1ADUrtgokffdG7k5CE1YHr",
@property (nonatomic,strong) NSString * userId;//1",
@property (nonatomic,strong) NSString * commentId;//0",
@property (nonatomic,strong) NSString * commentInfo;//哈哈 真的逗",
@property (nonatomic,strong) NSString * commentDate;//2017-12-19 20:54:03",
@property (nonatomic,strong) NSString * aite;//0",
@property (nonatomic,assign) int commentCount;//":1,
@property (nonatomic,strong) NSString * okCount;//":1,
@property (nonatomic,assign) int sort;//":1,
@property (nonatomic,strong) NSString * implDate;//2017-12-19 20:54:03"
@end
/***评论总model***/
@interface commentModel : NSObject <NSCopying>
@property (nonatomic,assign) BOOL veryOk; 
@property (nonatomic,strong) NSArray <commentModel *>* list;
@property (nonatomic,strong) cartoonComment * cartoonComment;
@property (nonatomic,strong) user * user;
@property (nonatomic,strong) cartoonComment * cartoonCommentson;
@end
