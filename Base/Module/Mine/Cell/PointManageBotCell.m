//
//  PointManageBotCell.m
//  Base
//
//  Created by admin on 2017/3/16.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "PointManageBotCell.h"

@interface PointManageBotCell ()

@property (weak, nonatomic) IBOutlet UIView *firstView;

@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *finishLbl;
@property (weak, nonatomic) IBOutlet UILabel *numLbl;

@end

@implementation PointManageBotCell

+(NSString *)identify {
    return NSStringFromClass([self class]);
}

-(void)configPointManageBotCell:(id)model indexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        self.firstView.hidden = NO;
    }else{
        self.firstView.hidden = YES;
    }
    
    self.titleLbl.text = model[@"rule_name"];
    self.numLbl.text = [NSString stringWithFormat:@"+%@",[model[@"rule_action"] stringValue]];
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
