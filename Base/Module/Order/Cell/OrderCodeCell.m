//
//  OrderCodeCell.m
//  Base
//
//  Created by admin on 2017/3/20.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "OrderCodeCell.h"

@interface OrderCodeCell ()

@property (weak, nonatomic) IBOutlet UIImageView *codeImgV;
@property (weak, nonatomic) IBOutlet UILabel *passwordLbl;
@property (weak, nonatomic) IBOutlet UILabel *seatLbl;
@property (weak, nonatomic) IBOutlet UILabel *statuLbl;

@property (weak, nonatomic) IBOutlet UIView *grayView;

@end

@implementation OrderCodeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [HYTool configViewLayerFrame:self.statuLbl WithColor:RGB(78, 78, 78, 1.0)];
    [HYTool configViewLayer:self.statuLbl size:10];
}

+(NSString *)identify {
    return NSStringFromClass([self class]);
}

-(void)configCodeCell:(id)model {
    
    self.grayView.hidden = YES;
    self.seatLbl.hidden = NO;
    self.statuLbl.hidden = NO;
    [self.codeImgV sd_setImageWithURL:[NSURL URLWithString:@"https://ss0.bdstatic.com/94oJfD_bAAcT8t7mm9GUKT-xh_/timg?image&quality=100&size=b4000_4000&sec=1490001149&di=1336a528fd7efc7386a985dd3c81bf23&src=http://pic1.fangketong.net/app_attach/201507/30/20150730_110_37862_0.jpg"] placeholderImage:nil];
}

-(void)configDeriveCodeCell:(id)model statu:(NSInteger)statu {
    
    self.seatLbl.hidden = YES;
    self.statuLbl.hidden = YES;
    self.grayView.hidden = statu == 1;
    
    self.passwordLbl.text = model[@"code"];
//    [self.codeImgV sd_setImageWithURL:[NSURL URLWithString:model[@"url"]] placeholderImage:nil];
    [self.codeImgV sd_setImageWithURL:[NSURL URLWithString:@"https://ss0.bdstatic.com/94oJfD_bAAcT8t7mm9GUKT-xh_/timg?image&quality=100&size=b4000_4000&sec=1490001149&di=1336a528fd7efc7386a985dd3c81bf23&src=http://pic1.fangketong.net/app_attach/201507/30/20150730_110_37862_0.jpg"] placeholderImage:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
