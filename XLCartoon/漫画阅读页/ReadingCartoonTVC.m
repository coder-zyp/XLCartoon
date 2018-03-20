//
//  ReadingCartoonTVC.m
//  XLCartoon
//
//  Created by Amitabha on 2017/12/25.
//  Copyright © 2017年 XLCR. All rights reserved.
//

#import "ReadingCartoonTVC.h"
#import "ReadingCartoonModel.h"
#import "ReadingCell.h"
#import "CommentWindow.h"
#import "commentModel.h"
#import "ReadingCommentCell.h"
#import "CommentDetailTableViewController.h"
#import "BarrageManager.h"
#import "UnlockCartoonView.h"
#import "shareWindow.h"
#import "BarrageModel.h"
#import "CommentPageController.h"
#import "ReadingTabBar.h"
#import "ReadingEpisodeWindow.h"
#import "SliderView.h"

@interface ReadingCartoonTVC () <UIScrollViewDelegate,UITabBarDelegate,ASValueTrackingSliderDataSource,ASValueTrackingSliderDelegate>

@property (nonatomic,strong) NSMutableArray < NSString *>* readedCartoonIds;//已经阅读过的漫画id
@property (nonatomic,strong) ReadingCartoonModel  * model;
@property (nonatomic,strong) NSMutableArray < commentModel *> *  commentModelArrs;
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) ReadingTabBar * tabBar;
@property (nonatomic,strong) UIView * sectionHeaderView;

@property (nonatomic,strong) UIButton * moreCommetBtn;
@property (nonatomic,strong) UIView * tableFooter;
@property (nonatomic,assign) BOOL  isGetData;

@property (nonatomic,strong) BarrageManager *barrageManager;
@property (nonatomic,strong) NSIndexPath * willDisplayInexPath;
@property (nonatomic,strong) NSIndexPath * currentInexPath;
@property (nonatomic,strong) UILabel * titleLabel;

@property (nonatomic,strong) CALayer * brightnessLayer;
@property (nonatomic,assign) CGFloat   lightValue;
@property (nonatomic,strong) NSMutableDictionary * cacheDict;//缓存一集的model ，

@end

@implementation ReadingCartoonTVC
- (instancetype)init
{
    if (self = [super init]) {
        _readedCartoonIds = [NSMutableArray array];
        self.commentModelArrs = [NSMutableArray array];
        self.cacheDict = [NSMutableDictionary dictionary];
    }
    return self;
}
/***/
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view.layer addSublayer:self.brightnessLayer];
    
    [self.view addSubview:self.titleLabel];
    
    [self.view addSubview:self.tabBar];
    
    [self.view addSubview:self.barrageManager.barrageSwitchBtn];
    
    [self.view addSubview:self.barrageManager.renderView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"share"] style:UIBarButtonItemStyleDone target:self action:@selector(shareBtnClick)];
    
    [self resetData];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.navigationController.isNavigationBarHidden) {
        [self.navigationController setNavigationBarHidden:NO];
    }
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self hidenTabBar:YES];
    [self writeIndexToSandow];
}
-(void)writeIndexToSandow{
    NSMutableDictionary * dict =[self getHistoryIndexInSandow];
    
    CGFloat y = self.tableView.contentOffset.y;
    if (y>self.model.heightTotal-SCREEN_HEIGHT) {
        y=self.model.heightTotal-SCREEN_HEIGHT;
    }
    [dict setObject:@(y) forKey:self.model.episodeModel.cartoonSet.id];
    
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [pathArray objectAtIndex:0];
    //获取文件的完整路径
    NSString *filePatch = [path stringByAppendingPathComponent:@"readingHistory.plist"];
    BOOL success = [dict writeToFile:filePatch atomically:YES];
    NSLog(@"%d",success);
}
-(NSMutableDictionary *)getHistoryIndexInSandow{
    
    
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [pathArray objectAtIndex:0];
    
    //获取文件的完整路径
    NSString *filePatch = [path stringByAppendingPathComponent:@"readingHistory.plist"];//没有会自动创建
    
    NSMutableDictionary *sandBoxDataDic = [[NSMutableDictionary alloc]initWithContentsOfFile:filePatch];
    if (sandBoxDataDic==nil) {
        sandBoxDataDic = [NSMutableDictionary new];
    }

    return sandBoxDataDic;
}
#pragma mark- getdata
-(void)resetData{
    
    if (_episodeIndex == self.episodes.count) {
        [SVProgressHUD showErrorWithStatus:@"已经是最后一话啦"];
        self.episodeIndex --;
        return;
    }
    if (self.episodeIndex<0) {
        [SVProgressHUD showErrorWithStatus:@"已经是第一话了"];
        self.episodeIndex ++;
        return;
    }
    
    if (self.model) {
        for (PhotoModel * model in self.model.photos) {
            model.image = nil;
        }
        NSString * jsonStr = [self.model mj_JSONString];
        [self.cacheDict setObject:jsonStr forKey:self.model.episodeModel.cartoonSet.id];
        [self writeIndexToSandow];
    };
    self.model.episodeModel.watchState = 1;
    self.model = nil;
    self.commentModelArrs = [NSMutableArray array];;
    _tableFooter = nil;
    [_tableView removeFromSuperview];
    _tableView = nil;

    [self.view insertSubview:self.tableView atIndex:0];
    self.brightnessLayer.backgroundColor = [UIColor colorWithWhite:0 alpha:0].CGColor;
    _currentInexPath = nil;
    _willDisplayInexPath = nil;
    
    
    [self getImageData];
}

