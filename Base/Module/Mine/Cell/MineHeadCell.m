//
//  MineHeadCell.m
//  Base
//
//  Created by admin on 2017/3/7.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "MineHeadCell.h"

@interface MineHeadCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headImgV;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;

@end

@implementation MineHeadCell

+(NSString *)identify {
    return NSStringFromClass([self class]);
}

-(void)configHeadCell:(id)model {
    
    if (![Global userAuth]) {
        self.nameLbl.text = @"未登陆";
        self.headImgV.image = ImageNamed(@"小飞象logo");
    }else{
        [self.headImgV sd_setImageWithURL:[NSURL URLWithString:APIHELPER.userInfo.faceUrl] placeholderImage:ImageNamed(@"")];
        self.nameLbl.text = [APIHELPER userInfo].nickName;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [HYTool configViewLayerFrame:self.headImgV WithColor:[UIColor whiteColor] borderWidth:2];
    [HYTool configViewLayer:self.headImgV size:zoom(185)*67/(185*2)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
