//
//  FridenCircleCell.m
//  XLCartoon
//
//  Created by Amitabha on 2017/12/29.
//  Copyright © 2017年 XLCR. All rights reserved.
//

#import "FridenCircleCell.h"
#import <UIButton+WebCache.h>
#import <IDMPhotoBrowser.h>
@interface FridenCircleCell()
@property (nonatomic,strong) UIImageView * userIcon;
@property (nonatomic,strong) UILabel * userNameLabel;
@property (nonatomic,strong) UIButton * praiseBtn;
@property (nonatomic,strong) UILabel * timeLabel;
@property (nonatomic,strong) UIView * photoView;
@property (nonatomic,strong) UIImageView  * praiseIcon;
@property (nonatomic,strong) UILabel  * praiseLabel;
@property (nonatomic,strong) UILabel  * commentCountLabel;
@property (nonatomic,strong) UIView * line;
@property (nonatomic,strong) NSArray <UIButton *> * buttons;
@end

@implementation FridenCircleCell

+(FridenCircleCell *)cellWithTableView:(UITableView *)tableView{
    static NSString * cellId = @"FridenCircleCell";
    FridenCircleCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell ==nil) {
        cell = [[FridenCircleCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    return cell;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = COLOR_SYSTEM_GARY;
        
        
        _praiseIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"praise"]];
        _praiseIcon.highlightedImage = [UIImage imageNamed:@"praise-1"];
        
        
        _praiseLabel = [UILabel new];
        _praiseLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12.2];
        _praiseLabel.textColor = [UIColor lightGrayColor];
        [_praiseLabel setSingleLineAutoResizeWithMaxWidth:100];
        
        [self.contentView sd_addSubviews:@[self.userIcon,self.userNameLabel,
                                           self.userCommentLabel,self.photoView,
                                           self.timeLabel,self.deleteBtn,
                                           self.praiseBtn,self.praiseIcon,self.praiseLabel,
                                           self.commentBtn]];
        
        self.userIcon.sd_layout.widthIs(30).heightIs(30)
        .topSpaceToView(self.contentView, 10).leftSpaceToView(self.contentView, 10);
        
        self.userNameLabel.sd_layout.leftSpaceToView(self.userIcon, 5).topSpaceToView(self.contentView, 14).rightSpaceToView(self.contentView, 15).autoHeightRatio(0);
        
        
        self.userCommentLabel.sd_layout.leftEqualToView(self.userNameLabel)
        .widthIs(SCREEN_WIDTH-100).topSpaceToView(self.userNameLabel, 8).autoHeightRatio(0);
//        _userCommentLabel.sd_layout.maxHeightIs(70);
        
        
        _photoView.sd_layout.leftEqualToView(self.userNameLabel)
        .rightSpaceToView(self.contentView, 50).topSpaceToView(self.userCommentLabel, 10);
        
        self.timeLabel.sd_layout.leftEqualToView(self.userNameLabel).topSpaceToView(_photoView, 0).heightIs(30);
        [self.timeLabel setSingleLineAutoResizeWithMaxWidth:200];
        
        _deleteBtn.sd_layout.leftSpaceToView(self.timeLabel, 0).centerYEqualToView(self.timeLabel).widthIs(50).heightIs(20);
        
        
        _praiseIcon.sd_layout.rightSpaceToView(self.contentView, 10).centerYEqualToView(self.timeLabel).widthIs(13).heightIs(13);
        _praiseLabel.sd_layout.autoHeightRatio(0).centerYEqualToView(_praiseIcon).
        rightSpaceToView(_praiseIcon, 5).minWidthIs(70);
        
        self.praiseBtn.sd_layout.rightSpaceToView(self.contentView, 10).centerYEqualToView(_timeLabel).
        heightIs(50).leftEqualToView(_praiseLabel);
        
        _commentBtn.sd_layout.rightSpaceToView(self.praiseBtn, 3).centerYEqualToView(self.timeLabel).heightIs(50).widthIs(40);

