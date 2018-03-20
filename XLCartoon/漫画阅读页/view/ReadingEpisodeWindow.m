//
//  ReadingEpisodeTVC.m
//  XLCartoon
//
//  Created by Amitabha on 2018/3/6.
//  Copyright © 2018年 XLCR. All rights reserved.
//

#import "ReadingEpisodeWindow.h"
#import "ReadingEpisodeCell.h"
#import "CartoonInfoModel.h"
#import "UIButton+JKImagePosition.h"
@interface ReadingEpisodeWindow()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSArray <EpisodeModel *> * modelArr;
@property (nonatomic,assign) NSInteger index;
@property (nonatomic,strong) UIView * blackView;
@property (nonatomic,strong) cartoon * cartoon;
@property (nonatomic,assign) BOOL mode;
@end

@implementation ReadingEpisodeWindow
+(ReadingEpisodeWindow *)shareWithModels:(NSArray<EpisodeModel *> *)modelArr index:(NSInteger)index cartoon:(cartoon*)cartoon  selected:(SelectedBlock)block{
    static ReadingEpisodeWindow *window = nil;
    window = [[ReadingEpisodeWindow alloc] initWithModels:modelArr  index:index cartoon:cartoon selected:block];
    window.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    window.backgroundColor = [UIColor clearColor];
    [window show];
    return window;
}


- (instancetype)initWithModels:(NSArray<EpisodeModel *> *)modelArr index:(NSInteger)index cartoon:(cartoon*)cartoon selected:(SelectedBlock)block
{
    self = [super init];
    if (self) {
        self.modelArr = modelArr;
        self.index = index;
        self.selectedBlock = block;
        self.cartoon = cartoon;
        self.mode = NO;
        [self addSubview:self.blackView];
       
        UIButton * closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        closeBtn.frame = CGRectMake(0, 0, CGRectGetMinX(self.blackView.frame), SCREEN_HEIGHT);
        [closeBtn addTarget:self  action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeBtn];
    }
    return self;
}
-(void)close{
    self.selectedBlock(-1);
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }] ;
    
}
- (void)show
{
    [self makeKeyWindow];
    self.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.frame =  CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }];
}
-(void)removeFromSuperview{
    [super removeFromSuperview];
    
}
#define TABLE_WIDTH SCREEN_WIDTH*0.8
-(UIView *)blackView{
    if (!_blackView) {
        
        _blackView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-TABLE_WIDTH, 0,TABLE_WIDTH , SCREEN_HEIGHT)];
        _blackView.backgroundColor = rgba(30, 30, 30, 0.95);
        [_blackView addSubview:self.tableView];
        
        UILabel * cartoonNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, TABLE_WIDTH, 60)];
        cartoonNameLabel.text = self.cartoon.cartoonName;
        cartoonNameLabel.textAlignment = NSTextAlignmentCenter;
        cartoonNameLabel.font = [UIFont systemFontOfSize:15];
        cartoonNameLabel.textColor = [UIColor whiteColor];
        [_blackView addSubview:cartoonNameLabel];
        
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 60, TABLE_WIDTH, 40)];
        view.backgroundColor = _blackView.backgroundColor;
        [_blackView addSubview:view];
        
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, TABLE_WIDTH-30, 40)];
        label.textColor = [UIColor lightGrayColor];
        label.font = [UIFont systemFontOfSize:14];
        [view addSubview:label];
        
        label.text = [NSString stringWithFormat:@"共%ld话  %@",self.modelArr.count,self.cartoon.serialState? @"连载中":@"已完结"];
        
        NSString * imageName = @"正序";
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        [btn setTitle:imageName forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(reloadTabelDataBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        
        imageName = @"倒叙";
        [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        [btn setTitle:imageName forState:UIControlStateNormal];
        
        [btn jk_setImagePosition:LXMImagePositionLeft spacing:1];
        btn.frame = CGRectMake(TABLE_WIDTH-60, 0, 60, 40);
        [view addSubview:btn];
    }
    return _blackView;
}
static NSString * const reuseIdentifier = @"ReadingEpisodeCell";
-(UITableView *)tableView{
    if (_tableView== nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 100, TABLE_WIDTH, SCREEN_HEIGHT-100) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:reuseIdentifier bundle:[NSBundle mainBundle]] forCellReuseIdentifier:reuseIdentifier];
    }
    return _tableView;
}
-(void)reloadTabelDataBtnClick:(UIButton *)btn{
    if (self.modelArr) {
        UILabel * label = [btn viewWithTag:1];
        UIImageView * imageView = [btn viewWithTag:2];
        self.mode = !self.mode;
        imageView.highlighted = self.mode;
        label.text = self.mode ? @"正序" : @"倒叙";
        [self.tableView reloadData];
    }
    
}
#pragma mark- UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modelArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ReadingEpisodeCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    //// 此步设置用于实现cell的frame缓存，可以让tableview滑动更加流畅 //////
    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    NSInteger row = _mode ? self.modelArr.count-1 - indexPath.row : indexPath.row;
    
    if (self.index == row) {
        cell.icon.hidden = NO;
    }else{
        cell.icon.hidden = YES;
    }
    cell.nameLabel.text = [NSString stringWithFormat:@"%02ld - ",row+1];
    cell.model = self.modelArr[row];

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = _mode ? self.modelArr.count-1 - indexPath.row : indexPath.row;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    } completion:^(BOOL finished) {
        self.hidden = YES;
        self.selectedBlock(row);
    }] ;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

@end
