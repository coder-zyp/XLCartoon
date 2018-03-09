//
//  AddressManager.h
//  ReadingXLCR
//
//  Created by yuchutian on 2018/1/12.
//  Copyright © 2018年 In.于楚天. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressManager : NSObject

+ (instancetype)shareInstance;

@property (nonatomic,strong) NSArray *provinceDicAry;

#define kAddressManager [AddressManager shareInstance]

@end
