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
#import "NSString+Base64.h"
@implementation IAPHelperManager

+(void)buy:(NSString *)productID Id:(NSString *)ID  isProduction:(BOOL)isProduction SharedSecret:(NSString *)sharedSecret{
    
    NSLog(@"%@",[[NSBundle mainBundle] appStoreReceiptURL]);
    
    [SVProgressHUD showWithStatus:@"正在生成订单"];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [AfnManager postWithUrl:URL_PAY_ORDER param:@{@"id":ID} Sucess:^(NSDictionary *responseObject) {
        if (responseObject) {
            NSString * payOrder = OBJ(responseObject);
            [IAPHelperManager IAPBuy:productID SharedSecret:sharedSecret payOrder:payOrder isProduction:isProduction];
        }else{
            [IAPHelperManager buy:productID Id:ID  isProduction:(BOOL)isProduction  SharedSecret:sharedSecret ];
        }
    }];
}
+(void)IAPBuy:(NSString *)productID SharedSecret:(NSString *)sharedSecret payOrder:(NSString *)orderId isProduction:(BOOL)isProduction{
    
    [IAPShare sharedHelper].iap.production = NO;
    
    //    URL_PAY_SUCCESS
    NSLog(@"purchasedProducts%@",[IAPShare sharedHelper ].iap.purchasedProducts);
    if (productID ==nil || productID.length<1) {
        [SVProgressHUD showErrorWithStatus:@"商品ID不存在，稍后再试"];
        return;
    }
    productID = [productID stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    productID = [productID stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    [SVProgressHUD showWithStatus:@"正在连接App Store, 请耐心等待"];
    NSSet* dataSet = [[NSSet alloc] initWithObjects:productID, nil];
    
    [IAPShare sharedHelper].iap = [[IAPHelper alloc] initWithProductIdentifiers:dataSet];
    
    [[IAPShare sharedHelper].iap requestProductsWithCompletion:^(SKProductsRequest* request,SKProductsResponse* response)
     {
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
             
             [SVProgressHUD showWithStatus:@"正在发起支付，请耐心等待"];
             
             [[IAPShare sharedHelper].iap buyProduct:product onCompletion:^(SKPaymentTransaction* trans){
                 
                 if(trans.error)
                 {
                     NSLog(@"%@",trans.error.localizedDescription);
                     [SVProgressHUD showErrorWithStatus:trans.error.localizedDescription];
                 }
                 else if(trans.transactionState == SKPaymentTransactionStatePurchased) {
                     NSLog(@"appStoreReceiptURL%@",[[NSBundle mainBundle] appStoreReceiptURL]);
                     NSLog(@"trans%@",response);
                     
                     NSData * data = [NSData dataWithContentsOfURL:[[NSBundle mainBundle] appStoreReceiptURL]] ;
                     NSString *receiptBase64 = [NSString base64StringFromData:data length:[data length]];
                     
                     NSMutableDictionary * param = [NSMutableDictionary dictionaryWithDictionary:@{@"orderNum":orderId}];
                     if (sharedSecret){
                         [SVProgressHUD showWithStatus:@"支付成功，更新Vip状态"];
                         [param setObject:sharedSecret forKey:@"password"];
                     }else{
                         [SVProgressHUD showWithStatus:@"支付成功，正在添加您的咔咔豆"];
                     }
                     [param setObject:USER_ID forKey:@"userId"];
                     [param setObject:UUID forKey:@"uuid"];
                     [param setObject:receiptBase64 forKey:@"receiptBase64"];
                     [param setObject:isProduction ?@"https://buy.itunes.apple.com/verifyReceipt":@"https://sandbox.itunes.apple.com/verifyReceipt"  forKey:@"url"];
                     [AFHTTPSessionManager manager].requestSerializer.timeoutInterval = 60.0*10;
                     [[AFHTTPSessionManager manager] POST:URL_PAY_SUCCESS parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         if (IS_SUCCESS(responseObject)) {
                             [[SKPaymentQueue defaultQueue] finishTransaction:trans];
                             NSLog(@"SUCCESS %@",response);
                             UIAlertView * view = [[UIAlertView alloc]initWithTitle:@"支付成功，重新进我的页面查看" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                             [view show];
                             [APP_DELEGATE getUserInfo];
                         }else{
                             [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@\n请联系客服",Msg(responseObject)]];
                         }
                         
                     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         [SVProgressHUD showErrorWithStatus:error.description];
                     }];
                     [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
                     
                     
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
