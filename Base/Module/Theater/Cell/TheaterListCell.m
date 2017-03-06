//
//  TheaterListCell.m
//  Base
//
//  Created by admin on 2017/3/6.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "TheaterListCell.h"

@implementation TheaterListCell

+(NSString *)identify {
    return NSStringFromClass([self class]);
}

-(void)configTheaterListCell:(id)model {
    
    @weakify(self);
    [self.ticketBtn bk_whenTapped:^{
        @strongify(self);
        if (self.ticketBtnClick) {
            self.ticketBtnClick(model);
        }
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [HYTool configViewLayer:self.backView];
    [HYTool configViewLayer:self.imgV];
    [HYTool configViewLayer:self.ticketBtn withColor:[UIColor hyBlueTextColor]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
