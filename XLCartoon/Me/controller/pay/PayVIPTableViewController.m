//
//  PayVIPTableViewController.m
//  XLCartoon
//
//  Created by Amitabha on 2018/1/29.
//  Copyright © 2018年 XLCR. All rights reserved.
//

#import "PayVIPTableViewController.h"
#import "PayProductModel.h"
#import "IAPHelperManager.h"
//#import "UserInfoCell.h"
#import <YYText.h>
#import "PayHistoryTableViewController.h"
@interface PayVIPTableViewController ()
@property (nonatomic,strong) NSMutableArray <PayProductModel *>* modelArr;
@property (nonatomic,strong) UIView  * footerView;
@end

@implementation PayVIPTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    self.tableView.tableFooterView = self.footerView;
    [self.footerView layoutSubviews];
    self.tableView.tableFooterView = self.footerView;
    self.title = @"开通包月";
    
    _modelArr = [NSMutableArray array];
    [self getData];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"充值记录" style:UIBarButtonItemStyleDone target:self action:@selector(pushToHistoryVC)];
}
-(void)pushToHistoryVC{
    [self.navigationController pushViewController:[PayHistoryTableViewController new] animated:YES];
}
-(void)getData{
    [super getData];
    [SVProgressHUD show];//type vip，102，咔咔豆 101
    NSDictionary * param =@{@"type":@"102"};
    [AfnManager postListDataUrl:URL_PAY_PRODUCTS param:param result:^(NSDictionary *responseObject) {
        NSLog(@"%@",responseObject);
        for (NSDictionary * dict in OBJ(responseObject)) {
            [self.modelArr addObject:[PayProductModel mj_objectWithKeyValues:dict]];
        }
        [self.tableView reloadData];
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1] animated:YES scrollPosition:UITableViewScrollPositionNone];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark- Action

-(void)payBtnClick:(UIButton *)btn{
    NSInteger index = self.tableView.indexPathForSelectedRow.row;
    PayProductModel * model = _modelArr[index];
    IAPHelperManager * manager = [IAPHelperManager sharedManager];
    [manager buy:model.productId Id:model.id isProduction:model.introduction SharedSecret:@"e11babd29cb44146b8529f34478f59df"];
    
    
}
-(void)successedWithReceipt:(SKPaymentTransaction *)transaction param:(NSDictionary *)param{
    SKPaymentTransaction * trans =transaction;
    if(trans.error)
    {
        NSLog(@"%@",trans.error.localizedDescription);
        [SVProgressHUD showErrorWithStatus:trans.error.localizedDescription];
    }
    else if(trans.transactionState == SKPaymentTransactionStatePurchased) {
        
        [AFHTTPSessionManager manager].requestSerializer.timeoutInterval = 60.0*10;
        [[AFHTTPSessionManager manager] POST:URL_PAY_SUCCESS parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (IS_SUCCESS(responseObject)) {
                [[SKPaymentQueue defaultQueue] finishTransaction:trans];
                UIAlertView * view = [[UIAlertView alloc]initWithTitle:@"支付成功，重新进我的页面查看" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [view show];
                
                [APP_DELEGATE getUserInfo];
            }else{
                [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@\n请联系客服",Msg(responseObject)]];
            }
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"payTransaction"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"payParam"];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:error.description];
        }];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    }
    else if(trans.transactionState == SKPaymentTransactionStateFailed) {
        NSLog(@"%@",trans.error.localizedDescription);
        [SVProgressHUD showErrorWithStatus:@"SKPaymentTransactionStateFailed"];
    }else{
        [SVProgressHUD showErrorWithStatus:@"位置错误"];
    }
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (self.modelArr.count) {
        return 2;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section) {
        return self.modelArr.count;
    }
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"payTableViewCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"payTableViewCell"];
        
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
        cell.detailTextLabel.textColor = [UIColor grayColor];
        cell.detailTextLabel.sd_layout.topSpaceToView(cell.textLabel, 8);
        
        UILabel * label = [UILabel new];
        label.tag = 100;
        [cell.contentView addSubview:label];
        label.layer.masksToBounds = YES;
        label.textAlignment = NSTextAlignmentCenter;
        label.layer.cornerRadius = 15;
        label.font = [UIFont systemFontOfSize:15];
        label.layer.borderWidth = 1;
        
        label.layer.borderColor = COLOR_BUTTON.CGColor;
        label.sd_layout.rightSpaceToView(cell.contentView, 10).
        widthIs(60).heightIs(30).centerYEqualToView(cell.contentView);
        
        
        UIImageView * headImageView = [[UIImageView alloc]init];
        [cell addSubview:headImageView];
        headImageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH*230/750.0);
        headImageView.tag = 101;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UILabel * label = [cell viewWithTag:100];
    UIImageView * headImageView = [cell viewWithTag:101];
    if (indexPath.section == 0) {
        if (self.modelArr.count) {
            [headImageView sd_setImageWithURL:[NSURL URLWithString:self.modelArr[0].photo] placeholderImage:Z_PlaceholderImg];
        }
        headImageView.hidden = NO;
    }else{
        PayProductModel * model = [self.modelArr objectAtIndex:indexPath.row];
        headImageView.hidden = YES;
        headImageView.image = nil;
        cell.imageView.frame = CGRectZero;
        
        label.text = [NSString stringWithFormat:@"%.0f元",model.price];
        if (cell.isSelected) {
            label.backgroundColor = COLOR_BUTTON;
            label.textColor = [UIColor whiteColor];
            cell.textLabel.textColor = COLOR_BUTTON;
        }else{
            label.backgroundColor = [UIColor whiteColor];
            label.textColor = COLOR_BUTTON;
            cell.textLabel.textColor = [UIColor blackColor];
        }
        
        cell.textLabel.text = model.name;
        if (model.introduc.length) {
            cell.detailTextLabel.text = model.introduc;
        }
    }
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 8;
    }else{
        return 0.0001;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return SCREEN_WIDTH*230/750.0;
    }else{
        return 60;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView reloadData];
    [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
}
-(UIView *)footerView{
    if (!_footerView) {
        _footerView = [UIView new];
        
        UIView * line = [UIView new];
        line.backgroundColor = COLOR_LIGHT_GARY;
        [_footerView addSubview:line];
        line.sd_layout.xIs(0).yIs(0).rightEqualToView(_footerView).heightIs(1);
        
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle: @"开通包月" forState:UIControlStateNormal];
        btn.backgroundColor = COLOR_BUTTON;
        [btn addTarget: self action:@selector(payBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [_footerView addSubview:btn];
        CGFloat width = SCREEN_WIDTH*0.6;
        CGFloat height = 50;
        btn.layer.cornerRadius = height/2.0;
        btn.frame = CGRectMake((SCREEN_WIDTH-width)/2, 15, width, height);
        
        YYLabel * lable = [[YYLabel alloc]init];
        
        [_footerView addSubview:lable];
        lable.numberOfLines = 0;
        lable.font = [UIFont systemFontOfSize:14];
        
        
        NSString * string = @"温馨提示：\n1.此账号在非iOS终端上不能使用。\n2.您需要通过AppStore充值VIP。\n3.VIP为虚拟商品，仅限本书城使用，一经购买不得退换。\n4.请勿短时间内多次支付！购买后可在个人中心查看状态和到期时间，若VIP状态长时间无变化，请联系客服。\n5.客服电话：";
        
        NSMutableAttributedString * aStr = [[NSMutableAttributedString alloc]initWithString:string];
        
        NSMutableString * telStr = [NSMutableString stringWithString:CustomerService_Phone]  ;
        NSString * wxstr = @"，微信："CustomerService_Wechat;
        
        [aStr appendAttributedString:[[NSAttributedString alloc]initWithString:telStr ]];
        [aStr appendAttributedString:[[NSAttributedString alloc]initWithString:wxstr  ]];
        aStr.yy_color = RGB(88, 88, 88);
        
        [aStr yy_setTextHighlightRange:NSMakeRange(string.length, telStr.length)
                                 color:[UIColor blueColor]
                       backgroundColor:[UIColor clearColor]
                             tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect){
                                 //ios 11 以下没有拨号提示 直接拨号
                                 if (![telStr hasPrefix:@"Tel:"]) {
                                     [telStr insertString:@"Tel:" atIndex:0];
                                 }
                                 
                                 if (@available(iOS 11.0, *)) {
                                     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telStr]];
                                 }else{
                                     UIAlertController * alertController = [UIAlertController alertControllerWithTitle:telStr message:nil preferredStyle:UIAlertControllerStyleAlert];
                                     UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                                     UIAlertAction * callAction = [UIAlertAction actionWithTitle:@"呼叫" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telStr]];
                                     }];
                                     [alertController addAction:callAction];
                                     [alertController addAction:cancelAction];
                                     [self presentViewController:alertController animated:YES completion:nil];
                                 }
                                 
                             }];
        [aStr yy_setTextHighlightRange:NSMakeRange(aStr.length-wxstr.length+4, wxstr.length-4) color:[UIColor blueColor] backgroundColor:COLOR_LIGHT_GARY tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            [SVProgressHUD showSuccessWithStatus:@"复制成功!"];
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = @"WX13066798436";
        }];
        //        aStr.yy_font = lable.font;
        
        lable.attributedText = aStr;
        YYTextLayout * layout = [YYTextLayout layoutWithContainerSize:CGSizeMake(SCREEN_WIDTH-20, MAXFLOAT) text:aStr];
        lable.textLayout = layout;
        lable.sd_layout.leftSpaceToView(_footerView, 10).topSpaceToView(btn, 15).
        rightSpaceToView(_footerView, 10).heightIs(layout.textBoundingSize.height);
        
        [_footerView setupAutoHeightWithBottomView:lable bottomMargin:10];
        [_footerView layoutSubviews];
    }
    return _footerView;
}
@end

