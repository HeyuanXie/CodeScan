//
//  RecentHotView.m
//  Base
//
//  Created by admin on 2017/3/3.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "RecentHotView.h"
@implementation RecentHotView


+(CGSize)homeSize {
    return CGSizeMake(147, 230);
}

+(CGSize)showDetailSize {
    return CGSizeMake(110, 180);
}

-(void)configRecentView:(TheaterModel*)model {
    
    [self bk_whenTapped:^{
        if (self.recentViewClick) {
            self.recentViewClick(model);
        }
    }];
    TheaterModel* theater = (TheaterModel*)model;
    [self.imgV sd_setImageWithURL:[NSURL URLWithString:theater.picurl] placeholderImage:ImageNamed(@"elephant")];
    NSString* playName = [[theater.playName stringByReplacingOccurrencesOfString:@"《" withString:@""] stringByReplacingOccurrencesOfString:@"》" withString:@""];
    self.desLbl.text = [NSString stringWithFormat:@"%@ %@——%@",theater.sydate,theater.subTitle,playName];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
