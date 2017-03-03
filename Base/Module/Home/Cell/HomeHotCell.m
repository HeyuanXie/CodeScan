//
//  HomeHotCell.m
//  Base
//
//  Created by admin on 2017/3/3.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "HomeHotCell.h"

@implementation HomeHotCell
//TODO:设置积分字体、
+(NSString *)identify {
    return NSStringFromClass([self class]);
}

-(void)configHotCell:(id)model {
    
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
