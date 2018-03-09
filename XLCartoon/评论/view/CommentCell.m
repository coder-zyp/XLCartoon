//
//  CommentCell.m
//  XLGame
//
//  Created by Amitabha on 2017/12/11.
//  Copyright © 2017年 In.于楚天. All rights reserved.
//

#import "CommentCell.h"

@interface CommentCell()
@property (nonatomic,strong) UIImageView * userIcon;
@property (nonatomic,strong) UILabel * userNameLabel;
@property (nonatomic,strong) UILabel * userCommentLabel;
@property (nonatomic,strong) UILabel * timeLabel;

@property (nonatomic,strong) UILabel  * praiseCountLabel;
@property (nonatomic,strong) NSArray  <UILabel *> * otherCommentLabelArr;

@property (nonatomic,strong) UIView * line;

@end


@implementation CommentCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+(instancetype )cellWithTableView:(UITableView *)tableView contentViewColor:(UIColor *)color{
    static NSString * cellId = @"CommentCell";
    CommentCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell ==nil) {
        cell = [[CommentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        
    }
    cell.contentView.backgroundColor = color;
    if ([cell.contentView.backgroundColor isEqual:[UIColor whiteColor]]) {
        cell.otherCommentView.backgroundColor = COLOR_SYSTEM_GARY;
    }else{
        cell.otherCommentView.backgroundColor = COLOR_LIGHT_GARY;
    }
    return cell;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView sd_addSubviews:@[self.userIcon,self.userNameLabel,
                                           self.userCommentLabel,
                                           self.timeLabel,self.praiseBtn]];
        
        self.userIcon.sd_layout.widthIs(30).heightIs(30)
        .topSpaceToView(self.contentView, 10).leftSpaceToView(self.contentView, 10);
        
        self.userNameLabel.sd_layout.leftSpaceToView(self.userIcon, 5).topSpaceToView(self.contentView, 14).rightSpaceToView(self.contentView, 15).autoHeightRatio(0);
        
        self.userCommentLabel.sd_layout.leftEqualToView(self.userNameLabel)
        .rightEqualToView(self.userNameLabel).topSpaceToView(self.userNameLabel, 8).autoHeightRatio(0);
        
        _otherCommentView = [UIView new];
        [self.contentView addSubview:_otherCommentView];
        
        _otherCommentView.sd_layout.leftEqualToView(self.userNameLabel)
        .rightSpaceToView(self.contentView, 15).topSpaceToView(self.userCommentLabel, 10);
        
        
        UIView * lastView= _otherCommentView;
        for (UILabel * label in self.otherCommentLabelArr) {
            [_otherCommentView addSubview:label];
            label.sd_layout.leftSpaceToView(_otherCommentView, 5).rightSpaceToView(_otherCommentView,5)
            .topSpaceToView(lastView, 5).autoHeightRatio(0).maxHeightIs(40);
            lastView = label;
        }
        
        [_otherCommentView setupAutoHeightWithBottomView:lastView bottomMargin:5];
        
        self.timeLabel.sd_layout.leftEqualToView(self.userNameLabel).topSpaceToView(_otherCommentView, 0).heightIs(30);
        [self.timeLabel setSingleLineAutoResizeWithMaxWidth:200];
    
        
        self.praiseBtn.sd_layout.rightSpaceToView(self.contentView, 15).centerYEqualToView(self.timeLabel).heightIs(40).widthIs(80);
        
        
        self.line =[UIView new];
        _line.backgroundColor = COLOR_LIGHT_GARY;
        [self.contentView addSubview:_line];
        _line.sd_layout.topSpaceToView(self.timeLabel, 2).leftSpaceToView(self.contentView,45).rightEqualToView(self.contentView).heightIs(0.5);
        
        [self setupAutoHeightWithBottomView:_line bottomMargin:-0.0];
    }
    return self;
}

