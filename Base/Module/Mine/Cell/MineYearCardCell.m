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
    self.numLbl.text = [NSString stringWithFormat:@"卡号: %@",model[@"card_sn"]];
    self.timeLbl.text = [NSString stringWithFormat:@"有效期至: %@",[HYTool dateStringWithString:model[@"expire_time"] inputFormat:nil outputFormat:@"yyyy-MM-dd"]];
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
