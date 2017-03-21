//
//  YearCardOrderCommonCell.m
//  Base
//
//  Created by admin on 2017/3/21.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "YearCardOrderCommonCell.h"

@interface YearCardOrderCommonCell ()

@property (weak, nonatomic) IBOutlet UILabel *lbl;

@end

@implementation YearCardOrderCommonCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.textField.userInteractionEnabled = NO;
}

+(NSString *)identify {
    return NSStringFromClass([self class]);
}

-(void)configYearCardOrderCommonCell:(id)model {
    self.eyeBtn.hidden = YES;
    self.lbl.text = @"卡号: ";
    self.textField.text = @"12334534536456";
}

-(void)configYearCardOrderCommonEyeCell:(id)model {
    
    self.lbl.text = @"密码: ";
    self.textField.text = @"123456";
}

- (IBAction)eyeBtnClick:(id)sender {
    if (self.eyeClick) {
        self.eyeClick();
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
