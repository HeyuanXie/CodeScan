//
//  OrderRefundCell.m
//  Base
//
//  Created by admin on 2017/3/20.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "OrderRefundCell.h"

@interface OrderRefundCell ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftViewWidth;

@property (weak, nonatomic) IBOutlet UILabel *rightLbl;

@end

@implementation OrderRefundCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+(NSString *)identify {
    return NSStringFromClass([self class]);
}

-(void)configDeriveRefundCell {
    self.leftViewWidth.constant = 0;
    self.rightLbl.text = @"过期无效,积分不予以退还";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
