//
//  SelectCouponCell.m
//  Base
//
//  Created by admin on 2017/3/27.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "SelectCouponCell.h"

@interface SelectCouponCell ()

@property (weak, nonatomic) IBOutlet UIView *colorView;

@property (weak, nonatomic) IBOutlet UILabel *topLbl;
@property (weak, nonatomic) IBOutlet UILabel *botLbl;

@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *cardNumLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;

@end

@implementation SelectCouponCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+(NSString *)identify {
    return NSStringFromClass([self class]);
}

-(void)configCouponCell:(id)model {
    
    CouponModel* coupon = (CouponModel*)model;
    self.colorView.backgroundColor = RGB(246, 200, 112, 1.0);
    self.topLbl.font = [UIFont systemFontOfSize:21];
    self.botLbl.font = [UIFont systemFontOfSize:14];
    self.topLbl.text = [[coupon.couponAmount componentsSeparatedByString:@"."] firstObject];
    self.botLbl.text = [NSString stringWithFormat:@"满%@元使用",[[coupon.usedAmount componentsSeparatedByString:@"."] firstObject]];
    self.cardNumLbl.hidden = YES;
    self.titleLbl.text = coupon.orderType.integerValue == 1 ? @"观剧代金券" : @"年卡代金券";
    self.timeLbl.text = [NSString stringWithFormat:@"有效期至: %@",coupon.expireTime];
}

-(void)configYearCardCell:(id)model {
    
    self.colorView.backgroundColor = RGB(108, 180, 245, 1.0);
    self.topLbl.font = [UIFont systemFontOfSize:14];
    self.botLbl.font = [UIFont systemFontOfSize:21];
    self.topLbl.text = @"剩余观看次数";
    self.botLbl.text = [NSString stringWithFormat:@"%ld",[model[@"left_times"] integerValue]];
    
    self.titleLbl.text = model[@"card_name"];
    self.cardNumLbl.hidden = NO;
    self.cardNumLbl.text = [NSString stringWithFormat:@"卡号: %@",model[@"card_sn"]];
    self.timeLbl.text = [NSString stringWithFormat:@"有效期至: %@",[HYTool dateStringWithString:model[@"expire_time"] inputFormat:nil outputFormat:@"yyyy-MM-dd"]];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
