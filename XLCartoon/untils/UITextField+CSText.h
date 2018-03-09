//
//  UITextField+CSText.h
//  CodeSpace_iOS_Frameworks
//
//  Created by CodeSpace.
//  Copyright © CodeSpace. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (CSTextField)

/**
 限制输入长度
 */
@property (assign, nonatomic) NSUInteger cs_maxLength;

/**
 设置左图标

 */
-(void)setLeftImage:(UIImage *)leftImage height:(CGFloat)height imageWidth:(CGFloat)imageWidth hgighlightedImage:(UIImage *)highlightedImage;
/**
 设置占位文字颜色
 */
- (void)setPlaceholderColor:(UIColor *)placeholderColor;
/**
 设置占位文字字体
 */
- (void)setPlaceholderFont:(UIFont *)placeholderFont;

/**
 判断是否为整形：
 */
- (BOOL)isPureInt:(NSString *)string;

/**
 判断是否为浮点形：
 */
- (BOOL)isPureFloat:(NSString *)string;

@end
