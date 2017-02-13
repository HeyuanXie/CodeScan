//
//  GuideTableViewCell.m
//  Base
//
//  Created by admin on 2017/2/7.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "GuideTableViewCell.h"
#import <BlocksKit+UIKit.h>

@implementation GuideTableViewCell

+(NSString *)identify {
    return NSStringFromClass([GuideTableViewCell class]);
}

-(void)configCell {
//    NSArray* viewArr = @[_view1,_view2,_view3,_view3,_view5,_view6];
//    for (UIView* view in viewArr) {
//        [view bk_whenTapped:^{
//            NSInteger index = view.tag - 100;
//            NSLog(@"%ld",index);
//        }];
//    }
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
