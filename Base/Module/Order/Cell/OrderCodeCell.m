//
//  OrderCodeCell.m
//  Base
//
//  Created by admin on 2017/3/20.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "OrderCodeCell.h"
#import "ZXingWrapper.h"

@interface OrderCodeCell ()

@property (weak, nonatomic) IBOutlet UIImageView *codeImgV;
@property (weak, nonatomic) IBOutlet UILabel *passwordLbl;

@end

@implementation OrderCodeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

}

+(NSString *)identify {
    return NSStringFromClass([self class]);
}

-(void)configCodeCell:(id)model isDerive:(BOOL)isDerive {
    
    if (!model) {
        return;
    }

    if (isDerive) {
        NSString* qrCode = model[@"exchange_barcode"][0][@"qrcode"];
        NSString* password = model[@"exchange_barcode"][0][@"code"];
        self.codeImgV.image = [ZXingWrapper createCodeWithString:qrCode size:CGSizeMake(140, 140) CodeFomart:kBarcodeFormatQRCode];
        self.passwordLbl.text = [NSString stringWithFormat:@"消费密码: %@",password];
    }else{
        NSString* qrCode = model[@"qrcode"];
        NSString* password = model[@"sncode"];
        self.codeImgV.image = [ZXingWrapper createCodeWithString:qrCode size:CGSizeMake(400, 400) CodeFomart:kBarcodeFormatQRCode];
         self.passwordLbl.text = [NSString stringWithFormat:@"消费密码: %@",password];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
