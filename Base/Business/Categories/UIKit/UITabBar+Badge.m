//
//  UITabBar+Badge.m
//  Base
//
//  Created by admin on 17/1/16.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "UITabBar+Badge.h"

static CGFloat const tabbarItemNums = 4.0;

@implementation UITabBar (Badge)

- (void)showBadgeValue:(NSString *) value OnItemIndex:(NSInteger ) index{
    
    [self hideBadgeOnItemIndex:index];
    
    UILabel *badgeLabel = [[UILabel alloc] init];
    badgeLabel.tag = 888 + index;
    badgeLabel.text = value;
    badgeLabel.textColor = [UIColor whiteColor];
    badgeLabel.font = [UIFont systemFontOfSize:12.f];
    [badgeLabel sizeToFit];
    badgeLabel.textAlignment = NSTextAlignmentCenter;
    badgeLabel.backgroundColor = [UIColor redColor];//颜色：红色
    CGRect tabFrame = self.frame;
    
    
    
    //确定小红点的位置
    float percentX = (index +0.57) / tabbarItemNums;
    CGFloat x = ceilf(percentX * tabFrame.size.width);
    CGFloat y = ceilf(0.08 * tabFrame.size.height);
    CGRect rect;
    
    if (CGSizeEqualToSize(badgeLabel.frame.size, CGSizeZero) ) {
        rect = CGRectMake(x, y, 8, 8);
    }else{
        
        rect = CGRectMake(x, y, CGRectGetWidth(badgeLabel.frame) < 16.f ? 16 : CGRectGetWidth(badgeLabel.frame), CGRectGetHeight(badgeLabel.frame));
    }
    
    badgeLabel.frame = rect;
    
    badgeLabel.layer.cornerRadius = CGRectGetHeight(badgeLabel.frame) / 2.f;
    badgeLabel.layer.masksToBounds = YES;
    [self addSubview:badgeLabel];
}

- (void)hideBadgeOnItemIndex:(NSInteger ) index{
    [self removeBadgeOnItemIndex:index];
}

- (void)removeBadgeOnItemIndex:(NSInteger )index{
    //按照tag值进行移除
    for (UIView *subView in self.subviews) {
        if (subView.tag == 888+index) {
            [subView removeFromSuperview];
        }
    }
}

@end
