//
//  MineCouponCell.m
//  Base
//
//  Created by admin on 2017/3/17.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "MineCouponCell.h"
#import "NSString+Extension.h"

@interface MineCouponCell ()

@property (weak, nonatomic) IBOutlet UILabel *moneyLbl;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *conditionLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;

@end

@implementation MineCouponCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


+(NSString *)identify {
    return NSStringFromClass([self class]);
}

-(void)configCouponCell:(CouponModel*)model {
    
    self.moneyLbl.text = [NSString stringWithFormat:@"%@元",[[model.couponAmount componentsSeparatedByString:@"."] firstObject]];
    self.moneyLbl.attributedText = [self.moneyLbl.text addAttribute:@[NSFontAttributeName] values:@[[UIFont systemFontOfSize:16]] subStrings:@[@"元"]];

    self.titleLbl.text = model.orderType.integerValue == 1 ? @"观剧代金券" : @"年卡代金券";
    self.conditionLbl.text = [NSString stringWithFormat:@"限满%@元使用",model.usedAmount];
    self.timeLbl.text = [NSString stringWithFormat:@"有效期至 %@",model.expireTime];
}

@end
