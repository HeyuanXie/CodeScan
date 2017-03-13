//
//  SkillListCell.m
//  Base
//
//  Created by admin on 2017/3/13.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "SkillListCell.h"

@interface SkillListCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UILabel *statuLbl;
@property (weak, nonatomic) IBOutlet UIImageView *imgV;
@property (weak, nonatomic) IBOutlet UILabel *countLbl;


@end

@implementation SkillListCell

+(NSString *)identify {
    return NSStringFromClass([self class]);
}

-(void)configListCell:(id)model {
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [HYTool configViewLayer:self.statuLbl withColor:[UIColor hyRedColor]];
    [HYTool configViewLayer:self.statuLbl size:19/2];
    self.statuLbl.textColor = [UIColor hyRedColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
