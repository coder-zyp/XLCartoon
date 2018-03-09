//
//  InformaitonPickerDataView.m
//  ReadingXLCR
//
//  Created by yuchutian on 2018/1/13.
//  Copyright © 2018年 In.于楚天. All rights reserved.
//

#import "InformaitonPickerDataView.h"
//picker高度
#define SHAddressPickerViewHeight 240
//有效年份月日
#define kDateInterval   70

@interface InformaitonPickerDataView ()

@property (nonatomic,strong) UIView * hudView;
@property (nonatomic,strong) UIView * headView;
@property (strong, nonatomic) UIDatePicker * datePickerView;

@property (nonatomic, assign) SYLJDatePickerTypes datePickerType;

@end

@implementation InformaitonPickerDataView

- (instancetype)initWithFrame:(CGRect)frame {
    self =  [super initWithFrame:frame];
    if (self) {
        [self setupPickerView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupPickerView];
    }
    return self;
}

- (void)setupPickerView
{
    _hudView = [[UIView alloc] initWithFrame:self.frame];
    _hudView.backgroundColor = [UIColor blackColor];
    _hudView.alpha = 0.6;
    [self addSubview:_hudView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
    [_hudView addGestureRecognizer:tap];
    
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.datePickerView];
    
    _headView = [[UIView alloc] initWithFrame:CGRectMake(0, self.datePickerView.frame.origin.y - 43.5, self.frame.size.width, 43.5)];
    _headView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(10, 0, 43.5, 43.5);
    button.backgroundColor = [UIColor clearColor];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    [button setTitleColor:[UIColor colorWithRed:0/255.0 green:122/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateNormal];
    [button setTitle:@"取消" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    [_headView addSubview:button];
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(self.frame.size.width - 53.5, 0, 43.5, 43.5);
    button.backgroundColor = [UIColor clearColor];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    [button setTitleColor:[UIColor colorWithRed:0/255.0 green:122/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateNormal];
    [button setTitle:@"确定" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(completionButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_headView addSubview:button];
    
    [self addSubview:_headView];
}

- (void)completionButtonAction:(id)sender
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString * destDateString = [dateFormatter stringFromDate:self.datePickerView.date];
    
    if (_completion) {
        _completion(destDateString);
    }
    [self hide];
}

- (void)show{
    self.hidden = NO;
    _hudView.alpha = 0.6;
    [UIView animateWithDuration:0.5 animations:^{
        self.datePickerView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - SHAddressPickerViewHeight, self.frame.size.width, SHAddressPickerViewHeight);
        _headView.frame = CGRectMake(0, self.datePickerView.frame.origin.y - 43.5, self.frame.size.width, 43.5);
    } completion:^(BOOL finished) {
        [self setingDateInterval];
    }];
}

- (void)hide{
    _hudView.alpha = 0;
    [UIView animateWithDuration:0.5 animations:^{
        self.datePickerView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height+44, self.frame.size.width, SHAddressPickerViewHeight);
        _headView.frame = CGRectMake(0, self.datePickerView.frame.origin.y, self.frame.size.width, 43.5);
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

#pragma mark -
#pragma mark - Feature methods
- (void)setingDateInterval
{
    if (self.datePickerType == SYLJDatePickerTypeBirthdayDate) {
        [self setingBirthdayDateInterval];
    } else {
        [self setingValidityDateInterval];
    }
}

//计算X年前的日期
- (void)setingBirthdayDateInterval
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[NSDate date]];
    NSDateComponents *minimumComponents = [[NSDateComponents alloc] init];
    [minimumComponents setYear:components.year - kDateInterval];
    [minimumComponents setMonth:components.month];
    [minimumComponents setDay:components.day];
    NSDate *minimum = [calendar dateFromComponents:minimumComponents];
    
    self.datePickerView.minimumDate = minimum;
    self.datePickerView.maximumDate = [NSDate date];
}

//计算X年后的日期
- (void)setingValidityDateInterval
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[NSDate date]];
    NSDateComponents *maximumComponents = [[NSDateComponents alloc] init];
    [maximumComponents setYear:0];
    [maximumComponents setMonth:components.month];
    [maximumComponents setDay:components.day];
    NSDate *maximumDate = [calendar dateFromComponents:maximumComponents];
    
    self.datePickerView.minimumDate = [NSDate date];
    self.datePickerView.maximumDate = maximumDate;
}


#pragma mark - 懒加载

- (UIDatePicker *)datePickerView {
    if (!_datePickerView) {
        _datePickerView = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height + 44, self.frame.size.width, SHAddressPickerViewHeight)];
        _datePickerView.locale = [NSLocale localeWithLocaleIdentifier:@"zh-Hans"];
        _datePickerView.datePickerMode = UIDatePickerModeDate;
        _datePickerView.backgroundColor = [UIColor whiteColor];
    }
    return _datePickerView;
}
@end
