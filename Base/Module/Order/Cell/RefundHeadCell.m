//
//  RefundHeadCell.m
//  Base
//
//  Created by admin on 2017/3/28.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "RefundHeadCell.h"

@interface RefundHeadCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgV;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *detailLbl;

@end

@implementation RefundHeadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+(NSString *)identify {
    return NSStringFromClass([self class]);
}

-(void)configHeadCell:(id)model {
    
    [self.imgV sd_setImageWithURL:model[@"thumb"] placeholderImage:nil];
    self.titleLbl.text = model[@"title"];
    self.detailLbl.text = model[@"sub_title"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
