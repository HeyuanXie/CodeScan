//
//  PointManageTopCell.m
//  Base
//
//  Created by admin on 2017/3/16.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "PointManageTopCell.h"
#import "NSDate+HYFormat.h"

@interface PointManageTopCell ()

@property (weak, nonatomic) IBOutlet UIView *recordView;
@property (weak, nonatomic) IBOutlet UIView *detailView;
@property (weak, nonatomic) IBOutlet UIView *ruleView;

@property (weak, nonatomic) IBOutlet UILabel *pointLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;

@end

@implementation PointManageTopCell

+(NSString *)identify {
    return NSStringFromClass([self class]);
}

-(void)configPointManageTopCell:(id)minePoint canSign:(NSInteger)canSign {
    if (canSign == 0) {
        [self.qiandaoBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        self.qiandaoBtn.layer.borderColor = [UIColor grayColor].CGColor;
        [self.qiandaoBtn setImage:ImageNamed(@"") forState:UIControlStateNormal];
        [self.qiandaoBtn setTitle:@"已签到" forState:UIControlStateNormal];
    }else{
        [self.qiandaoBtn setTitleColor:[UIColor hyBlueTextColor] forState:UIControlStateNormal];
        self.qiandaoBtn.layer.borderColor = [UIColor hyBlueTextColor].CGColor;
        [self.qiandaoBtn setImage:ImageNamed(@"签到图标") forState:UIControlStateNormal];
        [self.qiandaoBtn setTitle:@"签到+1" forState:UIControlStateNormal];
    }
    [self.recordView bk_whenTapped:^{
        APPROUTE(kDeriveRecordController);
    }];
    [self.detailView bk_whenTapped:^{
        APPROUTE(kPointDetailController);
    }];
    [self.ruleView bk_whenTapped:^{
        APPROUTE(kPointDescController);
    }];
    [self.qiandaoBtn bk_whenTapped:^{
        if (self.qianDaoClick) {
            self.qianDaoClick();
        }
    }];
    self.pointLbl.text = [minePoint stringValue];
    self.timeLbl.text = [[NSDate dateStringWithDate:[NSDate date] format:@"yyyy"] stringByAppendingString:@"-12-30"];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [HYTool configViewLayer:self.qiandaoBtn withColor:[UIColor hyBarTintColor]];
    [HYTool configViewLayer:self.qiandaoBtn size:16];
    [self.qiandaoBtn setTitleColor:[UIColor hyBarTintColor] forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
