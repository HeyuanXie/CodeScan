//
//  ThreeImgCell.m
//  Base
//
//  Created by admin on 2017/1/22.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "ThreeImgCell.h"

@implementation ThreeImgCell

+(NSString *)identify {
    return NSStringFromClass([ThreeImgCell class]);
}
- (IBAction)policyAction:(id)sender {
    self.policy();
}
- (IBAction)guideAction:(id)sender {
    self.guide();
}
- (IBAction)demandAction:(id)sender {
    self.demand();
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