-(void)getImageData{
    
    self.isGetData = YES;
    

    EpisodeModel * episodeModel = [self.episodes objectAtIndex: _episodeIndex];
    NSString * jsonStr  = [self.cacheDict objectForKey:episodeModel.cartoonSet.id];
    if (jsonStr) {
        self.model = [ReadingCartoonModel mj_objectWithKeyValues:jsonStr];
        self.model.episodeModel = episodeModel;
        [self reloadTable];
        return;
    }
    
    NSDictionary * param = @{
                             @"cartoonId": episodeModel.cartoonSet.cartoonId,
                             @"cartoonSetId": episodeModel.cartoonSet.id,
                             @"up":@"0"
                             };

    [SVProgressHUD show];
    [AfnManager postListDataUrl:URL_CARTOON_PIC param:param result:^(NSDictionary *responseObject) {
        if (responseObject) {
            self.model = [ReadingCartoonModel mj_objectWithKeyValues:responseObject];
            self.model.episodeModel = episodeModel;
            [self reloadTable];
            if (USER_MODEL.hobby) {
                episodeModel.watchState = 1;
            }else{
                if (REQ_ERROR(responseObject)==300) {
                    [self addLockView];
                }
            }
        }
    }];
}

-(void)reloadTable{

    [self.tableView reloadData];
    [self getCommentData];
    NSNumber * y = [[self getHistoryIndexInSandow] objectForKey:self.episodes[_episodeIndex].cartoonSet.id];
    if (y) {
        self.tableView.contentOffset = CGPointMake(0, y.floatValue) ;
    }
    
}

