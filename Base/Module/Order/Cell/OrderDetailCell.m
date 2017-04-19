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

-(void)configDetailCell:(id)model type:(NSInteger)type {
    //type: 0-theatre, 1-derive, 2-card
    
    if (model == nil) {
        return;
    }
    self.orderNumLbl.text = model[@"order_sn"];
    self.phoneNumLbl.text = model[@"phone"];
    self.personNameLbl.text = model[@"consignee"];
    if (type==0) {
        self.phoneNumLbl.text = model[@"phone"];
        self.countLbl.text = [model[@"num"] stringValue];
        self.priceLbl.text = [NSString stringWithFormat:@"¥ %@",model[@"order_amount"]];
        self.priceLbl.attributedText = [self.priceLbl.text addAttribute:@[NSFontAttributeName] values:@[[UIFont systemFontOfSize:13]] subStrings:@[@"¥"]];
    }else if (type == 1){
        self.phoneNumLbl.text = model[@"mobile"];
        self.priceLbl.text = [NSString stringWithFormat:@"%.2f 积分",[model[@"exchange_price"] floatValue]];
        self.countLbl.text = [NSString stringWithFormat:@"%ld",[model[@"goods_num"] integerValue]] ;
    }else{
        self.phoneNumLbl.text = model[@"phone"];
        self.countLbl.text = model[@"count"];
        self.priceLbl.text = [NSString stringWithFormat:@"¥ %@",model[@"price"]];
        self.priceLbl.attributedText = [self.priceLbl.text addAttribute:@[NSFontAttributeName] values:@[[UIFont systemFontOfSize:13]] subStrings:@[@"¥"]];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
