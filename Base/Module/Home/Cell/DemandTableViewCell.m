//
//  DemandTableViewCell.m
//  Base
//
//  Created by admin on 2017/2/7.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "DemandTableViewCell.h"
#import "ZMDDemand.h"

@implementation DemandTableViewCell

+(NSString *)identify {
    return NSStringFromClass([DemandTableViewCell class]);
}

-(void)config:(id)model {
    ZMDDemand* demand = (ZMDDemand*)model;
    self.nameLbl.text = demand.jobName;
    self.companyLbl.text = demand.companyName;
    self.detailLbl.text = [NSString stringWithFormat:@"学历:%@ | 工作经验:%@",demand.edu,demand.exp];
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
