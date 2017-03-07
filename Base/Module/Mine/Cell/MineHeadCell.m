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
    
    [self.headImgV sd_setImageWithURL:[NSURL URLWithString:@"https://ss0.bdstatic.com/94oJfD_bAAcT8t7mm9GUKT-xh_/timg?image&quality=100&size=b4000_4000&sec=1488509505&di=97cda624db932332a70ee8018c9b0848&src=http://img1.7wenta.com/upload/qa_headIcons/20150122/14219365390308909.jpg"]];
    
    [self.contentView bk_whenTapped:^{
        //TODO:进入个人信息页面
//        APPROUTE(<#storyboardID#>)
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [HYTool configViewLayerFrame:self.headImgV WithColor:[UIColor whiteColor] borderWidth:2];
    [HYTool configViewLayerRound:self.headImgV];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
