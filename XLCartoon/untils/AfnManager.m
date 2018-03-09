//
//  AfnManager.m
//  XLCartoon
//
//  Created by Amitabha on 2018/1/16.
//  Copyright © 2018年 XLCR. All rights reserved.
//

#import "AfnManager.h"

@implementation AfnManager

+(AFHTTPSessionManager *)manager{
    

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    // 设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 1800.0;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    return manager;
}


+(void)postUserAction:(NSString *)url param:(NSDictionary *)param Sucess:(AfnManagerBlock)block{
    [SVProgressHUD show];
    [AfnManager postUrl:url param:param haveHUD:YES onlySuccess:YES userAction:NO block:block];
}
+(void)postWithUrl:(NSString *)url param:(NSDictionary *)param Sucess:(AfnManagerBlock)block{
    [AfnManager postUrl:url param:param haveHUD:NO onlySuccess:YES userAction:NO block:block];
}
+(void)postListDataUrl:(NSString *)url param:(NSDictionary *)param result:(AfnManagerBlock)block{
    [AfnManager postUrl:url param:param haveHUD:NO onlySuccess:NO userAction:NO block:block];
}
+(void)postUrl:(NSString *)url param:(NSDictionary *)param  haveHUD:(BOOL)haveHUD  onlySuccess:(BOOL)onlySuccess userAction:(BOOL)action block:(AfnManagerBlock)block{
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithDictionary:param];
    
    if(USER_ID)[dict setObject:USER_ID forKey:@"userId"];
    [dict setObject:UUID forKey:@"uuid"];
    
    NSLog(@"%@",url);
    if (action) [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [[AfnManager manager] POST: url  parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (REQ_ERROR(responseObject) == 700 ){
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:nil message:@"您在账号已在其他iOS设备上登录，若非本人操作，建议您及时更换账号密码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
//            [SVProgressHUD showSuccessWithStatus:@"账号已在其他设备上登录"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userInfo"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"LastInterTime"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            APP_DELEGATE.userModel = nil;
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                APP_DELEGATE.window.rootViewController = APP_DELEGATE.naviVC;
            });
            return;
        }
        NSLog(@"\n\n****************************\n%@",[responseObject yy_modelToJSONString]);
        if (IS_SUCCESS(responseObject) ) {
            
            [SVProgressHUD dismiss];
            if (haveHUD) [SVProgressHUD showSuccessWithStatus:Msg(responseObject)];
            if (action) [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
            block(responseObject);
            
        }else{
            if (!onlySuccess)block(nil);
            [SVProgressHUD showErrorWithStatus:Msg(responseObject)];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (!onlySuccess)block(nil);
        if (action) [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
        [SVProgressHUD dismiss];
        NSLog(@"%@:%@",url,error);
        if (error.code == -1009) {
            [SVProgressHUD showErrorWithStatus:@"当前网络不可用"];
        }
    }];
}

@end
