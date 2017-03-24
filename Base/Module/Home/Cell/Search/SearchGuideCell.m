//
//  SearchGuideCell.m
//  Base
//
//  Created by admin on 2017/3/23.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "SearchGuideCell.h"

@interface SearchGuideCell ()

@end

@implementation SearchGuideCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+(NSString *)identify {
    return NSStringFromClass([self class]);
}

-(void)configGuideHistoryCell:(id)model {
    
    self.closeAllBtn.hidden = YES;
    self.closeView.hidden = NO;
    self.titleLbl.hidden = NO;
    self.titleLbl.textColor = [UIColor hyBlackTextColor];
}

-(void)configGuideHeadCell {
    
    self.contentView.backgroundColor = [UIColor hyViewBackgroundColor];
    self.closeView.hidden = YES;
    self.closeAllBtn.hidden = YES;
    self.titleLbl.textColor = RGB(208, 208, 208, 1.0);
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

-(void)configGuideClearAllCell {
    
    self.closeAllBtn.hidden = NO;
    self.titleLbl.hidden = YES;
    self.closeView.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
