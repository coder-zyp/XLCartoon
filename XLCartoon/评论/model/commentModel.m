//
//  commentModel.m
//  XLGame
//
//  Created by Amitabha on 2017/12/13.
//  Copyright © 2017年 In.于楚天. All rights reserved.
//

#import "commentModel.h"


@implementation commentModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"list" : [commentModel class]};
}

- (id)copyWithZone:(NSZone *)zone{
    
    commentModel * model = [[commentModel allocWithZone:zone] init];
    
    model.cartoonComment=self.cartoonComment;
    model.list= @[];
    model.cartoonCommentson=self.cartoonCommentson;
    model.user=self.user;
    model.veryOk = self.veryOk;
    
    return model;
}
@end

@implementation user

@end

@implementation cartoonComment

//+ (NSDictionary *)mj_objectClassInArray {
//    // value should be Class or Class name.
////    return @{@"comment" : [commentModel class],
////             };
//}

@end




