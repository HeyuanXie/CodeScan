//
//  HomeVideoCell.m
//  Base
//
//  Created by admin on 2017/3/3.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "HomeVideoCell.h"

@implementation HomeVideoCell

+(NSString *)identify {
    return NSStringFromClass([self class]);
}

-(void)configVideoCell:(id)model {
    NSInteger i = 0;
    for (HomeVideoView* videoView in self.subViews) {
        //TODO:
//        id videoModel = model[i];
//        [videoView configVideoView:videoModel];
        [videoView configVideoView:nil];
        [videoView bk_whenTapped:^{
            //TODO:点击videoView
            
        }];
        i++;
    }
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