-(void)getCommentData{
    
    NSDictionary * param = @{@"nowPage":@"1",
                             @"cartoonSetId": self.model.episodeModel.cartoonSet.id,
                             @"cartoonId" : self.model.episodeModel.cartoonSet.cartoonId,
                             @"bestNew": @"1",
                             };
    
    [AfnManager postWithUrl:URL_GET_COMMENT_Episode param:param Sucess:^(NSDictionary *responseObject) {
        
        for (NSDictionary * dict in OBJ(responseObject)) {
            [self.commentModelArrs addObject:[commentModel mj_objectWithKeyValues:dict]];
        }
        if (self.commentModelArrs.count && self.model.photos.count) {
            
            NSInteger number = [self numberOfSectionsInTableView:self.tableView];
            NSLog(@"numbernumbernumbernumbernumber %ld",number);
//            [self.tableView insertSections: [NSIndexSet indexSetWithIndex:number-1 ] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView reloadSections: [NSIndexSet indexSetWithIndex:number-1] withRowAnimation:UITableViewRowAnimationNone];
        }
    }];
}
-(void)addLockView{
    
    UnlockCartoonView * unlockView = [[[NSBundle mainBundle] loadNibNamed:@"UnlockCartoonView" owner:self options:nil] firstObject];
    [unlockView setModel:self.model.episodeModel sucess:^{
        
    } failed:^(UIViewController *needPushVC) {
        if (needPushVC){
            UINavigationController * navi = self.navigationController;
            NSMutableArray * controllers = [NSMutableArray arrayWithArray:self.navigationController.viewControllers] ;
            [controllers removeLastObject];
            self.navigationController.viewControllers =controllers;
            [navi pushViewController:needPushVC animated:NO];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    
    UIView * view = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    view.backgroundColor = rgba(0, 0, 0, 0.5);
    [view addSubview:unlockView];
    unlockView.center = view.center;
    [self.navigationController.view addSubview:view];
    
}
#pragma mark- chageState

-(void)changeNaviState{
    if (_tabBar.hidden && !self.navigationController.isNavigationBarHidden) {
        return;
    }
    [self.navigationController setNavigationBarHidden:!self.navigationController.isNavigationBarHidden animated:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

    [self hidenTabBar:self.navigationController.isNavigationBarHidden];
}
-(void)hidenTabBar:(BOOL)hiden{
    CGFloat TabBarY = hiden ? SCREEN_HEIGHT :SCREEN_HEIGHT- TabbarHeight;
    CGFloat x = hiden ? TabbarHeight-49 : 0;
    
    [UIView animateWithDuration:UINavigationControllerHideShowBarDuration animations:^{
        _tabBar.frame = CGRectMake(0, TabBarY, SCREEN_WIDTH, TabbarHeight);
        _tabBar.hidden = hiden;
        self.barrageManager.barrageSwitchBtn.frame = CGRectMake(x, CGRectGetMinY(_tabBar.frame)-24.5, 80, 25);
    } completion:nil];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    NSInteger number = 0;
    if ( self.model) number+=2;
//    if ( self.commentModelArrs.count) number ++;
    return number;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section%2 == 0) {
        return self.model.photos.count;
    }else{
        if (self.commentModelArrs.count>5) {
            return 5;
        }else{
            return self.commentModelArrs.count;
        }
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section%2 == 0) {
        
        ReadingCell * cell = [ReadingCell cellWithTableView:tableView];
        [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
        cell.model = self.model.photos[indexPath.row];
        cell.testLabel.text = [NSString stringWithFormat:@"%d",(int)indexPath.row+1];
        return cell;
    }else{
        
        ReadingCommentCell * cell = [ReadingCommentCell cellWithTableView:tableView indexPath:indexPath];
        [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
        cell.model = self.commentModelArrs[indexPath.row];
        return cell;
        
        return cell;;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section%2 == 0) {
        PhotoModel * model = self.model.photos[indexPath.row];
        return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[ReadingCell class] contentViewWidth:SCREEN_WIDTH];
    }else{
        return 80;
    }
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section%2 == 0 ) {
        self.willDisplayInexPath = indexPath;
        ReadingCartoonModel * model = self.model;
        int photoCount = model.photos ? (int)model.photos.count : 1;
        NSString * str = [NSString stringWithFormat:@"%@ %d/%d",model.episodeModel.cartoonSet.titile,(int) self.willDisplayInexPath.row+1 ,photoCount];
        CGFloat w = [str sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}].width +20;
        _titleLabel.frame = CGRectMake(SCREEN_WIDTH-w, SCREEN_HEIGHT-25, w, 25);
        _titleLabel.text = str;
        self.title = model.episodeModel.cartoonSet.titile;
        
        self.brightnessLayer.backgroundColor = [UIColor colorWithWhite:0 alpha:1-self.lightValue].CGColor;
        SliderView * view = [self.view viewWithTag:3];
        if (view.isShowReadProgress == YES) {
            [self showSlider];
        }
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section%2 == 0) {
        [self changeNaviState];
    }else{
        CommentDetailTableViewController * vc = [[CommentDetailTableViewController alloc]initWithStyle:UITableViewStyleGrouped];
        
        vc.commentType = CommentByEpisode;
        vc.model = [self.commentModelArrs objectAtIndex:indexPath.row];
        vc.block = ^(commentModel * model) {
            self.commentModelArrs[indexPath.row] = model;
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.commentModelArrs.count && section%2==1) {
        return 35;
    }else{
        return 0.00001;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section && self.commentModelArrs.count>0) {
        return self.sectionHeaderView;
    }
    return [UIView new];
}

-(UIView *)tableFooter{
    if (_tableFooter == nil) {
        _tableFooter = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, TabbarHeight+40)];
        UILabel * label = [UILabel new];
        label.frame =CGRectMake(0, 0, SCREEN_WIDTH, 40);
        label.textAlignment = NSTextAlignmentCenter;
        label.tag = 1;
        [_tableFooter addSubview:label];
    }
    return _tableFooter;
}
#pragma mark- cellDelegate
-(void)LockCartoonCellUnlockSucess{
    self.isGetData = NO;
    [self.tableView reloadData];
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        adjustsScrollViewInsets_NO(self.tableView, self);

        [_tableView registerNib:[UINib nibWithNibName:@"ReadingCommentCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ReadingCommentCell"];
        
        _tableView.scrollsToTop = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = self.tableFooter;
    }
    return _tableView;
}

-(void)setCurrentInexPath:(NSIndexPath *)currentInexPath{
    
    _currentInexPath = currentInexPath;
    if ( self.model.photos) {
        PhotoModel * model = self.model.photos[_currentInexPath.row];
        [self.barrageManager getBarrageTextWithPhotoId:model.id cartoonId:self.model.episodeModel.cartoonSet];
    }
}


#pragma mark- scrollDelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (_willDisplayInexPath != _currentInexPath) self.currentInexPath = self.willDisplayInexPath;
    
}
-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    UILabel * label = [self.tableFooter viewWithTag:1];
    if ([label.text isEqualToString:@"100"]) {
        self.episodeIndex ++;
        [self resetData];
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    

    CGFloat y = scrollView.contentOffset.y - scrollView.contentSize.height+scrollView.frame.size.height+1;
    if (y>0) {
        if (self.navigationController.isNavigationBarHidden) {
            [self changeNaviState];
        }
        if (y>80) {
            y = 80;
        }
        int  scale = y*100/80;
        NSString * text = [NSString stringWithFormat:@"%d",scale];
        UILabel * label = [self.tableFooter viewWithTag:1];
        label.text = text;
    }else{
        if (!self.navigationController.isNavigationBarHidden) {
            [self changeNaviState];
        }
    }
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
//        label.textAlignment
        label.font = [UIFont systemFontOfSize:16];
        [backView addSubview:label];
        
        _moreCommetBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-90, 0, 80, 35)];
        _moreCommetBtn.tag = 100;
        _moreCommetBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _moreCommetBtn.backgroundColor = [UIColor whiteColor];
        _moreCommetBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_moreCommetBtn addTarget: self action:@selector(moreCommentBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_moreCommetBtn setTitleColor:RGB(93, 107, 147) forState:UIControlStateNormal];
        [_moreCommetBtn setTitle: @"更多 >" forState:UIControlStateNormal];
        [_sectionHeaderView addSubview:_moreCommetBtn];
        
        UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_sectionHeaderView.frame), SCREEN_WIDTH, 0.7)];
        line.backgroundColor = COLOR_LIGHT_GARY;
        [_sectionHeaderView addSubview:line];
    }
    if (_commentModelArrs.count>5) {
        _moreCommetBtn.hidden = NO;
    }else{
        _moreCommetBtn.hidden = YES;
    }
    return _sectionHeaderView;
}


