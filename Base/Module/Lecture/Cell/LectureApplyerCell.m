//
//  LectureApplyerCell.m
//  Base
//
//  Created by admin on 2017/3/9.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "LectureApplyerCell.h"

@interface LectureApplyerCell ()

@property (weak, nonatomic) IBOutlet UIView *topView;


@end

@implementation LectureApplyerCell

+(NSString*)identify {
    return NSStringFromClass([self class]);
}

+(CGFloat)height:(id)model {
    if (0) {
        //少于6个
        return 70+43+12;
    }
    return 185;
}

- (IBAction)seeAllClick:(id)sender {
    if (self.seeAll) {
        self.seeAll();
    }
}

-(void)configApplyerCell:(id)model {
    
    
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
