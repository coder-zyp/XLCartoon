//
//  BaseModel.h
//  XLCartoon
//
//  Created by Amitabha on 2018/2/5.
//  Copyright © 2018年 XLCR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject

@property (nonatomic,strong) NSString * msg;
@property (nonatomic,assign) int nowpage;
@property (nonatomic,assign) int totalpage;
@property (nonatomic,assign) int error;

@property (nonatomic,assign,getter=isSucess) BOOL suscess;

@end
