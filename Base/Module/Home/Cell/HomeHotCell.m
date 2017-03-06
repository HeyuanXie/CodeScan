//
//  HomeHotCell.m
//  Base
//
//  Created by admin on 2017/3/3.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "HomeHotCell.h"
#import "NSString+json.h"

@implementation HomeHotCell
//TODO:设置积分字体、
+(NSString *)identify {
    return NSStringFromClass([self class]);
}

-(void)configHotCell:(id)model {
    for (UIView* subview in self.hotSubviews) {
        UIImageView* imgView = [subview viewWithTag:1000];
        UILabel* titleLbl = [subview viewWithTag:1001];
        UILabel* jifenLbl = [subview viewWithTag:1002];
        
        NSString* text = jifenLbl.text;
        NSMutableAttributedString* attrStr = [[NSMutableAttributedString alloc] initWithString:text];
        [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:[text rangeOfString:@"积分"]];
        [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor hyRedColor] range:[text rangeOfString:@"积分"]];
        jifenLbl.attributedText = attrStr;
    }
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
