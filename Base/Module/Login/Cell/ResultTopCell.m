//
//  ResultTopCell.m
//  Base
//
//  Created by admin on 2017/5/9.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "ResultTopCell.h"

@implementation ResultTopCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (NSString *)identify {
    return NSStringFromClass([self class]);
}

- (void)configTheaterCell:(id)model {
    
    self.titleLbl.text = model[@"play_name"];
    NSString* playTime = model[@"play_time"];
    NSString* week = [HYTool weekStirngWithDate:[HYTool dateWithString:playTime format:nil]];
    NSString* time = [[HYTool dateStringWithString:playTime inputFormat:nil outputFormat:@"yyyy-MM-dd HH:mm"] stringByReplacingOccurrencesOfString:@" " withString:[NSString stringWithFormat:@" %@ ",week]];
    self.detailLbl.text = [NSString stringWithFormat:@"场次: %@",time];
    self.statuLbl.hidden = YES;
    [self.allBtn bk_whenTapped:^{
        if (self.allBtnClick) {
            self.allBtnClick();
        }
    }];
}

- (void)configDeriveCell:(id)model {
    
    self.titleLbl.text = model[@"goods_name"];
    self.detailLbl.text = [NSString stringWithFormat:@"数量: %ld   有效期: %@",[model[@"goods_num"] integerValue],model[@"expire_time"]];
    self.statuLbl.hidden = [model[@"status"] integerValue] == 0;
    self.allBtn.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
