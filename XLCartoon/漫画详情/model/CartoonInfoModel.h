//
//  NewCaricatureModel.h
//  XLCartoon
//
//  Created by Amitabha on 2017/12/20.
//  Copyright © 2017年 XLCR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

@interface carrtoonType : BaseModel

@property (nonatomic,strong) NSString * showNum;//"<null>";
@property (nonatomic,strong) NSString * id;//1;
@property (nonatomic,strong) NSString * cartoonType;
@property (nonatomic,strong) NSString * obj;//"";
@property (nonatomic,strong) NSString * overTime;//"";
@property (nonatomic,strong) NSString * click;//"<null>";
@property (nonatomic,strong) NSString * startTime;//"";
@end

@interface cartoonTypeAll : BaseModel

@property (nonatomic,strong) carrtoonType * carrtoonType;//"<null>";

@end

@interface cartoon : BaseModel

@property (nonatomic,strong) NSString * cartoon;
@property (nonatomic,strong) NSString * cartoonAuthor;//auth;
@property (nonatomic,strong) NSString * cartoonAuthorPic;//"http://p0oqd5s9.jpg";
@property (nonatomic,strong) NSString * cartoonName;//"\U6f2b\U753b";
@property (nonatomic,strong) NSString * commentCount;//1;
@property (nonatomic,strong) NSString * firstType;//2;
@property (nonatomic,strong) NSString * followCount;//24;
@property (nonatomic,strong) NSString * hot;//1;
@property (nonatomic,strong) NSString * id;//1wC1afccBcqeUv1Sie2XzoGHBTW9wO63;
@property (nonatomic,strong) NSString * implDate;//"2017-12-18 21:06:32";
@property (nonatomic,strong) NSString * introduc;//7897897;
@property (nonatomic,strong) NSString * introduction;//"http://p0oqd5s9w.xv.jpg";
@property (nonatomic,strong) NSString * mainPhoto;//690:264
@property (nonatomic,strong) NSString * midelPhoto;//
@property (nonatomic,strong) NSString * sharePhoto;//1:1sharePhoto
@property (nonatomic,strong) NSString * obj;//"";
@property (nonatomic,strong) NSString * overTime;//"";
@property (nonatomic,strong) NSString * playCount;//0;
@property (nonatomic,assign) BOOL  serialState; //YES  连载中，NO已完结
@property (nonatomic,strong) NSString * smallPhoto;//"http://p0oqd5s9wOHzqE8N.jpg";
@property (nonatomic,strong) NSString * sort;//30;
@property (nonatomic,strong) NSString * startTime;//"";
@property (nonatomic,strong) NSString * state;//1;
@property (nonatomic,strong) NSString * updateDate;//"2017-12-20 13:41:23";
@property (nonatomic,strong) NSString * updateTile;//"\U7b2c1\U8bdd";
@property (nonatomic,strong) NSString * updateType;//1;



@end

@interface CartoonDetailModel : BaseModel
@property (nonatomic,strong) NSArray <cartoonTypeAll *> * cartoonAllType;
@property (nonatomic,strong) cartoon * cartoon;
@property (nonatomic,assign) BOOL followCartoon;
@end


