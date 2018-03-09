//
//  CaricatureDetailViewController.m
//  XLGame
//
//  Created by Amitabha on 2017/12/11.
//  Copyright © 2017年 In.于楚天. All rights reserved.
//

#import "CaricatureDetailViewController.h"
#import "ReadingCartoonTVC1.h"
#import "EpisodeTableViewController.h"
#import "CommentTabelViewController.h"
#import "MJRefresh.h"
#import "WRNavigationBar.h"
#import "EpisodeModel.h"
#import "shareWindow.h"
#import <YYText.h>

//static CGFloat const headViewHeight = 200.0;
//static CGFloat headViewHeight =([UIScreen mainScreen].bounds.size.width * 284.5/375.0);

#define ImageHeight (SCREEN_WIDTH*0.59)//ok
#define headViewHeight  (ImageHeight-NaviHeight)
//static CGFloat const headViewHeight = 200.0;
NSString *const ZJParentTableViewDidLeaveFromTopNotification = @"ZJParentTableViewDidLeaveFromTopNotification";

@interface ZJCustomGestureTableView : UITableView

@end

@implementation ZJCustomGestureTableView

/// 返回YES同时识别多个手势
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]];
}
@end

@interface CaricatureDetailViewController ()<ZJPageViewControllerDelegate ,UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource,UINavigationControllerDelegate>
@property (strong, nonatomic) UIView *containerView;

@property (strong, nonatomic) UIView *  headImageView;
@property (strong, nonatomic) UIView *headView;
@property (nonatomic,assign) BOOL isReading;
@property (strong, nonatomic) UIView *bottomView;
@property (strong, nonatomic) UIScrollView *childScrollView;
@property (strong, nonatomic) ZJCustomGestureTableView *tableView;
@property (nonatomic,strong) UIView * CaricatureInfoView;
@property (nonatomic,strong) UIVisualEffectView * visualEffectView;//毛玻璃
@property (nonatomic,strong) NSMutableArray <UIButton *> * rightItmes;
@property (nonatomic,strong) EpisodeModel * episodeModel;//
@property (nonatomic,strong) CartoonDetailModel * model;

@end

static NSString * const cellID = @"cellID";
@implementation CaricatureDetailViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.menuViewStyle  = WMMenuViewStyleLine;
        /** 是否自动通过字符串计算 MenuItem 的宽度，默认为 NO. */
        self.automaticallyCalculatesItemWidths = YES;
        self.progressHeight = 2.5;
        self.progressColor = COLOR_NAVI;
        self.titleColorSelected = [UIColor blackColor];
        self.titleColorNormal = [UIColor grayColor];
        self.titleSizeNormal = 18.3;
        self.titleSizeSelected = 18.3;
        _rightItmes = [NSMutableArray array];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self wr_setNavBarBackgroundAlpha:0];
    [self getCartoonData];
    
    [self setupRightItmes];
    [self.view addSubview:self.bottomView];
    [self setSelectIndex:1];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
    [self getBottomData];
    
}

-(void)setupRightItmes{
    NSMutableArray * arr = [NSMutableArray array];
    for (int i=0; i<2; i++) {
        
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"detail_right_item%d",i]] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(rightItemsClick:) forControlEvents:UIControlEventTouchUpInside];
        [_rightItmes addObject:btn];
        if (i==0) {
            [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"detail_right_item%d-1",i]] forState:UIControlStateSelected];
        }
        if (@available(iOS 11.0, *)) {
        }else{
            btn.size = CGSizeMake(28, 28);
        }
        UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithCustomView:btn];
        
        [arr addObject:item];
    }
    self.navigationItem.rightBarButtonItems = arr;//[[arr reverseObjectEnumerator] allObjects];;
}

