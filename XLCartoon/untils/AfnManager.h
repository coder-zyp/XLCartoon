//
//  AfnManager.h
//  XLCartoon
//
//  Created by Amitabha on 2018/1/16.
//  Copyright © 2018年 XLCR. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^AfnManagerBlock)(NSDictionary * responseObject);

@interface AfnManager : NSObject

+(void)postListDataUrl:(NSString *)url param:(NSDictionary *)param result:(AfnManagerBlock)block;
+(void)postWithUrl:(NSString *)url param:(NSDictionary *)param Sucess:(AfnManagerBlock)block;
//+(void)postWithUrl:(NSString *)url param:(NSDictionary *)param Sucess:(AfnManagerBlock)block;
+(void)postUserAction:(NSString *)url param:(NSDictionary *)param Sucess:(AfnManagerBlock)block;

//+(void)postUrl:(NSString *)url param:(NSDictionary *)param  showHUD:(BOOL)showHUD  onlySuccess:(BOOL)onlySuccess block:(AfnManagerBlock)block;
@end
