//
//  UIFont+runtime.m
//  XLCartoon
//
//  Created by Amitabha on 2018/1/27.
//  Copyright © 2018年 XLCR. All rights reserved.
//

#import "UIFont+runtime.h"

@implementation UIFont (runtime)

+(CGFloat)sizeSacle{
    
    //5s 缩放为 0.853333  puls 为 1.104000
    CGFloat sacle = [UIScreen mainScreen].bounds.size.width/375;
    if (sacle<0.9) sacle = 0.9;
    if (sacle>1.1) sacle = 1.1;
    return sacle;
}

+(void)load{
    return;
    if ([UIScreen mainScreen].bounds.size.width==375) {
        return;
    }

    //系统字体的适配
    // 获取替换后的类方法
    Method newMethod = class_getClassMethod([self class], @selector(adjustFont:));
    // 获取替换前的类方法
    Method method = class_getClassMethod([self class], @selector(systemFontOfSize:));
    // 然后交换类方法，交换两个方法的IMP指针，(IMP代表了方法的具体的实现）
    method_exchangeImplementations(newMethod, method);
    
    //
    newMethod = class_getClassMethod([self class], @selector(adjustFontName:Size:));
    // 获取替换前的类方法
    method = class_getClassMethod([self class], @selector(fontWithName:size:));
    // 然后交换类方法，交换两个方法的IMP指针，(IMP代表了方法的具体的实现）
    method_exchangeImplementations(newMethod, method);
}
+ (UIFont *)adjustFont:(CGFloat)fontSize {
    UIFont *newFont = nil;
    newFont = [UIFont adjustFont:fontSize * [self sizeSacle]];
    return newFont;
}
+ (UIFont *)adjustFontName:(NSString *)fontName Size:(CGFloat)fontSize {
    UIFont *newFont = nil;
    newFont = [UIFont adjustFontName:fontName Size: fontSize * [self sizeSacle]];
    return newFont;
}

@end
