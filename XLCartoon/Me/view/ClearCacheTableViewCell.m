//
//  ClearCacheTableViewCell.m
//  XLCartoon
//
//  Created by yuchutian on 2018/1/4.
//  Copyright © 2018年 XLCR. All rights reserved.
//

#import "ClearCacheTableViewCell.h"

@implementation ClearCacheTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 设置加载视图
        UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [loadingView startAnimating];
        self.accessoryView = loadingView;
        self.textLabel.font = [UIFont systemFontOfSize:17];
        self.textLabel.text = @"";
        //设置文字
        self.detailTextLabel.text = @"正在计算";
        
        [self GetCacheSize];
    }
    return self;
}

- (void)GetCacheSize
{
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(globalQueue, ^{
        //子线程异步执行，防止主线程卡顿
        
        NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path = [pathArray objectAtIndex:0];
        //获取文件的完整路径
        NSString *filePatch = [path stringByAppendingPathComponent:@"readingHistory.plist"];
        BOOL success = [[NSDictionary new] writeToFile:filePatch atomically:YES];
        if (success) NSLog(@"写入磁盘成功");

        unsigned long long size = [SDImageCache sharedImageCache].getSize;   //SDWebImage 缓存
        
        //设置文件大小格式
        NSString * sizeText = nil;
        if (size >= pow(10, 9)) {
            sizeText = [NSString stringWithFormat:@"%.2fGB", size / pow(10, 9)];
        }else if (size >= pow(10, 6)) {
            sizeText = [NSString stringWithFormat:@"%.2fMB", size / pow(10, 6)];
        }else if (size >= pow(10, 3)) {
            sizeText = [NSString stringWithFormat:@"%.2fKB", size / pow(10, 3)];
        }

        dispatch_queue_t mainQueue = dispatch_get_main_queue();

        if (sizeText != nil) {
            //异步返回主线程
            dispatch_async(mainQueue, ^{
                
                self.detailTextLabel.text = [NSString stringWithFormat:@"%@",sizeText];
                self.accessoryView = nil;
                self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                
                [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clearCacheClick)]];
                
                
                
            });
        } else {

            dispatch_async(mainQueue, ^{
                self.detailTextLabel.text = @"0.0M";
                self.accessoryView = nil;
                self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            });
//            NSLog(@"error when download:%@",error);
        }
    });
}

- (void)clearCacheClick
{
    [SVProgressHUD showWithStatus:@"正在清除缓存···"];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];

    
    
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
        dispatch_async(dispatch_get_global_queue(0, 0), ^{

            dispatch_async(dispatch_get_main_queue(), ^{

                [SVProgressHUD dismiss];
                [SVProgressHUD showSuccessWithStatus:@"清除完成"];
                // 设置文字
                self.detailTextLabel.text = @"0.0MB";

                [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];

                self.accessoryView = nil;

            });
        });
    }];
}

@end
