//
//  shareWindow.h
//  XLCartoon
//
//  Created by Amitabha on 2018/1/10.
//  Copyright © 2018年 XLCR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CartoonInfoModel.h"

typedef NS_ENUM(NSUInteger, shareState) {
    shareState_None,
    shareState_NoResult,
    shareState_Success,
    shareState_Fail
};

typedef void(^shareSucessBlock)(void);


@interface shareWindow : UIWindow

@property (assign, nonatomic) shareState shareState;
@property (copy, nonatomic) shareSucessBlock sucessBlock;

+(shareWindow *)shareWithModel:(cartoon *)model cartoonSetId:(NSString *)cartoonSetId sucess:(shareSucessBlock)sucess;
+(shareWindow *)shareWithModel:(cartoon *)model cartoonSetId:(NSString *)cartoonSetId;
+ (shareWindow *)share;
+ (void)shareSuccess;




@end
