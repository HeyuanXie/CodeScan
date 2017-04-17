//
//  CommitOrderSeatCell.m
//  Base
//
//  Created by admin on 2017/3/27.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "CommitOrderSeatCell.h"

@interface CommitOrderSeatCell ()

@end

@implementation CommitOrderSeatCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+(NSString *)identify {
    return NSStringFromClass([self class]);
}

-(void)configNotVipCell:(id)model {

    self.pirceLblLeading.constant = kScreen_Width-40-12;
    self.originalPriceView.hidden = YES;
    self.selelctBtn.hidden = YES;
    
    FVSeatItem* seatInfo = (FVSeatItem*)model;
    self.seatLbl.text = seatInfo.seatName;
    self.pirceLbl.text = [NSString stringWithFormat:@"%.2d",seatInfo.price];
}

-(void)configVipCell:(id)model {
    
    self.originalPriceView.hidden = YES;
    self.selelctBtn.selected = NO;
    [self.selelctBtn setImage:ImageNamed(@"未选择") forState:UIControlStateNormal];
    [self.selelctBtn setImage:ImageNamed(@"已选择") forState:UIControlStateSelected];
    self.pirceLblLeading.constant = kScreen_Width/2;
    self.originalPriceLbl.text = @"¥180";
    self.selelctBtn.hidden = NO;
    
    FVSeatItem* seatInfo = (FVSeatItem*)model;
    self.seatLbl.text = seatInfo.seatName;
    self.pirceLbl.text = [NSString stringWithFormat:@"%.2f",(CGFloat)(seatInfo.price)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
