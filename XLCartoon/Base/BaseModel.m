//
//  BaseModel.m
//  XLCartoon
//
//  Created by Amitabha on 2018/2/5.
//  Copyright © 2018年 XLCR. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel

+(id)mj_getNewValueFromObject:(__unsafe_unretained id)object oldValue:(__unsafe_unretained id)oldValue property:(MJProperty *__unsafe_unretained)property{
    if ([self isEmpty:oldValue]) {// 以字符串类型为例
        return  @"";
    }
    return oldValue;
}
+(BOOL)isEmpty:(NSString*)text{
    if ([text isEqual:[NSNull null]]) {
        return YES;
    }
    else if ([text isKindOfClass:[NSNull class]])
    {
        return YES;
    }
    else if (text == nil){
        return YES;
    }
    return NO;
}


@end
