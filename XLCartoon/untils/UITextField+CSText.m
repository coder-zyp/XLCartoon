//
//  UITextField+CSText.m
//  CodeSpace_iOS_Frameworks
//
//  Created by CodeSpace.
//  Copyright © CodeSpace. All rights reserved.
//

#import "UITextField+CSText.h"
#import <objc/runtime.h>

#define PlaceholderColor        kColorLineGray

@implementation UITextField (CSTextField)

#pragma mark - LeftImage
-(void)setLeftImage:(UIImage *)leftImage height:(CGFloat)height imageWidth:(CGFloat)imageWidth hgighlightedImage:(UIImage *)highlightedImage{
    UIImageView *leftIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, -10, imageWidth, imageWidth)];
    [leftIcon setImage:leftImage];
    if (highlightedImage) {
        [leftIcon setHighlightedImage:highlightedImage];
    }
    
    self.leftView = leftIcon;
    [self setLeftViewMode:UITextFieldViewModeAlways];
    [self setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [self setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
}

- (void)setLeftImage:(UIImage *)leftImage height:(CGFloat)height andInsets:(CGFloat)insets {


    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, height, height)];
    [leftView setBackgroundColor:[UIColor redColor]];//self.backgroundColor];
    self.leftView = leftView;
    [self setLeftViewMode:UITextFieldViewModeAlways];
    [self setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [self setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];

}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    self.attributedPlaceholder = [[NSMutableAttributedString alloc]initWithString:self.placeholder attributes:@{NSForegroundColorAttributeName: placeholderColor, NSFontAttributeName: self.font}];
//    [self setAttributedPlaceholder:[self getAttributePlaceholder:placeholderColor font:self.font]];
}
- (void)setPlaceholderFont:(UIFont *)placeholderFont {
    NSMutableAttributedString * aStr = [[NSMutableAttributedString alloc]initWithAttributedString: self.attributedPlaceholder];
    [aStr addAttribute:NSFontAttributeName value:placeholderFont range:NSMakeRange(0, aStr.length)];
    self.attributedPlaceholder = aStr;
}

- (NSAttributedString *)getAttributePlaceholder:(UIColor *)color font:(UIFont *)font {
    if (self.placeholder) {
        NSString *placeholder = [self.placeholder stringByAppendingString:@" "];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:placeholder attributes:@{NSForegroundColorAttributeName: color, NSFontAttributeName: font}];
//        [attributedString setAttributes:@{NSFontAttributeName: self.font} range:[placeholder rangeOfString:@" "]];
        return attributedString;
    } else {
        return [[NSMutableAttributedString alloc] init];
    }
}

//判断是否为整形：
- (BOOL)isPureInt:(NSString*)string {
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

//判断是否为浮点形：
- (BOOL)isPureFloat:(NSString*)string {
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}

static void *csLimitMaxLengthKey = &csLimitMaxLengthKey;
- (void)setCs_maxLength:(NSUInteger)cs_maxLength {
    objc_setAssociatedObject(self, csLimitMaxLengthKey, @(cs_maxLength), OBJC_ASSOCIATION_COPY);

    /**
     *  监控自身文本变化
     */
    if (cs_maxLength > 0) {
        [self addTarget:self action:@selector(_cs_valueChanged:) forControlEvents:UIControlEventAllEditingEvents];
    } else {
        [self removeTarget:self action:@selector(_cs_valueChanged:) forControlEvents:UIControlEventAllEditingEvents];
    }
}

- (NSUInteger)cs_maxLength {
    return [objc_getAssociatedObject(self, csLimitMaxLengthKey) unsignedIntegerValue];
}

- (void)_cs_valueChanged:(UITextField *)textField {
    /**
     * 在文本变化后判断文本长度是否符合需求
     */
    if (self.cs_maxLength == 0) return;
    if ([textField.text length] <= self.cs_maxLength) return;
    
    NSString *subString = [textField.text substringToIndex:self.cs_maxLength];
    dispatch_async(dispatch_get_main_queue(), ^{
        textField.text = subString;
        [textField sendActionsForControlEvents:UIControlEventEditingChanged];
    });
}

@end
