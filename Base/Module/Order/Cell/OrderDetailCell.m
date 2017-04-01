//
//  OrderDetailCell.m
//  Base
//
//  Created by admin on 2017/3/20.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "OrderDetailCell.h"
#import "NSString+Extension.h"

@interface OrderDetailCell ()

@property (weak, nonatomic) IBOutlet UILabel *orderNumLbl;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumLbl;
@property (weak, nonatomic) IBOutlet UILabel *personNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *countLbl;
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;


@end

@implementation OrderDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+(NSString *)identify {
    return NSStringFromClass([self class]);
}

-(void)configDetailCell:(id)model type:(NSString *)type {
    
    if (model == nil) {
        return;
    }
    self.orderNumLbl.text = model[@"order_sn"];
    self.phoneNumLbl.text = model[@"mobile"];
    self.personNameLbl.text = model[@"consignee"];
    self.countLbl.text = [NSString stringWithFormat:@"%ld",[model[@"goods_num"] integerValue]] ;
    if ([type isEqualToString:@"derive"]) {
        self.priceLbl.text = [NSString stringWithFormat:@"%ld 积分",[model[@"exchange_total_price"] integerValue]];
    }else{
        self.priceLbl.text = [NSString stringWithFormat:@"¥ %ld",[model[@"exchange_total_price"] integerValue]];
        self.priceLbl.attributedText = [self.priceLbl.text addAttribute:@[NSFontAttributeName] values:@[[UIFont systemFontOfSize:13]] subStrings:@[@"¥"]];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