-(void)setupSubviews{
    
    [self.view addSubview:self.headImageView];
    [self.view addSubview:self.CaricatureInfoView];
    _CaricatureInfoView.sd_layout.widthIs(SCREEN_WIDTH)
    .centerXEqualToView(_headImageView)
    .bottomEqualToView(_headImageView).heightIs(80);
    [self.view addSubview:self.tableView];
    
}
-(void)getCartoonData{
    [SVProgressHUD show];
    NSDictionary * param = @{@"id": _cartoonId};
    
    [AfnManager postWithUrl:URL_CARTOON param:param Sucess:^(NSDictionary *responseObject) {
        _model = [CartoonDetailModel mj_objectWithKeyValues:OBJ(responseObject)];
        [self reloadData];
        [self setupSubviews];
        if (_model.followCartoon) {
            [_rightItmes[0] setSelected:YES];
        }
    }];
}
-(NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController{
    if (self.model) {
        
        return 2;
    }else{
        return 0;
    }
    
}
-(NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index{
    self.titles = @[@"详情", @"选集"];
    return self.titles[index];
}
- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    switch (index) {
        case 0:{
            CommentTabelViewController *vc = [[CommentTabelViewController alloc] init];
            vc.delegate = self;
            vc.model = self.model;
            return vc;
        }
        case 1:{
            EpisodeTableViewController *vc = [[EpisodeTableViewController alloc] init];
            vc.model = self.model;
            vc.delegate = self;
            return vc;
        }
        
    }
    return [[UIViewController alloc] init];
}

-(CGFloat)menuView:(WMMenuView *)menu widthForItemAtIndex:(NSInteger)index{
    CGFloat width = [super menuView:menu widthForItemAtIndex:index];
    return width+20;
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {

    return CGRectMake(0, headViewHeight, self.view.frame.size.width, 44);
    
}
- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
//    NSLog(@"%lf",self.view.frame.size.height-44-NaviHeight-49);
    return CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-44-NaviHeight-49);
}

#pragma mark- ZJPageViewControllerDelegate

- (void)scrollViewIsScrolling:(UIScrollView *)scrollView {
    _childScrollView = scrollView;
    if (self.tableView.contentOffset.y < headViewHeight) {
        scrollView.contentOffset = CGPointZero;
        scrollView.showsVerticalScrollIndicator = NO;
        
    }else{
        self.tableView.contentOffset = CGPointMake(0.0f, headViewHeight);
        scrollView.showsVerticalScrollIndicator = YES;
    }
}

#pragma mark- UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    
    if ([scrollView isKindOfClass:WMScrollView.class]){
        [super scrollViewDidScroll:scrollView];
        self.tableView.scrollEnabled = NO;
    }
    self.tableView.scrollEnabled = YES;
    
    if ( _childScrollView.contentOffset.y > 0) {
        self.tableView.contentOffset = CGPointMake(0.0f, headViewHeight);
    }
    
    CGFloat offsetY = scrollView.contentOffset.y;
    if(offsetY < headViewHeight) {
        if (offsetY>70) {
            self.title = self.model.cartoon.cartoonName;
        }else{
            self.title = @"";
        }
        if (offsetY<0) {//
            _headImageView.transform = CGAffineTransformMakeScale((ImageHeight-offsetY*2)/ImageHeight, (ImageHeight-offsetY*2)/ImageHeight);
            if (offsetY<-ImageHeight*0.3) {
                scrollView.contentOffset = CGPointMake(0, -ImageHeight*0.3 );
                
            }
        }
        CGFloat alpha = (self.tableView.contentOffset.y) / (headViewHeight-NaviHeight);
        if (alpha<0.7) {
            [[NSNotificationCenter defaultCenter] postNotificationName:ZJParentTableViewDidLeaveFromTopNotification object:nil];
            self.visualEffectView.alpha = alpha;
        }
    }
}


#pragma mark- UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [cell.contentView addSubview:self.scrollView];
        NSLog(@"%@",self.scrollView);
//        self.scrollView.scrollEnabled = NO;
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.view.frame.size.height-44-NaviHeight-49;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    self.menuView.backgroundColor = COLOR_SYSTEM_GARY;
    UIView * line = [UIView new];
    line.backgroundColor = COLOR_LINE;
    [self.menuView addSubview:line];
    line.frame = CGRectMake(0, 43.5, SCREEN_WIDTH, 0.5);
    return self.menuView;
}

