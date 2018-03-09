//
//  registerViewController.h
//  XLCartoon
//
//  Created by Amitabha on 2018/1/15.
//  Copyright © 2018年 XLCR. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, RegisterViewType) {
    viewTypeRegister,
    viewTypeFindPassword,
    viewTypeAddPhone
};
@interface registerViewController : UIViewController

@property (nonatomic,assign) RegisterViewType viewtype;

@end
