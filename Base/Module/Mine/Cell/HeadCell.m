//
//  HeadCell.m
//  Base
//
//  Created by admin on 2017/3/3.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "HeadCell.h"

@implementation HeadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.userInfoViewTop.constant = zoom(74);
    
    [HYTool configViewLayerFrame:self.userHeadImg WithColor:[UIColor whiteColor] borderWidth:2];
    [HYTool configViewLayerRound:self.userHeadImg];
    
    [HYTool configViewLayer:self.roundWhiteView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(NSString *)identify {
    return NSStringFromClass([self class]);
}

+(CGFloat)height {
    return zoom(243);
}

-(void)configHeadCell:(id)model {
    [self.waitUseLbl bk_whenTapped:^{
        if (self.waitUseBlock) {
            self.waitUseBlock();
        }
    }];
    [self.waitEvaluateLbl bk_whenTapped:^{
        if (self.waitEvaluateBlock) {
            self.waitEvaluateBlock();
        }
    }];
    [self.afterLbl bk_whenTapped:^{
        if (self.afterBlock) {
            self.afterBlock();
        }
    }];
    
    NSArray* nums = @[@"0",@"0",@"0"],*status = @[@"待使用",@"待评价",@"退款/售后"];
    int i = 0;
    for (UILabel* lbl in @[self.waitUseLbl,self.waitEvaluateLbl,self.afterLbl]) {
        NSString* text = [NSString stringWithFormat:@"%@\n%@",nums[i],status[i]];
        NSMutableAttributedString* attStr = [[NSMutableAttributedString alloc] initWithString:text];
        [attStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:16] range:NSMakeRange(0, @"1".length)];
        [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor hyBlackTextColor] range:NSMakeRange(0, @"1".length)];
        lbl.attributedText = attStr;
        i++;
    }

//    [self.userHeadImg sd_setImageWithURL:[NSURL URLWithString:model[@""]]];
    [self.userHeadImg sd_setImageWithURL:[NSURL URLWithString:@"https://ss0.bdstatic.com/94oJfD_bAAcT8t7mm9GUKT-xh_/timg?image&quality=100&size=b4000_4000&sec=1488509505&di=97cda624db932332a70ee8018c9b0848&src=http://img1.7wenta.com/upload/qa_headIcons/20150122/14219365390308909.jpg"]];
//    self.userNameLbl.text = model[@"name"];
    
}

@end
