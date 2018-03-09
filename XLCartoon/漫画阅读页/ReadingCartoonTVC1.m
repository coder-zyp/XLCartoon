//
//  ReadingCartoonTVC.m
//  XLCartoon
//
//  Created by Amitabha on 2017/12/25.
//  Copyright © 2017年 XLCR. All rights reserved.
//

#import "ReadingCartoonTVC1.h"
#import "ReadingCartoonModel.h"
#import "ReadingCell.h"
//#import "OCBarrage.h"
#import "CommentWindow.h"
#import "commentModel.h"
#import "ReadingCommentCell.h"
#import "CommentDetailTableViewController.h"
#import "BarrageManager.h"
#import "LockCartoonCell.h"
#import "shareWindow.h"
#import "BarrageModel.h"
#import "CommentPageController.h"
#import "ReadingTabBar.h"
#import "ReadingEpisodeWindow.h"
#import "SliderView.h"


typedef NS_ENUM(NSInteger, GetDataByType) {
    GetDataByNone =0,
    GetDataByDown = 1, //往下看
    GetDataByUp =2
};

@interface ReadingCartoonTVC1 () <UIScrollViewDelegate,UITabBarDelegate,LockCartoonCellDelegate,ASValueTrackingSliderDataSource,ASValueTrackingSliderDelegate>

@property (nonatomic,strong) NSMutableArray < NSString *>* readedCartoonIds;//已经阅读过的漫画id
@property (nonatomic,strong) NSMutableArray <ReadingCartoonModel *> * modelArrs;
@property (nonatomic,strong) NSMutableArray <NSMutableArray < commentModel *>*> *  commentModelArrs;
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) ReadingTabBar * tabBar;
@property (nonatomic,strong) UIView * sectionHeaderView;
@property (nonatomic,strong) UIView * sectionFooterView;
@property (nonatomic,strong) UIButton * moreCommetFootBtn;
@property (nonatomic,assign) BOOL  isGetData;

@property (nonatomic,strong) BarrageManager *barrageManager;
@property (nonatomic,strong) NSIndexPath * willDisplayInexPath;
@property (nonatomic,strong) NSIndexPath * currentInexPath;
@property (nonatomic,strong) UILabel * titleLabel;

@property (nonatomic,assign) CGPoint  offset;
@property (nonatomic,strong) NSString * cartoonSetId;

//@property (nonatomic,assign) CGPoint stopPoint;
@property (nonatomic,strong) CALayer * brightnessLayer;
@property (nonatomic,assign) CGFloat   lightValue;
@end

@implementation ReadingCartoonTVC1
- (instancetype)init
{
    if (self = [super init]) {
        _readedCartoonIds = [NSMutableArray array];
        self.modelArrs = [NSMutableArray array];
        self.commentModelArrs = [NSMutableArray array];
    }
    return self;
}
/***/
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self.view.layer addSublayer:self.brightnessLayer];
    
    [self.view addSubview:self.titleLabel];
    
    [self.view addSubview:self.tabBar];
    
    [self.view addSubview:self.barrageManager.barrageSwitchBtn];
    
    [self.view addSubview:self.barrageManager.renderView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"share"] style:UIBarButtonItemStyleDone target:self action:@selector(shareBtnClick)];
    
    self.tableView.scrollsToTop = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    
    [self createReadingModelsWithEpisodeModels];
    [self getImageDataWithIndex:self.episodeIndex];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.episodeIndex>0) {
            [self getImageDataWithIndex:self.episodeIndex-1];
        }
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self getImageDataWithIndex:self.episodeIndex+1];
    });
    [self changeNaviState];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.navigationController.isNavigationBarHidden) {
        [self.navigationController setNavigationBarHidden:NO];
    }
    self.popBlcok(self.readedCartoonIds);
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self changeTabBarFrame];
}

#pragma mark- getdata
-(void)createReadingModelsWithEpisodeModels{
    CGFloat y = 0;
    int i = 0;
    for (EpisodeModel * episode in self.episodes) {
        ReadingCartoonModel * readingModel = [ReadingCartoonModel new];
        readingModel.episodeModel = episode;
        [self.modelArrs addObject:readingModel];
        if (i<self.episodeIndex) {
            y+=SCREEN_HEIGHT;
        }
        i++;
    }
    self.offset = CGPointMake(0, y);
 
    self.tableView.contentOffset = self.offset;
    
}