//        _praiseBtn.backgroundColor = [UIColor redColor];
        
        self.line =[UIView new];
        _line.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_line];
        _line.sd_layout.topSpaceToView(self.timeLabel, 2).leftSpaceToView(self.contentView,45).rightEqualToView(self.contentView).heightIs(0.5);
        
        [self setupAutoHeightWithBottomView:_line bottomMargin:-0.5];

        
    }
    return self;
}

-(void)setModel:(FridenCircliModel *)model{
    _model = model;
    [_userIcon sd_setImageWithURL:[NSURL URLWithString:model.user.headimgurl] placeholderImage:[UIImage imageNamed:@"usericonwithlogin"]] ;
    _userNameLabel.text = model.user.username;
    _timeLabel.text = model.friendsCircle.releaseDate;
    _userCommentLabel.text = model.friendsCircle.releaseInfo;
    if (model.friendsComment) {//用于子评论
        _timeLabel.text = model.friendsComment.commentDate;
        _userCommentLabel.text = model.friendsComment.commentInfo;
    }
    
    if (model.isDetail) {
        _userCommentLabel.sd_layout.maxHeightIs(500);
    }else{
        _userCommentLabel.sd_layout.maxHeightIs(70);
    }
    
    if ([model.user.userId isEqualToString:USER_ID]) {
        _deleteBtn.hidden = NO;
    }else{
        _deleteBtn.hidden = YES;
    }
    _praiseLabel.text = model.friendsCircle.okCount;
    _commentCountLabel.text = model.friendsCircle.commentCount;
    NSInteger num = model.photo.count<=3 ? model.photo.count : model.photo.count ==4 ? 2:3 ;

    
    CGFloat itemWith = num ==2 ? (SCREEN_WIDTH - 50)/3.0 : num ==3 ? (SCREEN_WIDTH -100-16)/3.0 :SCREEN_WIDTH/2.9 ;
    NSMutableArray * arr = [NSMutableArray array];
    for (int i =0 ; i<9; i++) {
        UIButton * btn = [_photoView viewWithTag:i+1];
        
        if (i<model.photo.count) {
            
            [arr addObject:btn];
            [btn sd_setImageWithURL:[NSURL URLWithString:model.photo[i].src] forState:UIControlStateNormal];
            
            btn.frame = CGRectMake( (i%num)*(itemWith+8), (i/num)*(itemWith+8),  itemWith, itemWith);
            if (i==model.photo.count-1) {
                [_photoView setupAutoHeightWithBottomView:btn bottomMargin:0];
            }
            
        }else{
            btn.frame = CGRectZero;
            [btn setImage:[UIImage new] forState:UIControlStateNormal];
            if (i==0) {
                [_photoView setupAutoHeightWithBottomView:btn bottomMargin:0];
            }
        }
        
    }
    if ([model.veryOk isEqualToString:@"1"]) {
        _praiseIcon.highlighted = YES;
    }else{
        _praiseIcon.highlighted = NO;
    }
    
}
-(void)btnClick:(UIButton * )btn{
    NSMutableArray * images = [NSMutableArray array];
    for (photoModel * item in self.model.photo) {
        [images addObject:item.src];
    }
    IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc] initWithPhotoURLs:images animatedFromView:btn];
    //动力使用动画效果时,你可以设置scaleImage属性,这是缩放参数,设置了后,图片就不会按照原样显示出来.
    browser.scaleImage = btn.currentImage;
    browser.displayDoneButton = NO;
    browser.displayToolbar = NO;
    browser.dismissOnTouch = YES;
    [browser setInitialPageIndex:btn.tag-1];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(FridenCircleCellImageBtnClickWithPreviewVC:)]) {
        [self.delegate FridenCircleCellImageBtnClickWithPreviewVC:browser];
    }
    
}
-(void)deleteBtnClick{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(FridenDeleteBtnClickWithModel:)]) {
        [self.delegate FridenDeleteBtnClickWithModel:self.model];
    }
    
}-(void)commentBtnClick:(UIButton * )btn{
    if (self.delegate && [self.delegate respondsToSelector:@selector(FridenCommentBtnClickWithModel:)]) {
        [self.delegate FridenCommentBtnClickWithModel:self.model];
    }
}
-(void)praiseBtnClick:(UIButton * )btn{

    NSDictionary * param = @{@"id":self.model.friendsCircle.id,
                             @"veryOk": self.praiseIcon.highlighted ? @"1":@"0"};
    [AfnManager postWithUrl:URL_FRIEND_PRAISE param:param Sucess:^(NSDictionary *responseObject) {
        self.praiseLabel.text =[NSString stringWithFormat:@"%d",[[OBJ(responseObject) objectForKey:@"okCount"]intValue]] ;
        self.praiseIcon.highlighted = !self.praiseIcon.isHighlighted;
    }];
    
}
-(UIButton *)deleteBtn{
    if (!_deleteBtn) {
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        _deleteBtn.titleLabel.font = _timeLabel.font;
        [_deleteBtn setTitleColor:RGB(93, 107, 147) forState:UIControlStateNormal];
        [_deleteBtn addTarget:self action:@selector(deleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteBtn;
}
-(UIView *)photoView{
    if (!_photoView) {
        _photoView = [UIView new];
//        NSMutableArray * arr = [NSMutableArray array];
        for (int i=1; i<10; i++) {
            UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [_photoView addSubview:btn];
            btn.tag = i;
            [btn.imageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
            btn.contentMode = UIViewContentModeScaleAspectFill;
            
            UIImageView * imageView = btn.imageView;
            imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
            [imageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
            imageView.clipsToBounds = YES;
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    return _photoView;
}
-(UIImageView *)userIcon{
    if (!_userIcon) {
        _userIcon = [UIImageView new];
        _userIcon.layer.masksToBounds = YES;
        _userIcon.layer.cornerRadius = 15;
    }
    return _userIcon;
}
-(UILabel *)userNameLabel{
    if (!_userNameLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
        label.textColor = [UIColor grayColor];
        _userNameLabel = label;
    }
    return _userNameLabel;
}
-(UILabel *)userCommentLabel{
    if (!_userCommentLabel) {
        _userCommentLabel = [[UILabel alloc] init];
        _userCommentLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        _userCommentLabel.numberOfLines = 0;

    }
    return _userCommentLabel;
}
-(UIButton *)praiseBtn{
    if (!_praiseBtn) {
        _praiseBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [_praiseBtn addTarget:self action:@selector(praiseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        //        [_praiseBtn setBackgroundColor:[UIColor redColor]];
    }
    return _praiseBtn;
}
-(void)praiseBtnHiden:(BOOL)isHidden{
    self.praiseBtn.enabled = !isHidden;
    self.praiseLabel.hidden = isHidden;
    self.praiseIcon.hidden = isHidden;
    self.commentBtn.hidden = isHidden;
}
-(UIButton *)commentBtn{
    if (!_commentBtn) {
        _commentBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        //        _praiseBtn.backgroundColor = [UIColor blueColor];
        UIImageView * imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"comment"]];
        [_commentBtn addSubview:imageView];
        imageView.tag = 1;
        imageView.sd_layout.rightSpaceToView(_commentBtn, 5).centerYEqualToView(_commentBtn).widthIs(13).heightIs(13);
        
        UILabel * label = [UILabel new];
        
        label.font = Font_Regular(12.2);
        label.textColor = [UIColor lightGrayColor];
        [_commentBtn addSubview:label];
        _commentCountLabel = label;
        label.tag = 2;
        
        label.sd_layout.autoHeightRatio(0).centerYEqualToView(imageView).rightSpaceToView(imageView, 5).leftSpaceToView(_praiseLabel, 5);
        [label setSingleLineAutoResizeWithMaxWidth:100];
        
        [_commentBtn addTarget:self action:@selector(commentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commentBtn;
}



-(UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel=[UILabel new];
        _timeLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12.2];
    }
    return _timeLabel;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
