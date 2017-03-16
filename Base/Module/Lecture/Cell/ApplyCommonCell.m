//
//  ApplyCommonCell.m
//  Base
//
//  Created by admin on 2017/3/9.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "ApplyCommonCell.h"
#import "NSString+Extension.h"

@implementation ApplyCommonCell

+(NSString *)identify {
    return NSStringFromClass([self class]);
}

-(void)configCommonCell:(id)model count:(NSInteger)count {
    BOOL necessary = [model[@"necessary"] boolValue];
    NSString* title = model[@"title"];
    if (necessary) {
        NSString* text = [@"*" stringByAppendingString:title];
        self.titleLbl.attributedText = [text attributedStringWithString:@"*" andWithColor:[UIColor hyRedColor]];
    }else{
        self.titleLbl.text = title;
    }
    self.numLbl.text = [NSString stringWithFormat:@"%ld",count];
    
    self.subLbl.userInteractionEnabled = YES;
    self.addLbl.userInteractionEnabled = YES;
    @weakify(self);
    [self.subLbl bk_whenTapped:^{
        @strongify(self);
        if ([self.numLbl.text integerValue]==1) {
            return ;
        }
        if (self.subClick) {
            self.subClick();
        }
    }];
    [self.addLbl bk_whenTapped:^{
        @strongify(self);
        if (self.addClick) {
            self.addClick();
        }
    }];
}

- (void)configSkillApplyCommonCell:(id)model {
    
    BOOL necessary = [model[@"necessary"] boolValue];
    NSString* title = model[@"title"];
    self.inputTf.userInteractionEnabled = ([title isEqualToString:@"上传宝宝头像:"] || [title isEqualToString:@"性别:"] || [title isEqualToString:@"所在城市:"]) ? NO : YES;
    self.accessoryType = ([title isEqualToString:@"上传宝宝头像:"] || [title isEqualToString:@"性别:"] || [title isEqualToString:@"所在城市:"]) ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
    self.countView.hidden = YES;
    
    if ([title isEqualToString:@"上传宝宝头像:"]) {
        self.titleLblWidth.constant = 100;
    }else{
        self.titleLblWidth.constant = 70;
    }
    
    if (necessary) {
        NSString* text = [@"*" stringByAppendingString:title];
        self.titleLbl.attributedText = [text attributedStringWithString:@"*" andWithColor:[UIColor hyRedColor]];
    }else{
        self.titleLbl.text = title;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [HYTool configViewLayer:self.countView withColor:[UIColor hySeparatorColor]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
