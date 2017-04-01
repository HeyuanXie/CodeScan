//
//  MineYearCardCell.m
//  Base
//
//  Created by admin on 2017/3/16.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "MineYearCardCell.h"

@interface MineYearCardCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *numLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UILabel *countLbl;


@end

@implementation MineYearCardCell

+(NSString *)identify {
    return NSStringFromClass([self class]);
}

-(void)configYearCardCell:(id)model {
    
    self.titleLbl.text = model[@"card_name"];
    self.numLbl.text = model[@"card_sn"];
    self.timeLbl.text = [[model[@"expire_time"] componentsSeparatedByString:@" "] firstObject];
    self.countLbl.text = [model[@"left_times"] stringValue];
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
