//
//  ReadingCartoonModel.m
//  XLCartoon
//
//  Created by Amitabha on 2017/12/27.
//  Copyright © 2017年 XLCR. All rights reserved.
//

#import "ReadingCartoonModel.h"

@implementation PhotoModel

@end

@implementation ReadingCartoonModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"photos" : @"obj"};
}


+ (NSDictionary *)mj_objectClassInArray {

    return @{@"photos" : @"PhotoModel"};
}
-(CGFloat)heightTotal{
    if (_heightTotal < 1) {
        _heightTotal = SCREEN_HEIGHT;
    }
    return _heightTotal;
}

-(void)setPhotos:(NSArray<PhotoModel *> *)photos{
    _photos = photos;
    for (PhotoModel * model in self.photos) {
        _heightTotal += SCREEN_WIDTH * model.h/ model.w;
    }
    [[SDImageCache sharedImageCache] clearMemory];
    
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
    
    for (PhotoModel * model in _photos) {
//        if (model.image == nil) {
            [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:model.src] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                
            } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
//                model.image = image;
            }];
//        }
    }
}
@end


@implementation ReadingCartoonSpare

@end
