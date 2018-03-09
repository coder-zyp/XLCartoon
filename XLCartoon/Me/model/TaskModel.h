//
//  TaskModel.h
//  XLCartoon
//
//  Created by Amitabha on 2018/1/11.
//  Copyright © 2018年 XLCR. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface userTaskModel : NSObject

@property (nonatomic,strong) NSString * userId;//"1",
@property (nonatomic,strong) NSString * taskId;//1,
@property (nonatomic,strong) NSString * sort;//1,
@property (nonatomic,strong) NSString * id;//"uQId3UZgJeKQNlWRvuLILRtIn3qvhVHn",
@property (nonatomic,assign) int buttonState;//1,
@property (nonatomic,strong) NSString * obj;//"",
@property (nonatomic,strong) NSString * implDate;//"2018-01-11 09:59:31",
@property (nonatomic,strong) NSString * overTime;//"",
@property (nonatomic,strong) NSString * type;//4,
@property (nonatomic,strong) NSString * startTime;//"",
@property (nonatomic,assign) NSInteger  taskState;//签到天shu

@end

@interface cartoonTaskModel : NSObject
@property (nonatomic,assign) int  taskType;//4,
@property (nonatomic,strong) NSString * taskInfo;//"签到",
@property (nonatomic,strong) NSString * sort;//1,
@property (nonatomic,assign) int id;//1,
@property (nonatomic,strong) NSString * obj;//"",
@property (nonatomic,strong) NSString * taskName;//"签到",
@property (nonatomic,strong) NSString * implDate;//"2017-12-25 00:00:01",
@property (nonatomic,strong) NSString * overTime;//"",
@property (nonatomic,strong) NSString * startTime;//"",
@property (nonatomic,strong) NSString * state;//1,
@property (nonatomic,strong) NSString * taskAward;//10
@end

@interface TaskModel : NSObject

@property (nonatomic,strong) cartoonTaskModel * cartoonTask;
@property (nonatomic,strong) userTaskModel * userTask;

@end
