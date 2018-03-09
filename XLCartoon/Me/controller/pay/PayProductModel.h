//
//  PayProductModel.h
//  XLCartoon
//
//  Created by Amitabha on 2018/2/5.
//  Copyright © 2018年 XLCR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PayProductModel : NSObject

@property (nonatomic,assign) BOOL  hot;//1;
@property (nonatomic,strong) NSString * id;//1;
@property (nonatomic,strong) NSString * implDate;//1;
@property (nonatomic,strong) NSString * introduc;//1;
@property (nonatomic,assign) BOOL  introduction;//1;
@property (nonatomic,strong) NSString * name;//1;
@property (nonatomic,strong) NSString * overTime;//"";
@property (nonatomic,strong) NSString * photo;//1;
@property (nonatomic,assign) CGFloat    price;//1;
@property (nonatomic,assign) CGFloat  oldPrice;
@property (nonatomic,strong) NSString * productId;//1;
@property (nonatomic,strong) NSString * sort;//1;
@property (nonatomic,strong) NSString * startTime;//"";
@property (nonatomic,strong) NSString * state;//1;
@property (nonatomic,strong) NSString * type;//2;
@property (nonatomic,assign) CGFloat sale;// = 0;
@property (nonatomic,assign) BOOL  saleState;// = 0;
@property (nonatomic,strong) NSString * currency;// = 0;


@end
