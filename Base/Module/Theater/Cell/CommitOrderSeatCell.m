//
//  CommitOrderSeatCell.m
//  Base
//
//  Created by admin on 2017/3/27.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "CommitOrderSeatCell.h"
#import "FVSeatItem.h"

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
    self.pirceLbl.text = [NSString stringWithFormat:@"%.2f",seatInfo.realPrice];
}

-(void)configVipCell:(id)model row:(NSInteger)row cardIndexs:(NSArray*)cardIndexs {
    
    FVSeatItem* seat = (FVSeatItem*)model;
    self.selelctBtn.selected = NO;
    self.selelctBtn.hidden = NO;
    self.originalPriceView.hidden = YES;
    self.pirceLbl.text = [NSString stringWithFormat:@"%.2f",seat.realPrice];
    [self.selelctBtn setImage:ImageNamed(@"未选择") forState:UIControlStateNormal];
    [self.selelctBtn setImage:ImageNamed(@"已选择") forState:UIControlStateSelected];
    self.pirceLblLeading.constant = kScreen_Width/2;
    self.seatLbl.text = seat.seatName;
    
    for (NSNumber* index in cardIndexs) {
        if ([index integerValue] == row) {
            self.selelctBtn.selected = YES;
            self.originalPriceView.hidden = NO;
            self.pirceLbl.text = [NSString stringWithFormat:@"%.2f",seat.cardPrice];
            self.originalPriceLbl.text = [NSString stringWithFormat:@"%.2f",seat.realPrice];
            break;  //要加上break
        }else{
            self.originalPriceView.hidden = YES;
            self.originalPriceLbl.text = [NSString stringWithFormat:@"%.2f",seat.realPrice];
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
