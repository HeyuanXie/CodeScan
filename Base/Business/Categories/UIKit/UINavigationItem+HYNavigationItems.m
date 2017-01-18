//
//  UINavigationItem+HYNavigationItems.m
//  Base
//
//  Created by admin on 17/1/16.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "UINavigationItem+HYNavigationItems.h"

@implementation UINavigationItem (HYNavigationItems)

- (void)customTitle:(NSString *)title {
    UILabel *titleLabel = ({
        UILabel * label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        CGRect frame = CGRectMake(- (kScreen_Width -100)/2, -15, kScreen_Width - 100, 30);
        label.frame = frame;
        label.font = [UIFont systemFontOfSize:18];
        label.text = (title ? title : @"");
        label;
    });
    
    UIView *titleView = [[UIView alloc] init];
    [titleView addSubview:titleLabel];
    self.titleView = titleView;
}

- (void)customBackTarget:(id)target action:(SEL)action {
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed: @"nav_back"]
                                                                 style:UIBarButtonItemStylePlain
                                                                target:target
                                                                action:action];
    self.leftBarButtonItem = backItem;
}

- (void)customBackIcon:(NSString *)iconName target:(id)target action:(SEL)action {
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed: iconName]
                                                                 style:UIBarButtonItemStylePlain
                                                                target:target
                                                                action:action];
    self.leftBarButtonItem = backItem;
}

@end