-(void)getImageDataWithIndex:(NSInteger )index{
    
    self.isGetData =YES;

    if ( self.modelArrs[index].photos ) {
        return;
    }else{
        if (USER_MODEL.hobby == NO && self.modelArrs[index].episodeModel.watchState == 0) {
            return;
        }
    }
    
    NSDictionary * param = @{
                             @"cartoonId": self.episodes[index].cartoonSet.cartoonId,
                             @"cartoonSetId": self.episodes[index].cartoonSet.id,
                             @"up":@"0"
                             };
    NSLog(@"getImageData%@",param);
    [AfnManager postListDataUrl:URL_CARTOON_PIC param:param result:^(NSDictionary *responseObject) {
        if (responseObject) {
            
            self.modelArrs[index] = [ReadingCartoonModel mj_objectWithKeyValues:responseObject];
            self.modelArrs[index].episodeModel = self.episodes[index];
            if (USER_MODEL.hobby){
                self.modelArrs[index].episodeModel.watchState = 1;
            }
            if (index <self.episodeIndex ) {
                CGFloat y = self.tableView.contentOffset.y;
                y+=self.modelArrs[index].heightTotal-SCREEN_HEIGHT;//
                self.tableView.contentOffset = CGPointMake(0, y);
            }
            self.offset = self.tableView.contentOffset;
            [self.tableView reloadData];
            self.isGetData=NO;
        }
    }];
        

}

#pragma mark- chageState

-(void)changeNaviState{
    [self.navigationController setNavigationBarHidden:!self.navigationController.isNavigationBarHidden animated:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    NSLog(@"changeNaviState");
    [self changeTabBarFrame];
}
-(void)changeTabBarFrame{
    CGFloat TabBarY = self.navigationController.isNavigationBarHidden? SCREEN_HEIGHT :SCREEN_HEIGHT- TabbarHeight;
    CGFloat x = self.navigationController.isNavigationBarHidden? TabbarHeight-49 : 0;
    
    [UIView animateWithDuration:UINavigationControllerHideShowBarDuration animations:^{
        _tabBar.frame = CGRectMake(0, TabBarY, SCREEN_WIDTH, TabbarHeight);
        self.barrageManager.barrageSwitchBtn.frame = CGRectMake(x, CGRectGetMinY(_tabBar.frame)-24.5, 80, 25);
        
    } completion:^(BOOL finished) {
//        [UIView animateWithDuration:UINavigationControllerHideShowBarDuration animations:^{
//            self.titleLabel.alpha = self.navigationController.isNavigationBarHidden? 1:0;
//        }];
    }];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.modelArrs.count*2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section%2 == 0) {
        if (self.modelArrs[section/2].photos) {
            return self.modelArrs[section/2].photos.count;
        }else{
            return 1;
        }
    }else{
        if (section/2 <self.commentModelArrs.count) {
            return self.commentModelArrs[section/2].count;
        }else{
            return 0;
        }
    }
}

