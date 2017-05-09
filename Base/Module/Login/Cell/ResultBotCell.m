//
//  ResultBotCell.m
//  Base
//
//  Created by admin on 2017/5/9.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "ResultBotCell.h"

@implementation ResultBotCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [HYTool configViewLayer:self.btn];
}

+ (NSString *)identify {
    return NSStringFromClass([self class]);
}

- (void)configBotCell:(id)model {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
