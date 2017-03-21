//
//  WeekEndTopView.m
//  Base
//
//  Created by admin on 2017/3/21.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "WeekEndTopView.h"


@implementation WeekEndTopView

-(void)awakeFromNib {
    
    [self.firstView bk_whenTapped:^{
        if (self.firstClick) {
            self.firstClick();
        }
    }];
    [self.secondView bk_whenTapped:^{
        if (self.secondClick) {
            self.secondClick();
        }
    }];
    [self.thirdView bk_whenTapped:^{
        if (self.thirdClick) {
            self.thirdClick();
        }
    }];
}

@end
