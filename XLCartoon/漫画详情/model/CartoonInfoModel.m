//
//  NewCaricatureModel.m
//  XLCartoon
//
//  Created by Amitabha on 2017/12/20.
//  Copyright © 2017年 XLCR. All rights reserved.
//

#import "CartoonInfoModel.h"

/**********************漫画详情类**************************/
@implementation cartoon
-(NSString *)cartoonName{
    return _cartoonName;
}

-(NSString *)smallPhoto{
    if (_smallPhoto == nil) return @"";
    return _smallPhoto;
}
-(NSString *)introduc{
    if (_introduc == nil) return @"";
    return _introduc;
}
-(NSString *)introduction{
    if (_introduction == nil) return @"";
    return _introduction;
}
@end
/**********************漫画类型**************************/
@implementation carrtoonType
@end

@implementation cartoonTypeAll
@end
/**********************列表**************************/
@implementation CartoonDetailModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"cartoonAllType" : [cartoonTypeAll class]};
}


@end
