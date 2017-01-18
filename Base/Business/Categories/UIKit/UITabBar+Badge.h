//
//  UITabBar+Badge.h
//  Base
//
//  Created by admin on 17/1/16.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, TabbarItemIndex) {
    TabbarItemIndexForhome = 0,
    TabbarItemIndexForCategory,
    TabbarItemIndexForCart,
    TabbarItemIndexForMine
};

@interface UITabBar (Badge)

// 显示 和 关闭红点
- (void)showBadgeValue:(NSString *) value OnItemIndex:(NSInteger ) index;
- (void)hideBadgeOnItemIndex:(NSInteger ) index;

@end
