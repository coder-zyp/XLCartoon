//
//  readingTableFooter.m
//  XLCartoon
//
//  Created by Amitabha on 2018/3/21.
//  Copyright © 2018年 XLCR. All rights reserved.
//

#import "readingTableFooter.h"

@implementation readingTableFooter

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)awakeFromNib{
    [super awakeFromNib];
    self.tipLabel.font = [UIFont fontWithName:@"FZLBJW--GB1-0" size:15];
    self.progressLabel.font = [UIFont fontWithName:@"FZLBJW--GB1-0" size:15];
    
    for (NSString * name in [UIFont familyNames]) {
        NSLog(@"%@\n",name);
        for (NSString * fontName in [UIFont fontNamesForFamilyName:name]) {
            NSLog(@"%@\n",fontName);
        }
    }

}

@end
