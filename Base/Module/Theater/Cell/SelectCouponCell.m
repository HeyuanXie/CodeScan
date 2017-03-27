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
    
    self.colorView.backgroundColor = RGB(246, 200, 112, 1.0);
    self.topLbl.font = [UIFont systemFontOfSize:21];
    self.botLbl.font = [UIFont systemFontOfSize:14];
    self.topLbl.text = model[@"5元"];
    self.botLbl.text = @"满60元使用";
    
    self.cardNumLbl.hidden = YES;
    
    self.titleLbl.text = @"观剧代金券";
}

-(void)configYearCardCell:(id)model {
    
    self.colorView.backgroundColor = RGB(108, 180, 245, 1.0);
    self.topLbl.font = [UIFont systemFontOfSize:14];
    self.botLbl.font = [UIFont systemFontOfSize:21];
    self.topLbl.text = @"剩余观看次数";
    self.botLbl.text = @"11";
    
    self.cardNumLbl.hidden = NO;
    
    self.titleLbl.text = @"飞象卡(1大1小)";

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
