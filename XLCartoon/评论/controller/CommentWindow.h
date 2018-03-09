//
//  CommentWindow.h
//  XLCartoon
//
//  Created by Amitabha on 2017/12/22.
//  Copyright © 2017年 XLCR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SLKTextView.h>

@class CommentWindow;
typedef void(^CommentWindowBlock)(NSString * text,CommentWindow * window);

@interface CommentWindow : UIWindow

@property (nonatomic,strong) SLKTextView * textView;
@property (nonatomic,strong) NSString * title;
@property (nonatomic, copy) CommentWindowBlock block;

+ (CommentWindow *)shareWithFinshBlock:(CommentWindowBlock)block;
+ (CommentWindow *)share;
- (void)resetData;
- (void)show;
- (void)close;
@end
