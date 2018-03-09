//
//  InformaitonPickerDataView.h
//  ReadingXLCR
//
//  Created by yuchutian on 2018/1/13.
//  Copyright © 2018年 In.于楚天. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, SYLJDatePickerTypes) {
    SYLJDatePickerTypeBirthdayDate,
    SYLJDatePickerTypeValidityDate,
};


@interface InformaitonPickerDataView : UIView

@property (nonatomic,copy) void (^completion)(NSString * pickerDate);

- (void)show;

@end
