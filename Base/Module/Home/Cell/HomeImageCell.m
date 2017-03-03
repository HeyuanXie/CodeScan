//
//  HomeImageCell.m
//  Template
//
//  Created by admin on 2017/2/16.
//  Copyright © 2017年 hitao. All rights reserved.
//

#import "HomeImageCell.h"

@implementation HomeImageCell

+(NSString *)identify {
    return NSStringFromClass([self class]);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self subviewBind];
}


-(void)subviewBind {
    NSInteger index = 0;
    for (UIView* botSubview in self.botSubViews) {
        [botSubview bk_whenTapped:^{
            if (self.botSubviewClick) {
                self.botSubviewClick(index);
            }
        }];
        index++;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
