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
#import <IDMPhotoBrowser.h>
#import <UIButton+WebCache.h>
@interface UserInfoViewController ()<TZImagePickerControllerDelegate>

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *userInfoLabelArr;
@property (weak, nonatomic) IBOutlet UIButton *userIconBtn;
@property (weak, nonatomic) IBOutlet UISwitch *userBuySwitch;

@property (nonatomic,strong) NSArray <NSString *>* keyArr;
@property (nonatomic,strong) NSArray <NSString *>* valueArr;
@property (nonatomic,strong)TZImagePickerController * imagePickerVc;

@property (nonatomic, strong)InformationPickerView * pickerView;
@property (nonatomic, strong)InformaitonPickerDataView * datePicker;
@end

@implementation UserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的资料";
    _keyArr = @[@"headimgurl",@"username",@"sex",@"phone",@"city"];

    [self showUserInfo];
}

-(void)showUserInfo{
    _valueArr = @[USER_MODEL.headimgurl,USER_MODEL.username,USER_MODEL.sex,USER_MODEL.phone,USER_MODEL.city];
    for (UILabel * label in _userInfoLabelArr) {
        label.text = _valueArr[label.tag];
    }
    [_userIconBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:USER_MODEL.headimgurl] forState:UIControlStateNormal];
    self.userBuySwitch.on = USER_MODEL.hobby;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [APP_DELEGATE getUserInfo];
}

- (void)sendItemAction:(UIImage *)image{
    
    
    [SVProgressHUD showProgress:0 status:@"图片上传中..."];
    [[AFHTTPSessionManager manager] POST: URL_UPLOAD_IMG  parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:UIImageJPEGRepresentation(image, 0.5) name:@"file" fileName:@"1.png" mimeType:@"image/png"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        CGFloat progress = uploadProgress.fractionCompleted;
        [SVProgressHUD showProgress:progress status:@"图片上传中..."];
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary * dic =OBJ(responseObject)[0];
        [self UserUpdataWithParam:@{@"headimgurl":[dic objectForKey:@"src"]}];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        NSLog(@"%@",error);
    }];
    
    
}
-(TZImagePickerController *)imagePickerVc{
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
        _imagePickerVc.isSelectOriginalPhoto = NO;

        _imagePickerVc.showSelectBtn =NO;
        _imagePickerVc.allowCrop =  YES;
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
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 2) {
        return 75;
    }else {
        return 0.00001;
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
        [btn addTarget: self action:@selector(logoutBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        return footerView;
    }else{
        return  [UIView new];
    }
}
-(void)showAlertWithIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row == 0) {

        UIAlertController * ac = [UIAlertController alertControllerWithTitle:nil message:@"输入新昵称" preferredStyle:UIAlertControllerStyleAlert];
        [ac addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
//            textField.placeholder = self.cellDetailTextArr[indexPath.section][indexPath.row];
        }];
        UIAlertAction * aa = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSMutableDictionary * dict = [NSMutableDictionary dictionary];
            NSString * name = [ac.textFields firstObject].text;
            NSString * checkName = [name stringByReplacingOccurrencesOfString:@" " withString:@""];
            if ([name isEqualToString:@""] || [checkName isEqualToString:@""]) {
                [SVProgressHUD showErrorWithStatus:@"名字不能为空"];
                return ;
            }
            [dict setObject:name forKey:self.keyArr[1]];
            [self UserUpdataWithParam:dict];
        }];
        UIAlertAction * aa2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
        [ac addAction:aa];
        [ac addAction:aa2];
        [self presentViewController:ac animated:YES completion:nil];
    }else  if (indexPath.row == 1){
        UIAlertController * ac = [UIAlertController alertControllerWithTitle:nil message:@"选择您的性别" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction * aa = [UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self UserUpdataWithParam:@{@"sex":@"1"}];
        }];
        UIAlertAction * aa2 = [UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self UserUpdataWithParam:@{@"sex":@"2"}];
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
    [AfnManager postUserAction:URL_SAVE_USER_INFO param:dict Sucess:^(NSDictionary *responseObject) {
        [self updateUserInfo:dict];
    }];
}
-(void)updateUserInfo:(NSDictionary * )dict{
    NSMutableDictionary * userInfo = [NSMutableDictionary dictionaryWithDictionary:USER_INFO];
    [userInfo setValuesForKeysWithDictionary:dict];
    USER_SET(userInfo);
    USER_MODEL = nil;

    [self showUserInfo];
}
- (IBAction)switchBtnClick:(UISwitch *)sender {
    [self UserUpdataWithParam:@{@"hobby":[NSString stringWithFormat:@"%d",sender.isOn]}];
}


#pragma mark- tableDelegate

- (IBAction)userIconClick:(UIButton *)sender {
  
    IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc] initWithPhotoURLs:@[USER_MODEL.headimgurl] animatedFromView:sender];
    //    browser.view.backgroundColor = [UIColor whiteColor];
    //动力使用动画效果时,你可以设置scaleImage属性,这是缩放参数,设置了后,图片就不会按照原样显示出来.
    browser.scaleImage = sender.currentImage;
    browser.displayDoneButton = NO;
    browser.displayToolbar = NO;
    browser.dismissOnTouch = YES;
    [self presentViewController:browser animated:YES completion:nil];
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.00001;
    }else {
        return 10.0;
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
- (void)logoutBtnClick:(UIButton *)sender {
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
