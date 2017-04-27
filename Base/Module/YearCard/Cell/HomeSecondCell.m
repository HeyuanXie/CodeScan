//
//  HomeSecondCell.m
//  Base
//
//  Created by admin on 2017/3/10.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "HomeSecondCell.h"
#import "NSString+Extension.h"

@interface HomeSecondCell ()

@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UILabel *alertLbl;
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;
@property (weak, nonatomic) IBOutlet UILabel *originalLbl;

@end

@implementation HomeSecondCell

+(NSString *)identify {
    return NSStringFromClass([self class]);
}

-(void)configSecondCell:(id)model {
    if (model) {
        self.timeLbl.text = model[@"time_limit"];
        self.timeLbl.attributedText = [self.timeLbl.text addAttribute:@[NSFontAttributeName] values:@[[UIFont systemFontOfSize:15]] subStrings:@[@"限时特惠"]];
        self.alertLbl.text = model[@"tips"];
        self.priceLbl.text = model[@"price"];
        self.originalLbl.text = [NSString stringWithFormat:@"¥%@",model[@"market_price"]];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
