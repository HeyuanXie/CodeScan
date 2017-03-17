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
    
    self.moneyLbl.attributedText = [self.moneyLbl.text addAttribute:@[NSFontAttributeName] values:@[[UIFont systemFontOfSize:16]] subStrings:@[@"元"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


+(NSString *)identify {
    return NSStringFromClass([self class]);
}

-(void)configCouponCell:(id)model {
    
}

@end