-(void)tableView:(UITableView *)tableView didEndDisplayingCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section%2 == 0) {
        
        if (self.modelArrs[indexPath.section/2].photos == nil) {
            LockCartoonCell * cell = [LockCartoonCell cellWithTableView:tableView indexPath:indexPath];
            cell.model = self.modelArrs[indexPath.section/2];
            cell.delegate =self;
            return cell;
        }else{
            ReadingCell * cell = [ReadingCell cellWithTableView:tableView];
//            [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
            cell.model = self.modelArrs[indexPath.section/2].photos[indexPath.row];
            cell.testLabel.text = [NSString stringWithFormat:@"%d",(int)indexPath.row+1];
            return cell;
        }
    }else{
        ReadingCommentCell * cell = [ReadingCommentCell cellWithTableView:tableView indexPath:indexPath];
        [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
        cell.model = self.commentModelArrs[indexPath.section/2][indexPath.row];
        return cell;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section%2 == 0) {
        
        if (self.modelArrs[indexPath.section/2].photos == nil) {
            return SCREEN_HEIGHT;
        }
        PhotoModel * model = self.modelArrs[indexPath.section/2].photos[indexPath.row];
        return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[ReadingCell class] contentViewWidth:SCREEN_WIDTH];
    }else{
        return 80;
    }
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section%2 == 0 ) {
        self.willDisplayInexPath = indexPath;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section%2 == 0) {
        [self changeNaviState];
    }else{
        CommentDetailTableViewController * vc = [[CommentDetailTableViewController alloc]initWithStyle:UITableViewStyleGrouped];
        
        vc.commentType = CommentByEpisode;
        vc.model = [self.commentModelArrs[indexPath.section/2] objectAtIndex:indexPath.row];
        vc.block = ^(commentModel * model) {
            self.commentModelArrs[indexPath.section/2][indexPath.row] = model;
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark- 点击事件

-(void)moreCommentBtnClick{
    CommentPageController * vc = [[CommentPageController alloc]init];
    vc.cartoonSetId = self.episodes[self.currentInexPath.section/2].cartoonSet.id;
    vc.cartoonId = self.cartoonModel.cartoon.id;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)shareBtnClick{
    [shareWindow shareWithModel:self.cartoonModel.cartoon cartoonSetId:self.episodes[self.currentInexPath.section/2].cartoonSet.id];
}
#pragma mark- GET & SET
-(UILabel *)titleLabel{
    if(!_titleLabel){
        _titleLabel= [UILabel new];
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:13];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.backgroundColor = rgba(0, 0, 0, 0.5);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

-(BarrageManager *)barrageManager{
    if (!_barrageManager) {
        _barrageManager = [[BarrageManager alloc] init];
    }
    return _barrageManager;
}
-(UIView *)sectionFooterView{
    if (!_sectionFooterView) {
        _sectionFooterView = [UIView new];
        _sectionFooterView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40+TabbarHeight);
        
        [_sectionFooterView addSubview:self.moreCommetFootBtn];

    }
    return _sectionFooterView;
}
-(UIButton *)moreCommetFootBtn{
    if (_moreCommetFootBtn == nil) {
        _moreCommetFootBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        _moreCommetFootBtn.tag = 100;
        _moreCommetFootBtn.backgroundColor = [UIColor whiteColor];
        _moreCommetFootBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_moreCommetFootBtn addTarget: self action:@selector(moreCommentBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_moreCommetFootBtn setTitleColor:RGB(93, 107, 147) forState:UIControlStateNormal];
        [_moreCommetFootBtn setTitle: @"全部评论 >" forState:UIControlStateNormal];
    }
    return _moreCommetFootBtn;
}
-(UIView *)sectionHeaderView{
    if (!_sectionHeaderView) {
        _sectionHeaderView = [[UIView alloc]init];
        _sectionHeaderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 35);
        UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc]initWithTarget:self.navigationController action:@selector(changeNaviState)];
        [_sectionHeaderView addGestureRecognizer:gesture];
        
        UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, 5, SCREEN_WIDTH, 30)];
        [_sectionHeaderView addSubview:backView];
        backView.backgroundColor = [UIColor whiteColor];
        
        UIView * block = [[UIView alloc]initWithFrame:CGRectMake(0, 5, 3, 20)];
        block.backgroundColor = COLOR_NAVI;
        [backView addSubview:block];
        
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH, 30)];
        label.text = [NSString stringWithFormat: @"评论"];
        label.font = [UIFont systemFontOfSize:16];
        [backView addSubview:label];
    }
    return _sectionHeaderView;
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = COLOR_SYSTEM_GARY;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        adjustsScrollViewInsets_NO(self.tableView, self);
        [_tableView registerNib:[UINib nibWithNibName:@"LockCartoonCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"LockCartoonCell"];
//        [_tableView registerNib:[UINib nibWithNibName:@"ReadingCommentCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ReadingCommentCell"];
//        _tableView.decelerationRate = (UIScrollViewDecelerationRateFast + UIScrollViewDecelerationRateNormal)/2;

//        NSLog(@"%lf,%lf",UIScrollViewDecelerationRateFast ,UIScrollViewDecelerationRateNormal);
    }
    return _tableView;
}

-(ReadingTabBar *)tabBar{
    if (!_tabBar) {
        _tabBar = [[ReadingTabBar alloc]init];
        _tabBar.delegate = self;
    }
    return _tabBar;
}
-(void)setEpisodeIndex:(NSInteger)episodeIndex{
    if (episodeIndex == 0) {
        _episodeIndex = episodeIndex;
        return;
    }
    if (_episodeIndex < episodeIndex && episodeIndex+1 <self.episodes.count) {
        [self getImageDataWithIndex:episodeIndex+1];
//        self.isGetData = YES;
    }
    if (_episodeIndex > episodeIndex && episodeIndex >0){
        [self getImageDataWithIndex:episodeIndex-1];
//        self.isGetData = YES;
    }
    
    
    _episodeIndex = episodeIndex;
}

