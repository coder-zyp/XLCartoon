//
//  FindPasswordViewController.h
//  test
//
//  Created by Amitabha on 2017/9/30.
//  Copyright © 2017年 张允鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, FindPwdSegmentButtonIndex) {
    FindPwdSegmentButtonIndex_FindPwd = 0,  //注册
    FindPwdSegmentButtonIndex_FindPwdVerificationCode,  //获取注册验证码
};

@interface FindPasswordViewController : UIViewController

@end
