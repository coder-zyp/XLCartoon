//
//  shareWindow.h
//  XLCartoon
//
//  Created by Amitabha on 2018/1/10.
//  Copyright © 2018年 XLCR. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^shareWindowBlock)(NSString * text);
@interface shareWindow : UIWindow

@property (nonatomic, copy) shareWindowBlock block;
@property (nonatomic, strong) NSString * shareTitle;
@property (nonatomic, strong) NSString * shareText;
@property (nonatomic, strong) NSString * shareUrl;
@property (nonatomic, strong) NSString * shareIcon;

+ (shareWindow *)share;
- (void)show;
- (void)close;


@end
