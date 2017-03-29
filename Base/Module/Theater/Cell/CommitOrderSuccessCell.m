//
//  CommitOrderSuccessCell.m
//  Base
//
//  Created by admin on 2017/3/28.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "CommitOrderSuccessCell.h"

@interface CommitOrderSuccessCell ()

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIImageView *imgV;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *detailLbl;

@property (weak, nonatomic) IBOutlet UILabel *priceLbl;
@property (weak, nonatomic) IBOutlet UILabel *seatLbl;
@property (weak, nonatomic) IBOutlet UILabel *addressLbl;

@end

@implementation CommitOrderSuccessCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [HYTool configViewLayer:self.imgV size:3];
}

+(NSString *)identify {
    return NSStringFromClass([self class]);
}

-(void)configTheaterCell:(id)model {
    
    
}

-(void)configDeriveCell:(id)model
{
    self.seatLbl.hidden = YES;
    self.addressLbl.hidden = YES;
    
    self.priceLbl.text = @"地点: 东莞玉兰大剧场售票中心";
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
