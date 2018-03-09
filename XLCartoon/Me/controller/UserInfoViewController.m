//
//  UserInfoViewController.m
//  XLCartoon
//
//  Created by Amitabha on 2018/1/11.
//  Copyright © 2018年 XLCR. All rights reserved.
//

#import "UserInfoViewController.h"
#import <TZImagePickerController.h>
#import "InformationPickerView.h"
#import "InformaitonPickerDataView.h"
#import "registerViewController.h"
@interface UserInfoViewController ()<TZImagePickerControllerDelegate>

@property (nonatomic,strong) NSArray <NSArray <NSString *>* >* cellTextArr;
@property (nonatomic,strong) NSArray <NSArray <NSString *>* >* cellDetailTextArr;
@property (nonatomic,strong) NSArray <NSArray <NSString *>* >* keyArr;
@property (nonatomic,strong)TZImagePickerController * imagePickerVc;

@property (nonatomic, strong)InformationPickerView * pickerView;
@property (nonatomic, strong)InformaitonPickerDataView * datePicker;
@property (nonatomic, strong)UISwitch * swithch;
//@property (nonatomic,strong) UIImage * headerIcon;
@end

@implementation UserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的资料";

}
-(NSArray<NSArray<NSString *> *> *)cellTextArr{
    if (_cellTextArr == nil) {
        _cellTextArr = @[@[@"头像"],
                         @[@"昵称",@"性别",@"手机"],
                         @[@"所在地",@"自动购买漫画"]];
    }
    return _cellTextArr;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
-(NSArray<NSArray<NSString *> *> *)cellDetailTextArr{
    if (_cellDetailTextArr == nil) {
        _cellDetailTextArr = @[@[@" "],
                         @[USER_MODEL.username,USER_MODEL.sex,USER_MODEL.phone],
                         @[ USER_MODEL.city,@""]
                        ];
    }
    return _cellDetailTextArr;
}
-(NSArray<NSArray<NSString *> *> *)keyArr{
    if (_keyArr == nil) {
        _keyArr = @[@[@""],
                   @[@"username",@"sex",@"phone"],
                   @[@"city-province"]];
    }
    return _keyArr;
}
- (void)sendItemAction:(UIImage *)image{
    
    
    [SVProgressHUD showProgress:0 status:@"图片上传中..."];
    [[AFHTTPSessionManager manager] POST: URL_UPLOAD_IMG  parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:UIImageJPEGRepresentation(image, 0.5) name:@"file" fileName:@"1.png" mimeType:@"image/png"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        CGFloat progress = uploadProgress.fractionCompleted;
        [SVProgressHUD showProgress:progress status:@"图片上传中..."];
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",[responseObject yy_modelToJSONString]);
        NSDictionary * dic =OBJ(responseObject)[0];
        
        [self sendCirrcleWithImgUrl:[dic objectForKey:@"src"]];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        NSLog(@"%@",error);
    }];
    
    
}
-(TZImagePickerController *)imagePickerVc{
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
        _imagePickerVc.isSelectOriginalPhoto = NO;
        _imagePickerVc.allowCrop = YES;
        _imagePickerVc.showSelectBtn =NO;
        _imagePickerVc.needCircleCrop = YES;
        _imagePickerVc.circleCropRadius = SCREEN_WIDTH/2;
    }
    return _imagePickerVc;
}
-(void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto{
    [self sendItemAction:[photos firstObject]];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
            self.imagePickerVc = nil;
            [self presentViewController:self.imagePickerVc animated:YES completion:nil];
            break;
        case 1:
            [self showAlertWithIndexPath:indexPath];
            break;
        case 2:
            if (indexPath.row == 0) [self.pickerView showPickerWithFirstRowName:nil SecondRowName:nil ThirdRowName:nil];
        default:
            break;
    }

}
-(void)showAlertWithIndexPath:(NSIndexPath *)indexPath{
    
    NSString * key = self.keyArr[indexPath.section][indexPath.row];
    
    NSString * title = [NSString stringWithFormat:@"修改%@",_cellTextArr[indexPath.section][indexPath.row]];
    
    if (indexPath.row == 0) {
        UIAlertController * ac = [UIAlertController alertControllerWithTitle:nil message:title preferredStyle:UIAlertControllerStyleAlert];
        [ac addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = self.cellDetailTextArr[indexPath.section][indexPath.row];
        }];
        UIAlertAction * aa = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSMutableDictionary * dict = [NSMutableDictionary dictionary];
            NSString * name = [ac.textFields firstObject].text;
            NSString * checkName = [name stringByReplacingOccurrencesOfString:@" " withString:@""];
            if ([name isEqualToString:@""] || [checkName isEqualToString:@""]) {
                [SVProgressHUD showErrorWithStatus:@"名字不能为空"];
                return ;
            }
            [dict setObject:name forKey:self.keyArr[indexPath.section][indexPath.row]];
            [self UserUpdataWithParam:dict];
        }];
        UIAlertAction * aa2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
        [ac addAction:aa];
        [ac addAction:aa2];
        [self presentViewController:ac animated:YES completion:nil];
    }else  if (indexPath.row == 1){
        UIAlertController * ac = [UIAlertController alertControllerWithTitle:nil message:title preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction * aa = [UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self UserUpdataWithParam:@{key:@"1"}];
        }];
        UIAlertAction * aa2 = [UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self UserUpdataWithParam:@{key:@"2"}];
        }];
        UIAlertAction * aa3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [ac addAction:aa];
        [ac addAction:aa2];
        [ac addAction:aa3];
        [self presentViewController:ac animated:YES completion:nil];
        
    }else{
        registerViewController * vc = [[registerViewController alloc]init];
        vc.viewtype = viewTypeAddPhone;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
-(void)UserUpdataWithParam:(NSDictionary *)dict{
    [SVProgressHUD show];
    NSMutableDictionary * param = [NSMutableDictionary dictionaryWithDictionary:@{@"userId":USER_ID}] ;
    [param setValuesForKeysWithDictionary:dict];
    [[AFHTTPSessionManager manager] POST: URL_SAVE_USER_INFO  parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",[responseObject yy_modelToJSONString]);
        if (responseObject) {
            [self updateUserInfo:param];
            [SVProgressHUD showSuccessWithStatus:Msg(responseObject)];
        }else{
            [SVProgressHUD showErrorWithStatus:Msg(responseObject)];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        NSLog(@"%@",error);
    }];
}
-(void)updateUserInfo:(NSDictionary * )dict{
    NSMutableDictionary * userInfo = [NSMutableDictionary dictionaryWithDictionary:USER_INFO];
    [userInfo setValuesForKeysWithDictionary:dict];
    USER_SET(userInfo);
    _cellDetailTextArr = nil;
    USER_MODEL = nil;
    NSLog(@"%@",USER_INFO);
    [self.tableView reloadData];
}
-(void)sendCirrcleWithImgUrl:(NSString *)urlStr{
    
    NSDictionary * param = @{@"userId":USER_ID,
                             @"headimgurl":urlStr,
                             @"uuid":UUID
                             };
    [[AFHTTPSessionManager manager] POST: URL_SAVE_HEAD  parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        [SVProgressHUD showWithStatus:@"正在保存"];
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
        NSLog(@"%@",[responseObject yy_modelToJSONString]);
        if (responseObject ) {
            [SVProgressHUD showSuccessWithStatus:Msg(responseObject)];
            [self updateUserInfo:param];
        }else{
            [SVProgressHUD showErrorWithStatus:Msg(responseObject)];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        NSLog(@"%@",error);
    }];
}
-(void)swithchBtnClick:(UISwitch *)switchBtn{
    [self UserUpdataWithParam:@{@"hobby":[NSString stringWithFormat:@"%d",switchBtn.isOn]}];
}
-(UISwitch *)swithch{
    if (!_swithch) {
        _swithch = [[UISwitch alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-70, 10, 49, 31)];
        [_swithch setOn:USER_MODEL.hobby];
        [_swithch addTarget:self action:@selector(swithchBtnClick:) forControlEvents:UIControlEventValueChanged];
    }
    return _swithch;
}

#pragma mark- tableDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.cellTextArr[section].count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.cellTextArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * tableViewID = @"UserInfoViewController";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:tableViewID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:tableViewID];
        cell.textLabel.font =  [UIFont systemFontOfSize:17];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:15.5];
