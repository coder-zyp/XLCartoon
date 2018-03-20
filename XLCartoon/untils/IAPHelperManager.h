//
//  IAPHelperManager.h
//  XLCartoon
//
//  Created by Amitabha on 2018/1/17.
//  Copyright © 2018年 XLCR. All rights reserved.
//

#import <Foundation/Foundation.h>
//typedef void(^IAPBlock)(NSString * text);

@interface IAPHelperManager : NSObject

+(void)buy:(NSString *)productID Id:(NSString *)ID  isProduction:(BOOL)isProduction SharedSecret:(NSString *)sharedSecret;

@end
