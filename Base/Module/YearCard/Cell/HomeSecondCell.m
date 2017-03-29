//
//  HomeSecondCell.m
//  Base
//
//  Created by admin on 2017/3/10.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "HomeSecondCell.h"

@interface HomeSecondCell ()

@property (weak, nonatomic) IBOutlet UILabel *detailLbl;
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;

@end

@implementation HomeSecondCell

+(NSString *)identify {
    return NSStringFromClass([self class]);
}

-(void)configSecondCell:(id)model {
    if (model) {
        self.priceLbl.text = model[@"price"];
        self.detailLbl.text = [NSString stringWithFormat:@"一年%@次观剧机会, 一次限两人",model[@"total_times"]];
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
