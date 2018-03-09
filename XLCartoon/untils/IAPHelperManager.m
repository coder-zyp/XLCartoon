//
//  IAPHelperManager.m
//  XLCartoon
//
//  Created by Amitabha on 2018/1/17.
//  Copyright © 2018年 XLCR. All rights reserved.
//

#import "IAPHelperManager.h"
#import <IAPHelper/IAPHelper.h>
#import <IAPHelper/IAPShare.h>
@implementation IAPHelperManager


+(void)buy:(NSString *)productID isProduction:(BOOL)isProduction SharedSecret:(NSString *)sharedSecret sucess:(void (^)(void))sucess{
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [IAPShare sharedHelper].iap.production = isProduction;
    //    [IAPShare sharedHelper].iap.production = YES;
    
    //    [[IAPShare sharedHelper].iap clearSavedPurchasedProducts];
    
    NSLog(@"purchasedProducts%@",[IAPShare sharedHelper ].iap.purchasedProducts);
    if (productID ==nil || productID.length<1) {
        [SVProgressHUD showErrorWithStatus:@"商品不翼而飞，稍后再试"];
        return;
    }
    productID = [productID stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    productID = [productID stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    [SVProgressHUD showWithStatus:@"正在连接App Store, 请耐心等待"];
    NSSet* dataSet = [[NSSet alloc] initWithObjects:productID, nil];
    
    [IAPShare sharedHelper].iap = [[IAPHelper alloc] initWithProductIdentifiers:dataSet];
    
    [[IAPShare sharedHelper].iap requestProductsWithCompletion:^(SKProductsRequest* request,SKProductsResponse* response)
     {
         //         NSLog(@"response.description%@",response.description);
         NSLog(@"%ld",[IAPShare sharedHelper].iap.products.count);
         
         if(response > 0 ) {
             
             if ([IAPShare sharedHelper].iap.products.count < 1) {
                 [SVProgressHUD showErrorWithStatus:@"商品不翼而飞，稍后再试"];
                 return;
             }
             SKProduct* product;// =[[IAPShare sharedHelper].iap.products objectAtIndex:0];
             for (SKProduct * item in [IAPShare sharedHelper].iap.products) {
                 if ([item.productIdentifier isEqualToString:productID]) {
                     NSLog(@"Product id: %@" , item.productIdentifier);
                     product = item;
                 }
             }
             if (product == nil) {
                 [SVProgressHUD showErrorWithStatus:@"商品不翼而飞，稍后再试"];
                 return;
             }
             NSLog(@"价格: %@" , product.price);
             NSLog(@"Product id: %@" , product.productIdentifier);
             
             [SVProgressHUD showWithStatus:@"支付中，请耐心等待"];
             [[IAPShare sharedHelper].iap buyProduct:product onCompletion:^(SKPaymentTransaction* trans){
                 [SVProgressHUD dismiss];
                 if(trans.error)
                 {
                     NSLog(@"%@",trans.error.localizedDescription);
                     [SVProgressHUD showErrorWithStatus:trans.error.localizedDescription];
                 }
                 else if(trans.transactionState == SKPaymentTransactionStatePurchased) {
                     NSLog(@"appStoreReceiptURL%@",[[NSBundle mainBundle] appStoreReceiptURL]);
                     NSLog(@"trans%@",response);
                     
                     [SVProgressHUD showWithStatus:@"支付成功，正在添加您的咔咔豆"];
                     // 这个 receipt 就是内购成功 苹果返回的收据
                     [[IAPShare sharedHelper].iap checkReceipt:[NSData dataWithContentsOfURL:[[NSBundle mainBundle] appStoreReceiptURL]] AndSharedSecret:sharedSecret onCompletion:^(NSString *response, NSError *error) {
                         
                         //Convert JSON String to NSDictionary
                         NSDictionary* rec = [IAPShare toJSON:response];
                         
                         if([rec[@"status"] integerValue]==0)
                         {
                             sucess();
                             [[IAPShare sharedHelper].iap provideContentWithTransaction:trans];
                             NSLog(@"SUCCESS %@",response);
                             
                             NSLog(@"Pruchases %@",[IAPShare sharedHelper].iap.purchasedProducts);
                         }
                         else {
                             NSLog(@"Fail");
                         }
                     }];
                 }
                 else if(trans.transactionState == SKPaymentTransactionStateFailed) {
                     NSLog(@"%@",trans.error.localizedDescription);
                     [SVProgressHUD showErrorWithStatus:trans.error.localizedDescription];
                 }
             }];//end of buy product
         }
     }];
}


@end

