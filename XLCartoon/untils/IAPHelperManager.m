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

@interface IAPHelperManager()<SKProductsRequestDelegate, SKPaymentTransactionObserver>
@property (nonatomic, strong) SKPaymentTransaction *currentTransaction;
@property (nonatomic, strong) NSString * sharedSecret;
@property (nonatomic, strong) NSString * orderId;
@property (nonatomic, assign) BOOL isProduction;
@property (nonatomic, strong) NSString * productId;
@property (nonatomic, strong) SKProduct * product;
@end



@implementation IAPHelperManager


#pragma mark - ================ Singleton =================

+ (instancetype)sharedManager {
    
    static IAPHelperManager *iapManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        iapManager = [IAPHelperManager new];
    });
    return iapManager;
}
-(void)buy:(NSString *)productID Id:(NSString *)ID  isProduction:(BOOL)isProduction SharedSecret:(NSString *)sharedSecret{
    for (SKPaymentTransaction *transaction in [SKPaymentQueue defaultQueue].transactions){
        if (transaction.transactionIdentifier) {
            
        }
        NSLog(@"%@,%@",transaction,transaction.transactionIdentifier);
        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    }
    
    
    [SVProgressHUD showWithStatus:@"正在生成订单"];
//    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [AfnManager postWithUrl:URL_PAY_ORDER param:@{@"id":ID} Sucess:^(NSDictionary *responseObject) {
        if (responseObject) {
            
            self.isProduction = isProduction;
            self.sharedSecret = sharedSecret;
            self.orderId = OBJ(responseObject);
            self.productId = productID;
            
            [self getProduct];
        }else{
            [self buy:productID Id:ID  isProduction:(BOOL)isProduction  SharedSecret:sharedSecret ];
        }
    }];
}

#pragma mark ==== 购买商品
- (BOOL)purchaseProduct:(SKProduct *)skProduct {
    
    if (skProduct != nil) {
        if ([SKPaymentQueue canMakePayments]) {
            SKPayment *payment = [SKPayment paymentWithProduct:skProduct];
            [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
            [[SKPaymentQueue defaultQueue] addPayment:payment];
            return YES;
        } else {
            NSLog(@"失败，用户禁止应用内付费购买.");
        }
    }
    return NO;
}

#pragma mark ==== 商品恢复
- (BOOL)restorePurchase {
    
    if ([SKPaymentQueue canMakePayments]) {
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
        return YES;
    } else {
        NSLog(@"失败,用户禁止应用内付费购买.");
    }
    return NO;
}


#pragma mark ====  刷新凭证
- (void)refreshReceipt {
    SKReceiptRefreshRequest *request = [[SKReceiptRefreshRequest alloc] init];
    request.delegate = self;
    [request start];
}

#pragma mark - ================ 刷新凭证 SKRequestDelegate =================

- (void)requestDidFinish:(SKRequest *)request {
    if ([request isKindOfClass:[SKReceiptRefreshRequest class]]) {
        NSURL *receiptUrl = [[NSBundle mainBundle] appStoreReceiptURL];
        NSData *receiptData = [NSData dataWithContentsOfURL:receiptUrl];
    }
}

#pragma mark - ================ SKPaymentTransactionObserver Delegate =================

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions {
    
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchasing: //商品添加进列表
                [SVProgressHUD showWithStatus:@"购买中，请耐心等待"];
                break;
            case SKPaymentTransactionStatePurchased://交易成功
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed://交易失败
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored://已购买过该商品
                [SVProgressHUD showErrorWithStatus:@"已购买过该商品"];
                break;
            case SKPaymentTransactionStateDeferred://交易延迟
                [SVProgressHUD showErrorWithStatus:@"交易延迟"];
                break;
            default:
                break;
        }
    }
}

#pragma mark - ================ Private Methods =================
#define USER_PAY_TRANS_SET(OBJ) [[NSUserDefaults standardUserDefaults] setObject:OBJ forKey:@"payTransaction"]
#define USER_PAY_TRANS [[NSUserDefaults standardUserDefaults] objectForKey: @"payTransaction"]

#define USER_PAY_PARAM_SET(OBJ) [[NSUserDefaults standardUserDefaults] setObject:OBJ forKey:@"payParam"]
#define USER_PAY_PARAM [[NSUserDefaults standardUserDefaults] objectForKey: @"payParam"]

