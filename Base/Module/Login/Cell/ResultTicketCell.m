//
//  ResultTicketCell.m
//  Base
//
//  Created by admin on 2017/5/9.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "ResultTicketCell.h"

@implementation ResultTicketCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (NSString *)identify {
    return NSStringFromClass([self class]);
}

- (void)configTicketCell:(id)model {
    self.seatLbl.text = model[@"seat_name"];
    if ([model[@"status"] integerValue] == 1) {
        self.selectBtnWidth.constant = 0;
        self.statuLBl.text = @"已出票";
        self.seatLbl.textColor = [UIColor hyGrayTextColor];
        self.statuLBl.textColor = [UIColor hyGrayTextColor];
    }else{
        self.selectBtnWidth.constant = 48;
        self.statuLBl.text = @"未出票";
        self.seatLbl.textColor = [UIColor hyBlackTextColor];
        self.statuLBl.textColor = [UIColor hyBlackTextColor];
        [self.selectBtn bk_whenTapped:^{
            if (self.selectBtnClick) {
                self.selectBtnClick();
            }
        }];
//        [self.selectBtn setImage:ImageNamed(@"已选择") forState:UIControlStateSelected];
        [self.selectBtn setImage:ImageNamed(@"未选择") forState:(UIControlStateNormal)];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
