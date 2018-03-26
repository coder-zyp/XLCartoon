//
//  IAPHelperManager.h
//  XLCartoon
//
//  Created by Amitabha on 2018/1/17.
//  Copyright © 2018年 XLCR. All rights reserved.
//

#import <Foundation/Foundation.h>
//typedef void(^IAPBlock)(NSString * text);
#import <StoreKit/StoreKit.h>


@interface IAPHelperManager : NSObject
+ (instancetype)sharedManager;
-(void)buy:(NSString *)productID Id:(NSString *)ID  isProduction:(BOOL)isProduction SharedSecret:(NSString *)sharedSecret;
+(void)checkMissTransaction;

@end