- (void)completeTransaction:(SKPaymentTransaction *)transaction {

    NSData * data = [NSData dataWithContentsOfURL:[[NSBundle mainBundle] appStoreReceiptURL]] ;
    NSString *receiptBase64 = [NSString base64StringFromData:data length:[data length]];
    

    
    NSMutableDictionary * param = [NSMutableDictionary dictionaryWithDictionary:@{@"orderNum":_orderId}];
    
    [param setObject:USER_ID forKey:@"userId"];
    [param setObject:UUID forKey:@"uuid"];
    [param setObject:receiptBase64 forKey:@"receiptBase64"];
    [param setObject:transaction.transactionIdentifier forKey:@"transactionIdentifier"];
    [param setObject:_isProduction ?@"https://buy.itunes.apple.com/verifyReceipt":@"https://sandbox.itunes.apple.com/verifyReceipt"  forKey:@"url"];
    if (_sharedSecret){
        [SVProgressHUD showWithStatus:@"正在更新Vip状态"];
        [param setObject:_sharedSecret forKey:@"password"];
    }else{
        [SVProgressHUD showWithStatus:@"正在添加您的咔咔豆"];
    }
    
    [self postTransaction:transaction.transactionIdentifier param:param];
}


- (void)failedTransaction:(SKPaymentTransaction *)transaction {
    
    if (transaction.error.code != SKErrorPaymentCancelled && transaction.error.code != SKErrorUnknown) {
        [SVProgressHUD showErrorWithStatus:transaction.error.localizedDescription];
    }
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    self.currentTransaction = transaction;
}

- (void)productsRequest:(nonnull SKProductsRequest *)request didReceiveResponse:(nonnull SKProductsResponse *)response {
    
}


-(void)getProduct{
    [IAPShare sharedHelper].iap.production = _isProduction;
    IAPHelperManager * manager = [IAPHelperManager sharedManager];
    NSLog(@"purchasedProducts%@",[IAPShare sharedHelper ].iap.purchasedProducts);
    if (_productId ==nil || _productId.length<1) {
        [SVProgressHUD showErrorWithStatus:@"商品ID不存在，稍后再试"];
        return;
    }
    _productId = [_productId stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    _productId = [_productId stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    [SVProgressHUD showWithStatus:@"正在连接App Store, 请耐心等待"];
    NSSet* dataSet = [[NSSet alloc] initWithObjects:_productId, nil];
    
    [IAPShare sharedHelper].iap = [[IAPHelper alloc] initWithProductIdentifiers:dataSet];
    
    [[IAPShare sharedHelper].iap requestProductsWithCompletion:^(SKProductsRequest* request,SKProductsResponse* response)
     {
         if(response > 0 ) {
             
             if ([IAPShare sharedHelper].iap.products.count < 1) {
                 [SVProgressHUD showErrorWithStatus:@"商品不翼而飞，稍后再试"];
                 return;
             }
             for (SKProduct * item in [IAPShare sharedHelper].iap.products) {
                 if ([item.productIdentifier isEqualToString:_productId]) {
                     NSLog(@"Product id: %@" , item.productIdentifier);
                     _product = item;
                 }
             }
             if (_product == nil) {
                 [SVProgressHUD showErrorWithStatus:@"商品不翼而飞，稍后再试"];
                 return;
             }else{
                 NSLog(@"价格: %@" , manager.product.price);
                 NSLog(@"Product id: %@" , manager.product.productIdentifier);
                 
                 [SVProgressHUD showWithStatus:@"正在发起支付，请耐心等待"];
                 [manager purchaseProduct:manager.product];
             }
         }
     }];
}



+(void)checkMissTransaction{
    NSLog(@"%@,%@",USER_PAY_PARAM,USER_PAY_TRANS);
    if (USER_PAY_PARAM && USER_PAY_TRANS) {
        [[IAPHelperManager sharedManager] postTransaction:USER_PAY_TRANS param:USER_PAY_PARAM];
    }
}

-(void)postTransaction:(NSString* )transID param:(NSDictionary *)param{
    USER_PAY_PARAM_SET(param);
    USER_PAY_TRANS_SET(transID);
    [AFHTTPSessionManager manager].requestSerializer.timeoutInterval = 60.0*10;
    [[AFHTTPSessionManager manager] POST:URL_PAY_SUCCESS parameters:USER_PAY_PARAM progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (IS_SUCCESS(responseObject)) {
            for (SKPaymentTransaction * trans in [SKPaymentQueue defaultQueue].transactions) {
                if ([trans.transactionIdentifier isEqualToString:transID]) {
                    [[SKPaymentQueue defaultQueue] finishTransaction:trans];
                }
            }
            UIAlertView * view = [[UIAlertView alloc]initWithTitle:@"充值成功，重新进我的页面查看" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [view show];
            
            [APP_DELEGATE getUserInfo];
        }else{
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@\n请联系客服",Msg(responseObject)]];
        }
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"payTransaction"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"payParam"];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"服务器异常。。。\n           "];
    }];

}



@end
