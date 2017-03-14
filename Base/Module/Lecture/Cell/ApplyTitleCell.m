//
//  ApplyTitleCell.m
//  Base
//
//  Created by admin on 2017/3/9.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "ApplyTitleCell.h"

@interface ApplyTitleCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *expertLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;

@end

@implementation ApplyTitleCell


+(NSString *)identify {
    return NSStringFromClass([self class]);
}

-(void)configTitleCell:(id)model {
    //...
}

-(void)configSkillApplyTitleCell:(id)model {
    
    self.timeLbl.hidden = YES;
    //...
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