-(void)setModel:(commentModel *)model{
    
    _model = model;
    if (model.cartoonComment == nil) {
        model.cartoonComment = model.cartoonCommentson;
    }
    [_userIcon sd_setImageWithURL:[NSURL URLWithString:model.user.headimgurl] placeholderImage:[UIImage imageNamed:@"usericonwithlogin"]] ;
    _userNameLabel.text = model.user.username;
    _userCommentLabel.text = model.cartoonComment.commentInfo;
    _timeLabel.text = model.cartoonComment.commentDate;
    _praiseCountLabel.text =  model.cartoonComment.okCount;
    int i = 0;
    for (commentModel * model in self.model.list) {
        [_otherCommentView setupAutoHeightWithBottomView:_otherCommentLabelArr[i] bottomMargin:5];
        if (i<2) {
//            NSLog(@"%@",model.cartoonCommentson.commentInfo);
            NSAttributedString * aStr1 = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@：" ,model.user.username] attributes:@{NSForegroundColorAttributeName:rgba(73,144,226,1)}];
            NSMutableAttributedString * aStr =[[NSMutableAttributedString alloc]initWithAttributedString:aStr1];
            NSString * str = model.cartoonCommentson.commentInfo? model.cartoonCommentson.commentInfo: model.cartoonComment.commentInfo;
            [aStr appendAttributedString:[[NSAttributedString alloc]initWithString:str]];
            _otherCommentLabelArr[i].attributedText = aStr;
        }else{
            _otherCommentLabelArr[i].attributedText = [[NSAttributedString alloc]initWithString: @""];
            _otherCommentLabelArr[i].text = @"";
            break;
        }
        i ++;
    }
    if (model.cartoonComment.commentCount>2) {
        [_otherCommentView setupAutoHeightWithBottomView:_otherCommentLabelArr[2] bottomMargin:5];
        _otherCommentLabelArr[2].textColor = rgba(73,144,226,1);
        _otherCommentLabelArr[2].text =[NSString stringWithFormat:@"共%d条回复 >",model.cartoonComment.commentCount] ;
        
    }else{
        _otherCommentLabelArr[2].text = @"";
        [_otherCommentView setupAutoHeightWithBottomView:_otherCommentLabelArr[1] bottomMargin:5];
    }
    if (i==0) {//没有子平轮
        self.timeLabel.sd_layout.topSpaceToView(self.userCommentLabel, 0);
        self.otherCommentView.alpha = 0;
    }else{
        self.otherCommentView.alpha = 1;
        self.timeLabel.sd_layout.topSpaceToView(self.otherCommentView, 0);
    }
    UIImageView * praiseIcon = [self.praiseBtn viewWithTag:1];
    if (model.veryOk) {
        praiseIcon.highlighted = YES;
    }else{
        praiseIcon.highlighted = NO;
    }
}
-(NSArray<UILabel *> *)otherCommentLabelArr{
    if (_otherCommentLabelArr == nil) {
        NSMutableArray * arr =[NSMutableArray array];
        for (int i =0; i<3; i++) {
            UILabel * label = [UILabel new];
            label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
            label.numberOfLines = 0;
            [arr addObject:label];
        }
        _otherCommentLabelArr = arr;
    }
    return _otherCommentLabelArr;
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
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _userCommentLabel = label;
    }
    return _userCommentLabel;
}
-(UIButton *)praiseBtn{
    if (!_praiseBtn) {
        _praiseBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        
        UIImageView * imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"praise"]];
        imageView.highlightedImage = [UIImage imageNamed:@"praise-1"];
        [_praiseBtn addSubview:imageView];
        imageView.tag = 1;
        imageView.sd_layout.rightSpaceToView(_praiseBtn, 0).centerYEqualToView(_praiseBtn).widthIs(13).heightIs(13);
        
        UILabel * label = [UILabel new];
        
        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        label.textColor = [UIColor lightGrayColor];
        [_praiseBtn addSubview:label];
        _praiseCountLabel = label;
        label.tag = 2;
        
        label.sd_layout.autoHeightRatio(0).centerYEqualToView(imageView).rightSpaceToView(imageView, 5).leftSpaceToView(_praiseCountLabel, 5);
        [label setSingleLineAutoResizeWithMaxWidth:100];
        
        [_praiseBtn addTarget:self action:@selector(praiseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//        [_praiseBtn setBackgroundColor:[UIColor redColor]];
    }
    return _praiseBtn;
}
-(void)praiseBtnClick:(UIButton * )btn{
    
    [SVProgressHUD show];
    UIImageView * praiseIcon = [self.praiseBtn viewWithTag:1];
    UILabel * praiseLabel = [self.praiseBtn viewWithTag:2];
    NSDictionary * param = @{@"id":self.model.cartoonComment.id,
                             @"veryOk": praiseIcon.isHighlighted ? @"1":@"0"};
    [AfnManager postUserAction:_PraiseUrl param:param Sucess:^(NSDictionary *responseObject) {
        
        self.model.veryOk = !self.model.veryOk;
        int count = praiseLabel.text.intValue;
        praiseIcon.highlighted ? count-- :count++;
        praiseLabel.text = [NSString stringWithFormat:@"%d",count];
        praiseIcon.highlighted = !praiseIcon.isHighlighted;
    }];

}
-(UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel=[UILabel new];
        _timeLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12.2];
    }
    return _timeLabel;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
//    NSLog(@"sssssssssssssssss");
    // Configure the view for the selected state
}

@end