-(UIView *)headView{
    if (!_headView) {
        _headView = [UIView new];
        _headView.backgroundColor = [UIColor whiteColor];
        _headView.alpha =0;
        _headView.frame = CGRectMake(0, 0, self.view.bounds.size.width, headViewHeight);
    }
    return _headView;
}


-(UIView *)CaricatureInfoView{
    if (!_CaricatureInfoView) {
        UIView * blackView = [UIView new];
        CAGradientLayer *layer = [CAGradientLayer layer];
        //设置开始和结束位置(设置渐变的方向)
        layer.startPoint = CGPointMake(0, 1);
        layer.endPoint = CGPointMake(0, 0);
        layer.colors = [NSArray arrayWithObjects:(id)rgba(0, 0, 0, 1).CGColor, rgba(0, 0, 0, 0.02).CGColor, nil];
        layer.frame = CGRectMake(0, 0, SCREEN_WIDTH, 80);// blackView.bounds; //
        [blackView.layer addSublayer:layer];
        [_headImageView addSubview:blackView];
        
        UILabel * label = [UILabel new];
        label.text = _model.cartoon.cartoonName;
        label.frame = CGRectMake(15, 8, SCREEN_WIDTH-30,25 );
        label.font = [UIFont fontWithName:@"PingFangSC-Medium" size:24];
        label.textColor = [UIColor whiteColor];
        [blackView addSubview:label];
        
        
        UIView * tipView =[UIView new];
        [blackView addSubview:tipView];
        tipView.sd_layout.bottomSpaceToView(blackView, 15).leftSpaceToView(blackView, 15);
        
        for (cartoonTypeAll * model in _model.cartoonAllType) {
            label = [UILabel new];
            label.text = [NSString stringWithFormat:@"  %@  ",model.carrtoonType.cartoonType];
            label.layer.borderWidth = 1;
            label.layer.borderColor = [UIColor whiteColor].CGColor;
            label.layer.cornerRadius = 12.5;
            label.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
            label.textColor = [UIColor whiteColor];
            [tipView addSubview:label];
            label.sd_layout.heightIs(25);
            [label setSingleLineAutoResizeWithMaxWidth:150];
        }
        
        
        [tipView setupAutoWidthFlowItems:tipView.subviews withPerRowItemsCount:_model.cartoonAllType.count verticalMargin:0 horizontalMargin:10 verticalEdgeInset:0 horizontalEdgeInset:0];
        _CaricatureInfoView = blackView;
        
        NSString * str =[NSString stringWithFormat:@"总播放：%@\n已关注：%@",_model.cartoon.playCount,_model.cartoon.followCount];
        NSMutableAttributedString * text = [[NSMutableAttributedString alloc]initWithString:str];
//        text.yy_lineSpacing = 3;
        UILabel * playLabel = [UILabel new];
        playLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
        playLabel.textColor = [UIColor whiteColor];
        playLabel.attributedText = text;
        playLabel.numberOfLines = 0;
        [blackView addSubview:playLabel];
        
        CGFloat  width = [str boundingRectWithSize:CGSizeMake(MAXFLOAT, 45) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:playLabel.font} context:nil].size.width;
        
        playLabel.sd_layout.centerYEqualToView(tipView).heightIs(45).rightSpaceToView(blackView, 10).widthIs(width);
    }
    return _CaricatureInfoView;
}
- (UIView *)headImageView {
    if (!_headImageView) {
        
        _headImageView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, ImageHeight)];
        
        UIImageView *imageView = [[UIImageView alloc] init];
        [imageView sd_setImageWithURL:[NSURL URLWithString:_model.cartoon.introduction] placeholderImage:Z_PlaceholderImg];
        [_headImageView addSubview:imageView];
        imageView.frame = _headImageView.bounds;
        
        
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        
        _visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        //添加到要有毛玻璃特效的控件中
        _visualEffectView.frame = imageView.bounds;
        [imageView addSubview:_visualEffectView];
        
        //设置模糊透明度
        _visualEffectView.alpha = 0;
    }
    
    return _headImageView;
}

