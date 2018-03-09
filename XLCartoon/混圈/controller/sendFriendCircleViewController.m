//
//  sendFriendCircleViewController.m
//  XLCartoon
//
//  Created by Amitabha on 2018/1/4.
//  Copyright © 2018年 XLCR. All rights reserved.
//

#import "sendFriendCircleViewController.h"
#import <TZImagePickerController.h>
#import <SLKTextView.h>
@interface sendFriendCircleViewController ()<TZImagePickerControllerDelegate,UITextViewDelegate,SLKTextViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) SLKTextView * textView;
@property (strong, nonatomic) UIView * btnView;
@property (nonatomic,strong)  NSArray <UIImage *> * imageArr;
@property (nonatomic,strong)  NSArray <PHAsset *> * imageAssetArr;
@property (nonatomic,strong)UILabel * wordNumberLabel;
@property (nonatomic,strong)TZImagePickerController * imagePickerVc;
@end

#define kMaxLength  500

@implementation sendFriendCircleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = COLOR_SYSTEM_GARY;
    [self.view addSubview:self.textView];
    [self.view addSubview:self.wordNumberLabel];
    _wordNumberLabel.sd_layout.rightSpaceToView(self.view, 10).heightIs(30)
    .widthIs(100).bottomEqualToView(_textView);
    [self btnView];
    self.title = @"发表混圈";
    
    UIView * whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetMaxY(self.textView.frame))];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self.view insertSubview:whiteView atIndex:0];
    
    UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithTitle:@"发布" style:UIBarButtonItemStyleDone target:self action:@selector(sendItemAction)];
    self.navigationItem.rightBarButtonItem = item;
    // Do any additional setup after loading the view.
}

- (void)sendItemAction{

    if (self.imageArr.count<1) {
        [self sendCirrcleWithImgUrl:@""];
        return;
    }
    
    [SVProgressHUD showProgress:0 status:@"图片上传中..."];
    NSMutableString * mutableUrlStr = [NSMutableString stringWithString:@""];
    [[AFHTTPSessionManager manager] POST: URL_UPLOAD_IMG  parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (UIImage * img in self.imageArr) {
            [formData appendPartWithFileData:UIImageJPEGRepresentation(img, 0.5) name:@"file" fileName:@"1.png" mimeType:@"image/png"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        CGFloat progress = uploadProgress.fractionCompleted;
        [SVProgressHUD showProgress:progress status:@"图片上传中..."];
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        for (NSDictionary * dic in OBJ(responseObject)) {
            [mutableUrlStr appendString:[dic objectForKey:@"src"]];
            [mutableUrlStr appendString:@","];
            [mutableUrlStr appendString:[dic objectForKey:@"w"]];
            [mutableUrlStr appendString:@","];
            [mutableUrlStr appendString:[dic objectForKey:@"h"]];
            [mutableUrlStr appendString:@"|"];
        }
        [self sendCirrcleWithImgUrl:[mutableUrlStr substringToIndex:mutableUrlStr.length-1]];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        NSLog(@"%@",error);
    }];
    
    
}
-(void)sendCirrcleWithImgUrl:(NSString *)urlStr{
    NSDictionary * param = @{@"releaseInfo":self.textView.text,
                             @"condition":urlStr
                             };
    [AfnManager postUserAction:URL_FRIEND_SEND_NEW param:param Sucess:^(NSDictionary *responseObject) {
        [SVProgressHUD showSuccessWithStatus:Msg(responseObject)];
        [self.navigationController popViewControllerAnimated:YES];
        self.block();
    }];
}
- (void)openImagePickerVC{
//    _imagePickerVc.selectedAssets = self.imageArr;
    [self presentViewController:self.imagePickerVc animated:YES completion:nil];
}
-(void)previewImageBtnClick:(UIButton *)btn{
    NSMutableArray * arr = [NSMutableArray arrayWithArray:self.imageArr];
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithSelectedAssets:[NSMutableArray arrayWithArray:_imageAssetArr] selectedPhotos:arr index:btn.tag];
    imagePickerVc.maxImagesCount = 9;
    imagePickerVc.isSelectOriginalPhoto = NO;
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        [_btnView removeFromSuperview];
        _btnView = nil;
        self.imageArr = photos;
        self.imageAssetArr = assets;
        [self btnView];
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}
-(void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto{
    [_btnView removeFromSuperview];
    _imageAssetArr = assets;
    _btnView = nil;
    self.imageArr = photos;
    [self btnView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(TZImagePickerController *)imagePickerVc{
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
        _imagePickerVc.isSelectOriginalPhoto = NO;
    }
    return _imagePickerVc;
}
-(UIView *)btnView{
    if (_btnView == nil) {
        _btnView = [[UIView alloc]init];
        _btnView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_btnView];
        _btnView.sd_layout.topSpaceToView(self.textView, 7).widthIs(SCREEN_WIDTH).leftEqualToView(self.view);
        for (int i =0; i<self.imageArr.count+1; i++) {
            UIButton * btn = [[UIButton alloc]init];
            [_btnView addSubview:btn];
            btn.sd_layout.heightEqualToWidth();
            if (i<self.imageArr.count) {
                [btn setImage:self.imageArr[i] forState:UIControlStateNormal];
                btn.tag = i;
                [btn addTarget:self action:@selector(previewImageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            }else {
                [btn setImage:[UIImage imageNamed:@"AlbumAddBtn"] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(openImagePickerVC) forControlEvents:UIControlEventTouchUpInside];
            }
            UIImageView * imageView = btn.imageView;
            imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
            [imageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
            imageView.clipsToBounds = YES;
        }
        [_btnView setupAutoWidthFlowItems:_btnView.subviews withPerRowItemsCount:4 verticalMargin:10 horizontalMargin:10 verticalEdgeInset:15 horizontalEdgeInset:15];
    }
    return _btnView;
}
- (SLKTextView *)textView{
    if (_textView == nil) {
        _textView = [[SLKTextView alloc]init];
        _textView.frame = CGRectMake(15, 10, SCREEN_WIDTH-30, SCREEN_WIDTH/2.3);
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.placeholder = @"说点啥~";
        _textView.placeholderFont = [UIFont systemFontOfSize:16];
        _textView.delegate = self;
        _textView.font = [UIFont systemFontOfSize:16];
        
    }
    return _textView;
}
- (UILabel *)wordNumberLabel
{
    if (!_wordNumberLabel) {
        UILabel * wordNumberLabel = [[UILabel alloc] init];
        wordNumberLabel.text = [NSString stringWithFormat:@"%d",kMaxLength];
        wordNumberLabel.textAlignment = NSTextAlignmentRight;
        wordNumberLabel.textColor = [UIColor orangeColor];
        wordNumberLabel.font = [UIFont systemFontOfSize:13.f];
        _wordNumberLabel = wordNumberLabel;
    }
    return _wordNumberLabel;
}
#pragma mark - textViewDelegate

- (void)textViewDidChange:(UITextView *)textView
{
    NSString *toBeString = textView.text;
    NSString *lang = [(UITextInputMode*)[[UITextInputMode activeInputModes] firstObject] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textView markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length >= kMaxLength) {
                textView.text = [toBeString substringToIndex:kMaxLength];
            }
            _wordNumberLabel.text = [NSString stringWithFormat:@"%lu",kMaxLength-[textView.text length]];
            
        } // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length >= kMaxLength) {
            textView.text = [toBeString substringToIndex:kMaxLength];
        }
        _wordNumberLabel.text = [NSString stringWithFormat:@"%lu",kMaxLength-[textView.text length]];
    }
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
