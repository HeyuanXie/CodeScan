//
//  UIColor+HYColors.m
//  Base
//
//  Created by admin on 17/1/16.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "UIColor+HYColors.h"

@implementation UIColor (HYColors)

+ (UIColor *)hyBarTintColor {
    return [UIColor colorWithString:@"#ee3b3b"];
//    return RGB(230, 63, 66, 1.0);
}

+ (UIColor *)hyRedColor {
    return [UIColor colorWithString:@"#ef5341"];
}

+ (UIColor *)hyBlackTextColor {
    return [UIColor colorWithString:@"#414141"];
}

+ (UIColor *)hyHighlightedGrayColor {
    return [UIColor colorWithString:@"#8a8a8a"];
}

+ (UIColor *)hyGrayTextColor {
    return [UIColor colorWithString:@"#d1d1d1"];
}

+ (UIColor *)hySeparatorColor {
    return [UIColor colorWithString:@"#ebebeb"];
}

+ (UIColor *)hyViewBackgroundColor {
    return [UIColor colorWithString:@"#f1f1f1"];
}

+ (UIColor *)hyCellBackgroundColor {
    return [UIColor colorWithString:@"#f1f1f1"];
}

+ (UIColor *)hyColorWithString:(NSString *) string{
    if (!string.length) return nil;
    return [UIColor colorWithString:string];
}

@end