//        cell.detailTextLabel.textColor = rgba(204,204,204,1);
        cell.detailTextLabel.numberOfLines = 0;
        
        cell.textLabel.sd_layout.leftSpaceToView(cell.contentView, 20).widthIs(120);
        
        cell.detailTextLabel.sd_layout.leftSpaceToView(cell.textLabel, 10)
        .centerYEqualToView(cell.contentView);
        
        if (indexPath.section == 2 && indexPath.row == 1) {
            cell.accessoryType=UITableViewCellAccessoryNone;
        }else{
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        }
        
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
        cell.imageView.sd_layout.rightEqualToView(cell.detailTextLabel)
        .centerYEqualToView(cell.contentView).widthIs(50).heightIs(50);
        cell.imageView.layer.cornerRadius = 25;
        cell.imageView.layer.masksToBounds = YES;
    }
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 80;
    }else{
        return 50;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.00001;
    }else {
        return 10.0;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 2) {
        UIView * footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 70)];
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"退出登录" forState:UIControlStateNormal];
        btn.backgroundColor = COLOR_Orange_Red;
        btn.layer.cornerRadius =    9;
        [footerView addSubview:btn];
        btn.sd_layout.spaceToSuperView(UIEdgeInsetsMake(15, 20, 15, 20));
        [btn addTarget: self action:@selector(logoutBtnClick) forControlEvents:UIControlEventTouchUpInside];
        return footerView;
    }else{
        return  [UIView new];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 2) {
        return 75;
    }else {
        return 0.00001;
    }
}
-(void)logoutBtnClick{
    [SVProgressHUD showSuccessWithStatus:@"已退出"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userInfo"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"LastInterTime"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    APP_DELEGATE.userModel = nil;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:NO];
        APP_DELEGATE.window.rootViewController = APP_DELEGATE.naviVC;
    });
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.textLabel.text = self.cellTextArr[indexPath.section][indexPath.row];
    cell.detailTextLabel.text = self.cellDetailTextArr[indexPath.section][indexPath.row];
    if (indexPath.section == 0) {
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:USER_MODEL.headimgurl] placeholderImage:[UIImage imageNamed:@"usericonwithlogin"]];
    }
    if (indexPath.section == 2 && indexPath.row == 1) {
        [cell addSubview:self.swithch];
    }
}

#pragma mark - 懒加载
- (InformationPickerView *)pickerView
{
    if (!_pickerView) {
        InformationPickerView * pickerView = [[InformationPickerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        pickerView.completion = ^(NSString *FirstRowName,NSString *SecondRowName,NSString *ThirdRowName) {
            
            NSString * str = ThirdRowName.length ? [NSString stringWithFormat:@"%@-%@",SecondRowName,ThirdRowName]: SecondRowName  ;
        
            [self UserUpdataWithParam:@{@"province":FirstRowName,@"city":str}];
        };
        [self.navigationController.view addSubview:pickerView];
        _pickerView = pickerView;
    }
    return _pickerView;
}

- (InformaitonPickerDataView *)datePicker
{
    if (!_datePicker) {
        InformaitonPickerDataView * datePicker = [[InformaitonPickerDataView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        datePicker.completion = ^(NSString *pickerDate) {
            [self UserUpdataWithParam:@{@"birthday":pickerDate}];
            
        };
        [self.navigationController.view addSubview:datePicker];
        _datePicker = datePicker;
    }
    return _datePicker;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
