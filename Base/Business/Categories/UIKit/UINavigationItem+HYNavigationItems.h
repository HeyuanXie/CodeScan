//
//  UINavigationItem+HYNavigationItems.h
//  Base
//
//  Created by admin on 17/1/16.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationItem (HYNavigationItems)

- (void)customTitle:(NSString *)title;

- (void)customBackTarget:(id)target action:(SEL)action;

- (void)customBackIcon:(NSString *)iconName target:(id)target action:(SEL)action;

@end