-(void)setWillDisplayInexPath:(NSIndexPath *)willDisplayInexPath{
    
    _willDisplayInexPath = willDisplayInexPath;
    
    if (_willDisplayInexPath.section/2 != self.episodeIndex) {
        CGFloat maxOffset = self.offset.y + self.modelArrs[self.episodeIndex].heightTotal;
    
        if (_tableView.contentOffset.y > maxOffset) {
            self.episodeIndex = _willDisplayInexPath.section/2;
        }
        if (_tableView.contentOffset.y < self.offset.y ) {
            self.episodeIndex = _willDisplayInexPath.section/2;
        }
        
    }
    
    ReadingCartoonModel * model = self.modelArrs[_willDisplayInexPath.section/2];
    int photoCount = model.photos ? (int)model.photos.count : 1;
    NSString * str = [NSString stringWithFormat:@"%@ %d/%d",model.episodeModel.cartoonSet.titile,(int)willDisplayInexPath.row+1 ,photoCount];
    CGFloat w = [str sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}].width +20;
    _titleLabel.frame = CGRectMake(SCREEN_WIDTH-w, SCREEN_HEIGHT-25, w, 25);
    _titleLabel.text = str;
    self.title = model.episodeModel.cartoonSet.titile;
    
}
-(void)setCurrentInexPath:(NSIndexPath *)currentInexPath{
    
    _currentInexPath = currentInexPath;
    if ( self.modelArrs[_currentInexPath.section/2].photos) {
        PhotoModel * model = self.modelArrs[_currentInexPath.section/2].photos[_currentInexPath.row];
        [self.barrageManager getBarrageTextWithPhotoId:model.id cartoonId:self.episodes[_currentInexPath.section/2].cartoonSet];
    }
}
-(NSString *)cartoonSetId{
    return self.episodes[_willDisplayInexPath.section/2].cartoonSet.id;
}
-(CALayer *)brightnessLayer{
    if(!_brightnessLayer){
        _brightnessLayer = [CALayer layer];
        _brightnessLayer.frame = [UIScreen mainScreen].bounds;
        
        self.brightnessLayer.backgroundColor = [UIColor colorWithWhite:0 alpha:1-self.lightValue].CGColor;
    }
    return _brightnessLayer;
}
#pragma mark- tabbarDelegate
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    
    switch (item.tag) {
        case 0://弹幕
            [self.barrageManager addBarrageWithPhotoId:self.modelArrs[_willDisplayInexPath.section/2].photos[_willDisplayInexPath.row].id cartoonId:self.episodes[_willDisplayInexPath.section/2].cartoonSet];
            break;
        case 1://评论
        {
            [CommentWindow shareWithFinshBlock:^(NSString *text, CommentWindow *window) {
                [SVProgressHUD show];
                NSDictionary * param = @{@"cartoonSetId":  self.cartoonSetId,
                                         @"cartoonId":  self.cartoonModel.cartoon.id,
                                         @"commentInfo": text
                                         };
                [AfnManager postUserAction:URL_COMMENT_Episode param:param Sucess:^(NSDictionary *responseObject) {
                    window.textView.text= @"";
                    self.sectionHeaderView = nil;
                }];
            }];
        }
            break;
        case 2://目录
        {
            if (![self.navigationController isNavigationBarHidden]) {
                [self changeNaviState];
            }
            [ReadingEpisodeWindow shareWithModels:self.episodes index:self.episodeIndex cartoon:self.cartoonModel.cartoon selected:^(NSInteger row) {
                [self changeNaviState];
                if (row>=0) {
                    
                }
            }];
        }
            break;
        case 3:
        case 4://亮度
            if (![self.navigationController isNavigationBarHidden]) {
                [self changeNaviState];
                self.barrageManager.barrageSwitchBtn.alpha =0;
            }
            [self performSelector:@selector(createSliderViewWithTag:) withObject:@(item.tag) afterDelay:UINavigationControllerHideShowBarDuration];
            break;
        default:
            break;
    }
}