-(BOOL)shouldAutomaticallyForwardAppearanceMethods{
    return NO;
}
- (UITableView *)tableView {
    if (!_tableView) {
        CGFloat height = SCREEN_HEIGHT-NaviHeight-49;
        CGRect frame = CGRectMake(0.0f, NaviHeight, self.view.bounds.size.width,height);
        ZJCustomGestureTableView *tableView = [[ZJCustomGestureTableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        // 设置tableView的headView
        tableView.backgroundColor = [UIColor clearColor];
        tableView.tableHeaderView = self.headView;
        // 设置cell行高为contentView的高度
//        tableView.rowHeight = self.view.bounds.size.height;
        tableView.delegate = self;
//        tableView.bounces = NO;
        tableView.dataSource = self;
        tableView.showsVerticalScrollIndicator = false;
        _tableView = tableView;
//        adjustsScrollViewInsets_NO(self.tableView, self);
//        self.automaticallyAdjustsScrollViewInsets = NO;
    }

    return _tableView;
}


-(void)getBottomData{
    NSDictionary * param = @{@"id": self.cartoonId};
    [AfnManager postWithUrl:URL_CARTOON_HiSTORY param:param Sucess:^(NSDictionary *responseObject) {
        _episodeModel = [EpisodeModel new];
        _episodeModel.watchState = [Msg(responseObject) intValue];
        _episodeModel.cartoonSet = [cartoonSet mj_objectWithKeyValues:OBJ(responseObject)];
        UILabel * label = [self.bottomView viewWithTag:2];
        UIButton * btn = [self.bottomView viewWithTag:1];
        label.text = [NSString stringWithFormat:@"%@  %@",[OBJ(responseObject) objectForKey:@"titile"],[OBJ(responseObject) objectForKey:@"details"]] ;
        if (_episodeModel.watchState == 0) {
            [btn setTitle:@"继续阅读" forState:UIControlStateNormal];
        }else{
            [btn setTitle:@"开始阅读" forState:UIControlStateNormal];
        }
        if (self.model==nil) [SVProgressHUD show];
    }];
}
-(UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-49, SCREEN_WIDTH, 49)];
        _bottomView.backgroundColor = RGB(233,233,233);
        
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:17];
        btn.backgroundColor = COLOR_NAVI;
        [_bottomView addSubview:btn];
        [btn addTarget:self action:@selector(BottomClick) forControlEvents:UIControlEventTouchUpInside];
        btn.sd_layout.rightEqualToView(_bottomView).topEqualToView(_bottomView)
        .bottomEqualToView(_bottomView).widthIs(134);//(134.0/49.0);
        btn.tag = 1;

        UILabel * label = [UILabel new];
        [_bottomView addSubview:label];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        label.sd_layout.leftEqualToView(_bottomView).topEqualToView(_bottomView)
        .bottomEqualToView(_bottomView).rightSpaceToView(btn, 1);
        label.tag = 2;

    }
    return _bottomView;
}
-(void)rightItemsClick:(UIButton *)item{
    
    if (item.tag == 0) {
        NSDictionary * param = @{@"id":self.model.cartoon.id,
                                 @"followState":self.model.followCartoon ? @"1": @"0"
                                 };
        [AfnManager postUserAction:URL_FOLLOW_CARTOON param:param Sucess:^(NSDictionary *responseObject) {
            self.model.followCartoon = !self.model.followCartoon;
            item.selected = !item.isSelected;
        }];
    }else{
        [shareWindow shareWithModel:self.model.cartoon cartoonSetId:nil];
    }
    
}

-(void)BottomClick{

    ReadingCartoonTVC1 * vc = [[ReadingCartoonTVC1 alloc]init];

    vc.popBlcok = ^(NSArray *cartoonIds) {
        
    };
    vc.cartoonModel = self.model;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
