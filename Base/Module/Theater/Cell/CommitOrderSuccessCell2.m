//
//  CommitOrderSuccessCell2.m
//  Base
//
//  Created by admin on 2017/3/28.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "CommitOrderSuccessCell2.h"

@interface CommitOrderSuccessCell2 ()

@property (weak, nonatomic) IBOutlet UIImageView *imgV;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;
@property (weak, nonatomic) IBOutlet UILabel *addressLbl;


@end

@implementation CommitOrderSuccessCell2

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+(NSString *)identify {
    return NSStringFromClass([self class]);
}

-(void)configDeriveCell:(id)model {
    if (model==nil) {
        return;
    }
    if (![model[@"thumb_img"] isEqualToString:@""]) {
        [self.imgV sd_setImageWithURL:[NSURL URLWithString:model[@"thumb_img"]] placeholderImage:nil];
    }
    self.titleLbl.text = model[@"goods_name"];
    self.priceLbl.text = model[@"total_price"];
    self.addressLbl.text = model[@"exchange_place"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
