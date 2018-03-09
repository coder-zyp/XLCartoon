//
//  ReadingEpisodeTVC.h
//  XLCartoon
//
//  Created by Amitabha on 2018/3/6.
//  Copyright © 2018年 XLCR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EpisodeModel.h"
typedef void(^SelectedBlock)(NSInteger row);

@interface ReadingEpisodeWindow : UIWindow

@property (copy, nonatomic) SelectedBlock selectedBlock;

+(shareWindow *)shareWithModels:(NSArray <EpisodeModel *> *)modelArr index:(NSInteger )index cartoon:(cartoon*)cartoon selected:(SelectedBlock)block
;

@end