#pragma mark- MemoryWarnin
-(void)dealloc{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark- TABBAR 功能
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

-(ReadingTabBar *)tabBar{
    if (!_tabBar) {
        _tabBar = [[ReadingTabBar alloc]init];
        _tabBar.delegate = self;
    }
    return _tabBar;
}
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    
    switch (item.tag) {
        case 0://弹幕
            [self.barrageManager addBarrageWithPhotoId:self.model.photos[_willDisplayInexPath.row].id cartoonId:self.episodes[_willDisplayInexPath.section/2].cartoonSet];
            break;
        case 1://评论
        {
            [CommentWindow shareWithFinshBlock:^(NSString *text, CommentWindow *window) {
                [SVProgressHUD show];
                NSDictionary * param = @{@"cartoonSetId":  self.model.episodeModel.cartoonSet.id,
                                         @"cartoonId":  self.model.episodeModel.cartoonSet.cartoonId,
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
                [self hidenTabBar:YES];
            }
            [ReadingEpisodeWindow shareWithModels:self.episodes index:self.episodeIndex cartoon:self.cartoonModel.cartoon selected:^(NSInteger row) {
                [self hidenTabBar:NO];
                if (row>=0) {
                    self.episodeIndex = row;
                    [self resetData];
                }
            }];
        }
            break;
        case 3:
        case 4://亮度
            self.barrageManager.barrageSwitchBtn.alpha =0;
            [self addSliderView].tag = item.tag;
            [self showSlider];
            [self hidenTabBar:YES];
            break;
        default:
            break;
    }
}
#pragma mark- sliderView

-(CGFloat)lightValue{
    NSString * value = USER_SYSTEM_LIGHT;
    if (value) {
        return value.floatValue;
    }else{
        return 0.9;
    }
}
-(CALayer *)brightnessLayer{
    if(!_brightnessLayer){
        _brightnessLayer = [CALayer layer];
        _brightnessLayer.frame = [UIScreen mainScreen].bounds;
    }
    return _brightnessLayer;
}
-(SliderView * )addSliderView{

    __block SliderView * sliderView = [[[NSBundle mainBundle] loadNibNamed:@"SliderView" owner:nil options:nil]firstObject];
    [self.view addSubview:sliderView];
    sliderView.slider.delegate = self;
    sliderView.slider.dataSource = self;
    sliderView.slider.tag = 4;
    [sliderView.slider addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventValueChanged];
    [sliderView.slider setValue:self.lightValue];
    sliderView.dismisssBlock = ^{
        [self hidenTabBar:NO];
        self.barrageManager.barrageSwitchBtn.alpha =1;
        sliderView = nil;
    };
    sliderView.upDownClick = ^(BOOL isDown) {

        if (self.model) {
            if (isDown) {
                self.episodeIndex++;
            }else{
                self.episodeIndex--;
            }
            [self resetData];
        }
    };
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(UINavigationControllerHideShowBarDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [sliderView layoutIfNeeded];
        sliderView.viewBottomConstraint.constant = 0;
        [UIView animateWithDuration:UINavigationControllerHideShowBarDuration animations:^{
            [sliderView layoutIfNeeded];
            self.barrageManager.barrageSwitchBtn.alpha =0;
        }];
    });
    
    return sliderView;
}
-(void)showSlider{
    SliderView * _sliderView =[self.view viewWithTag:3];
    _sliderView.slider.tag = _sliderView.tag;
    if (_sliderView.slider.tag == 3) {
        _sliderView.slider.minimumValueImage = [UIImage imageNamed:@"reading-上一话"];
        _sliderView.slider.maximumValueImage = [UIImage imageNamed:@"reading-下一话"];
        _sliderView.slider.minimumValue = 0;
        _sliderView.slider.maximumValue = self.model.photos.count-1;
        [_sliderView.slider setValue:self.willDisplayInexPath.row];
        _sliderView.isShowReadProgress = YES;
    }
}

-(NSString *)slider:(ASValueTrackingSlider *)slider stringForValue:(float)value{
    if (slider.tag == 3) {
        return [NSString stringWithFormat:@"%@\n%0.f/%ld",self.title,value+1,self.model.photos.count];
    }else{
        return [NSString stringWithFormat:@"%0.1f%%",125*slider.value-25];
        //        return [NSString stringWithFormat:@"%0.1f\%",((1-(1-slider.value)/0.8))*100];
    }
}
-(void)sliderValueChange:(UISlider *)slider{
    if (slider.tag == 4) {
        self.brightnessLayer.backgroundColor = [UIColor colorWithWhite:0 alpha:1-slider.value].CGColor;
    }
    
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
-(void)moreCommentBtnClick{
    CommentPageController * vc = [[CommentPageController alloc]init];
    vc.cartoonSetId = self.episodes[self.currentInexPath.section/2].cartoonSet.id;
    vc.cartoonId = self.cartoonModel.cartoon.id;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)shareBtnClick{
    [shareWindow shareWithModel:self.cartoonModel.cartoon cartoonSetId:self.episodes[self.currentInexPath.section/2].cartoonSet.id];
}
@end



