//
//  UserInfoCell.m
//  XLCartoon
//
//  Created by Amitabha on 2018/1/29.
//  Copyright © 2018年 XLCR. All rights reserved.
//

#import "UserInfoCell.h"
@interface UserInfoCell()
@property (nonatomic,strong) UIImageView * vipIcon;
@property (nonatomic,strong) UIImageView * userIcon;
@property (nonatomic,strong) UILabel * nameLabel;
@property (nonatomic,strong) UILabel * kakaLabel;
@end

@implementation UserInfoCell

+(instancetype )cellWithTableView:(UITableView *)tableView{
    static NSString * cellId = @"UserInfoCell";
    UserInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    cell = [[UserInfoCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
//    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        
        self.nameLabel = [UILabel new];
        self.kakaLabel = [UILabel new];
        self.userIcon = [UIImageView new];
        
        [self.contentView sd_addSubviews:@[self.nameLabel,self.kakaLabel,self.userIcon]];

        self.nameLabel.font = [UIFont systemFontOfSize: 17];
        self.kakaLabel.font = [UIFont systemFontOfSize: 13];
        self.kakaLabel.textColor = rgba(170,170,170,1);
        
        self.userIcon.layer.masksToBounds = YES;
        self.userIcon.layer.cornerRadius = 45/2.0;
        self.userIcon.sd_layout.widthIs(45).heightEqualToWidth()
        .centerYEqualToView(self.contentView).leftSpaceToView(self.contentView, 15);
        
        self.kakaLabel.sd_layout.bottomEqualToView(self.userIcon)
        .leftSpaceToView(self.userIcon, 10).rightSpaceToView(self.contentView, 50).heightIs(20);

        self.nameLabel.sd_layout.topEqualToView(self.userIcon)
        .leftSpaceToView(self.userIcon, 10).heightIs(25);
        [self.nameLabel setSingleLineAutoResizeWithMaxWidth:SCREEN_WIDTH-100];
        
        self.vipIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"vip"]];
        self.vipIcon.highlightedImage = [UIImage imageNamed:@"vip特权"];
        [self.contentView addSubview:self.vipIcon];

        self.vipIcon.sd_layout.leftSpaceToView(self.nameLabel, 5).
        widthIs(20).heightEqualToWidth().centerYEqualToView(self.nameLabel);
    }
    return self;
}
-(void)setModel:(UserModel *)model{
    _model = model;
    self.nameLabel.text = USER_MODEL.username;
    self.kakaLabel.text = [NSString stringWithFormat: @"咔咔豆：%@",USER_MODEL.integral];
    [self.userIcon sd_setImageWithURL:[NSURL URLWithString: APP_DELEGATE.userModel.headimgurl]];
    self.vipIcon.highlighted = USER_MODEL.vipId;
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
