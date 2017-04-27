//
//  RefundDetailCell.m
//  Base
//
//  Created by admin on 2017/4/24.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "RefundDetailCell.h"

@interface RefundDetailCell ()

@property (weak, nonatomic) IBOutlet UILabel *successLbl;
@property (weak, nonatomic) IBOutlet UIImageView *imgV;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *detailLbl;

@end

@implementation RefundDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [HYTool configViewLayerFrame:self.successLbl WithColor:[UIColor redColor] borderWidth:1];
    [HYTool configViewLayer:self.successLbl size:17];
    self.successLbl.textColor = [UIColor redColor];
}

+(NSString *)identify {
    return NSStringFromClass([self class]);
}

-(void)configRefundDetailCell:(id)model {
    
    self.titleLbl.text = model[@"title"];
    self.detailLbl.text = model[@"sub_title"];
    [self.imgV sd_setImageWithURL:[NSURL URLWithString:model[@"thumb"]] placeholderImage:nil];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
