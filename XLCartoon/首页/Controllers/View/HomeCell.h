//
//  HomeCell.h
//  XLGame
//
//  Created by Amitabha on 2017/12/8.
//  Copyright © 2017年 In.于楚天. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CartoonInfoModel.h"
@interface HomeCell : UITableViewCell

//@protocol GamePacksCellDelegate <NSObject>
//
//@required
//
//-(void)GamePacksCellPacksBtnClickWithIndexPate:(NSIndexPath *)indexPath withTag:(NSInteger)tag;
//
//@end


@property (nonatomic, strong) CartoonDetailModel * model;

//@property (nonatomic,weak) id<GamePacksCellDelegate> delegate;

+(HomeCell *)cellWithTableView:(UITableView *)tableView;
@end
