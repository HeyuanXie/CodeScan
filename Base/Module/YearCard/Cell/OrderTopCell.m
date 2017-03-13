//
//  OrderTopCell.m
//  Base
//
//  Created by admin on 2017/3/10.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "OrderTopCell.h"

@interface OrderTopCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgV;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *descLbl;


@end

@implementation OrderTopCell


+(NSString *)identify {
    return NSStringFromClass([self class]);
}

-(void)configTopCell:(id)model {
    
    self.imgV.image = ImageNamed(@"yazi");
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