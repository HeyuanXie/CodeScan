//
//  VideoCommentCell.m
//  Base
//
//  Created by admin on 2017/3/14.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "VideoCommentCell.h"

@implementation VideoCommentCell

+(NSString *)identify {
    return NSStringFromClass([self class]);
}

-(void)configCommentCell:(id)model {
    
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
