//
//  InformationPickerView.h
//  ReadingXLCR
//
//  Created by yuchutian on 2018/1/12.
//  Copyright © 2018年 In.于楚天. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressManager.h"

#define kStartTag       80000



@interface InformationPickerView : UIView

@property (nonatomic,strong) NSArray *dataDicAry;
@property (nonatomic,strong) NSMutableArray *yearArr;
@property (nonatomic,strong) NSMutableArray *mouthArr;
@property (nonatomic,strong) NSMutableArray *dayArr;
//这三个参数放在外面，可供外界调用
@property (nonatomic,strong) NSString *year;

@property (nonatomic,strong) NSString *month;

@property (nonatomic,strong) NSString *day;

//每个月的天数
@property (nonatomic,assign) int dayNumber;

@property (nonatomic,copy) void (^completion)(NSString *FirstRowName,NSString *SecondRowName,NSString *ThirdRowName);

- (void)show;

- (void)showPickerWithFirstRowName:(NSString *)FirstRowName SecondRowName:(NSString *)SecondRowName ThirdRowName:(NSString *)ThirdRowName;

@end
