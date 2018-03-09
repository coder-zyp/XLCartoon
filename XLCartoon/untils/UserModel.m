//
//  UserModel.m
//  XLCartoon
//
//  Created by Amitabha on 2018/1/11.
//  Copyright © 2018年 XLCR. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

-(NSString *)sex{
    switch (_sex.intValue) {
        case 1:
            return @"男";
            break;
        case 2:
            return @"女";
            break;
        default:
            return @"未填写";
            break;
    }
}
-(NSString *)city{
    if (_city.length && self.province.length) {
        return [NSString stringWithFormat:@"%@-%@",_province,_city];
    }else{
        if (_province.length) {
            return _province;
        }
        if (_city.length) {
            return _city;
        }
    }
    return @"未填写";
}
@end