#pragma mark- cellDelegate
-(void)LockCartoonCellUnlockSucess{
    [self.tableView reloadData];
}
#pragma mark- sliderView
- (void)createSliderViewWithTag:(NSNumber *) tag{
    SliderView * sliderView = [[[NSBundle mainBundle] loadNibNamed:@"SliderView" owner:nil options:nil]firstObject];
    [self.view addSubview:sliderView];
    sliderView.slider.delegate = self;
    sliderView.slider.dataSource = self;
    sliderView.slider.tag = tag.integerValue;
    if (sliderView.slider.tag == 3) {
        sliderView.slider.minimumValueImage = [UIImage new];
        sliderView.slider.maximumValueImage = [UIImage new];
        sliderView.slider.minimumValue = 0;
        sliderView.slider.maximumValue = self.modelArrs[self.willDisplayInexPath.section/2].photos.count-1;
        [sliderView.slider setValue:self.willDisplayInexPath.row];
    }else{
        [sliderView.slider addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventValueChanged];
        [sliderView.slider setValue:self.lightValue];
    }
    [sliderView layoutIfNeeded];
    sliderView.viewBottomConstraint.constant = 0;
    
    [UIView animateWithDuration:UINavigationControllerHideShowBarDuration animations:^{
        [sliderView layoutIfNeeded];
        self.barrageManager.barrageSwitchBtn.alpha =0;
    }];
    sliderView.dismisssBlock = ^{
        [self changeNaviState];
        self.barrageManager.barrageSwitchBtn.alpha =1;
    };
}
-(NSString *)slider:(ASValueTrackingSlider *)slider stringForValue:(float)value{
    if (slider.tag == 3) {
        return [NSString stringWithFormat:@"%@\n%0.f/%ld",self.title,value+1,self.modelArrs[self.willDisplayInexPath.section/2].photos.count];
    }else{
        return [NSString stringWithFormat:@"%0.1f%%",125*slider.value-25];
//        return [NSString stringWithFormat:@"%0.1f\%",((1-(1-slider.value)/0.8))*100];
    }
}
-(void)sliderValueChange:(UISlider *)slider{
    self.brightnessLayer.backgroundColor = [UIColor colorWithWhite:0 alpha:1-slider.value].CGColor;
    //    [[UIScreen mainScreen] setBrightness:slider.value];
}

- (void)sliderWillDisplayPopUpView:(ASValueTrackingSlider *)slider{
    
}
-(void)sliderWillHidePopUpView:(ASValueTrackingSlider *)slider{
    if (slider.tag == 3) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:slider.value inSection:self.willDisplayInexPath.section] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }else{
        NSString * value =[NSString stringWithFormat:@"%lf",slider.value];
        USER_SYSTEM_LIGHT_SET(value);
    }
}
-(CGFloat)lightValue{
    NSString * value = USER_SYSTEM_LIGHT;
    if (value) {
        return value.floatValue;
    }else{
        return 0.9;
    }
}
#pragma mark- scrollDelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

    
    if (_willDisplayInexPath != _currentInexPath) self.currentInexPath = self.willDisplayInexPath;

}
//-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
//     _stopPoint = self.tableView.contentOffset;
//}

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    
    static const CGFloat max = 5000;
    CGFloat y = scrollView.contentOffset.y;
//    NSLog(@"zzzzzzz%lf,%lf",targetContentOffset->y -y,velocity.y);
    if (targetContentOffset->y> y+max) {
        targetContentOffset->y = y +max;
    }
    if (targetContentOffset->y < y-max ) {
        targetContentOffset->y = y -max;
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{

//    NSLog(@"_willDisplayInexPath%ld,%ld",_willDisplayInexPath.section,_willDisplayInexPath.row);
    if (![self.navigationController isNavigationBarHidden]) {
        [self changeNaviState];
    }
//    CGFloat maxOffset = self.offset.y + self.modelArrs[self.index].heightTotal;

//    if (_tableView.contentOffset.y > maxOffset  &&  self.isGetData==NO && self.index<self.episodes.count-2) {
//        //下一话
//        self.isGetData = YES;
//        self.index++;
//        [self getImageDataWithIndex:self.index+1];
//    }
//    if (_tableView.contentOffset.y < self.offset.y && self.isGetData==NO && self.index>1) {
//        //上一话
//        self.isGetData = YES;
//        self.index--;
//        [self getImageDataWithIndex:self.index-1];
//    }
    
//    if (_willDisplayInexPath.section/2 == self.index+1 && self.isGetData == NO){ //下一话
//        [self getImageDataWithIndex:self.index+1];
//        self.index++;
//
//    }
//
//    if (_willDisplayInexPath.section/2 == self.index-1 && self.isGetData == NO) { //上一话
//        [self getImageDataWithIndex:self.index-1];
//        self.index--;
//
//    }
    
   
    
}
#pragma mark- MemoryWarnin
-(void)dealloc{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
