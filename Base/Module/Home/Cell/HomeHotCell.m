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

+(NSString *)identify {
    return NSStringFromClass([self class]);
}

-(void)configHotCell:(NSArray*)modelArr {
    if (modelArr == nil || modelArr.count == 0) {
        return;
    }
    int i = 0;
    for (UIView* subview in self.hotSubviews) {
        DeriveModel* derive = modelArr[i];
        UIImageView* imgView = [subview viewWithTag:1000];
        UILabel* titleLbl = [subview viewWithTag:1001];
        UILabel* jifenLbl = [subview viewWithTag:1002];
        
        titleLbl.text = derive.goodName;
        [imgView sd_setImageWithURL:[NSURL URLWithString:derive.img] placeholderImage:ImageNamed(@"baidi")];
        
        NSString* text = [NSString stringWithFormat:@"%@积分",derive.shopPrice];
        NSMutableAttributedString* attrStr = [[NSMutableAttributedString alloc] initWithString:text];
        [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:[text rangeOfString:@"积分"]];
        [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor hyRedColor] range:[text rangeOfString:@"积分"]];
        jifenLbl.attributedText = attrStr;
        
        [subview bk_whenTapped:^{
            APPROUTE(([NSString stringWithFormat:@"%@?id=%ld&sourceUrl=%@",kDeriveDetailController,derive.goodId.integerValue,derive.sourceUrl]));
        }];
        i++;
    }
}

- (IBAction)seeAll:(id)sender {
    APPROUTE(kDeriveListController);
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
