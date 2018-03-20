//
//  UnlockCartoonView.h
//  XLCartoon
//
//  Created by Amitabha on 2018/1/25.
//  Copyright © 2018年 XLCR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EpisodeModel.h"

typedef void(^sucess)(void);
typedef void(^failed)(UIViewController * needPushVC);
@interface UnlockCartoonView : UIView

@property (nonatomic, strong) EpisodeModel * model;
@property (nonatomic, strong) NSString * cartoonId;


- (void)setModel:( EpisodeModel*)model sucess:(sucess)sucess failed:(failed)failed;

@end
