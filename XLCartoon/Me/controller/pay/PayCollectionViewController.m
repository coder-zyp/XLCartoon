//
//  PayCollectionViewController.m
//  XLCartoon
//
//  Created by Amitabha on 2018/2/12.
//  Copyright © 2018年 XLCR. All rights reserved.
//

#import "PayCollectionViewController.h"
#import "PayKakaCell.h"
#import <YYText.h>
#import "IAPHelperManager.h"
@interface PayCollectionViewController ()
@property (nonatomic,strong) NSMutableArray <PayProductModel *>* modelArr;
@property (nonatomic,strong) UICollectionViewFlowLayout *layout ;
@property (nonatomic,strong) UIView * footerView;
@property (nonatomic,assign) NSInteger selectRowIndex;
@end



@implementation PayCollectionViewController

static NSString * const reuseIdentifier = @"PayCollectionViewControllerCell";

- (instancetype)init
{
    self = [super init];
    if (self) {
        CGFloat w = (SCREEN_WIDTH-45)/2;
        CGFloat h = 80;
        self.layout = [[UICollectionViewFlowLayout alloc] init];
        self.layout.itemSize = CGSizeMake( w,h);
        self.layout.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
        //        layout.minimumInteritemSpacing = 15;
        //        layout.minimumLineSpacing = 15;
        self.layout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH*230/750.0);
        self.layout.footerReferenceSize = CGSizeMake(SCREEN_WIDTH, CGRectGetMaxY(self.footerView.frame));
        self.modelArr = [NSMutableArray array];
        return [self initWithCollectionViewLayout:self.layout];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"充值";
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"PayKakaCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:reuseIdentifier];
    
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];  //  一定要设置
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView"];
    [self getData];
}
-(void)getData{
    [SVProgressHUD show];//type vip，102，咔咔豆 101
    NSDictionary * param =@{@"type":@"101"};
    [AfnManager postListDataUrl:URL_PAY_PRODUCTS param:param result:^(NSDictionary *responseObject) {
        NSLog(@"%@",responseObject);
        for (NSDictionary * dict in OBJ(responseObject)) {
            [self.modelArr addObject:[PayProductModel mj_objectWithKeyValues:dict]];
        }
        [self.collectionView reloadData];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark <UICollectionViewDataSource>



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.modelArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PayKakaCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    ((PayKakaCell *)cell).model = self.modelArr[indexPath.row];
    if (self.modelArr[indexPath.row].hot) {
        _selectRowIndex = indexPath.row;
    }
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    for (NSInteger i = 0; i<self.modelArr.count; i++) {
        UICollectionViewCell * cell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        if (i== indexPath.row) {
            cell.layer.borderColor = [UIColor redColor].CGColor;
            _selectRowIndex = indexPath.row;
        }else{
            cell.layer.borderColor = [UIColor clearColor].CGColor;
            _selectRowIndex = indexPath.row;
        }
    }
}

//这个也是最重要的方法 获取Header的 方法。
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    if (kind == UICollectionElementKindSectionHeader) {
        static NSString *CellIdentifier = @"HeaderView";
        UICollectionReusableView * HeaderCell = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:CellIdentifier forIndexPath:indexPath];
        //从缓存中获取 Headercell
        if (self.modelArr.count) {
            UIImageView * imageView = [[UIImageView alloc]init];
            [imageView sd_setImageWithURL:[NSURL URLWithString:self.modelArr[0].photo] placeholderImage:Z_PlaceholderImg];
            imageView.frame = HeaderCell.bounds;
            [HeaderCell addSubview:imageView];
            HeaderCell.backgroundColor= [UIColor redColor];
        }
        
        return HeaderCell;
    }else{
        static NSString *CellIdentifier = @"FooterView";
        UICollectionReusableView * FooterCell = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:CellIdentifier forIndexPath:indexPath];
        
        if (self.modelArr.count) {
            
            [FooterCell addSubview:self.footerView];
        }
        
        return FooterCell;
    }
    
}
-(void)payBtnClick:(UIButton *)btn{
    
    
    NSLog(@"%ld",self.selectRowIndex);
    PayProductModel * model = self.modelArr[self.selectRowIndex];
    [IAPHelperManager buy:model.productId Id:model.id isProduction:model.introduction SharedSecret:nil];
    
}
-(UIView *)footerView{
    if (_footerView == nil) {
        _footerView = [UIView new];
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle: @"确认充值" forState:UIControlStateNormal];
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
        
        
        NSString * string = @"温馨提示：\n1.您在iOS上的咔咔豆，在非iOS终端上不能使用。\n2.您需要通过AppStore充值点劵。\n3.咔咔豆为虚拟商品，兑换比例为1元兑换100，仅限本书城使用，一经购买不得退换。为了保证您的合法权益，请使用咔咔漫画app购买咔咔豆。\n4.请勿短时间内多次购买同一商品！购买后，账户余额若长时间无变化，请记录好您的账户后联系客服\n5.客服电话：";
        
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
        lable.frame = CGRectMake(10, CGRectGetMaxY(btn.frame)+15, SCREEN_WIDTH-20, layout.textBoundingSize.height);
        _footerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetMaxY(lable.frame)+10);
    }
    return _footerView;
}



#pragma mark <UICollectionViewDelegate>



/*
 // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
 return NO;
 }
 
 - (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
 return NO;
 }
 
 - (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
 
 }
 */

@end

