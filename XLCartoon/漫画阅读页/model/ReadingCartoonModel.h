//
//  ReadingCartoonModel.h
//  XLCartoon
//
//  Created by Amitabha on 2017/12/27.
//  Copyright © 2017年 XLCR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "commentModel.h"
#import "EpisodeModel.h"


@interface ReadingCartoonSpare : NSObject

@property (nonatomic,strong) NSString * followCartoon;//1,
@property (nonatomic,assign) BOOL veryOk;//"7Q9UoVj6KQcBJSs283cSG1k0GCkT2tqD",
@property (nonatomic,strong) NSString * titile;//"",
@property (nonatomic,strong) NSString * cartoonSetId;


@property (nonatomic,strong) NSString * oldprice;//所需积分
@property (nonatomic,strong) NSString * price;//所需积分
@property (nonatomic,strong) NSString * integral;//我的积分":2
@end

@interface PhotoModel : NSObject

@property (nonatomic,strong) NSString * id;
@property (nonatomic,strong) NSString * src;//"http://p0oqd5s9w.b4342776123@qinruida-dz0FIDM6.jpg",
@property (nonatomic,assign) CGFloat    w;//null,
@property (nonatomic,assign) CGFloat    h;//null"http://p0oqd5s342776123@qinruida-
//@property (nonatomic,strong) UIImage  * image;

@end
@class EpisodeModel;
@interface ReadingCartoonModel : NSObject


@property (nonatomic,assign) CGFloat heightTotal;
@property (nonatomic,strong) NSArray <PhotoModel *> * photos;
@property (nonatomic,strong) ReadingCartoonSpare * spare;
@property (nonatomic,strong) NSArray < commentModel *> * commentModel;
@property (nonatomic,strong) EpisodeModel * episodeModel;


@end


