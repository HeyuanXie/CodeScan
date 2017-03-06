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
    return [UIColor colorWithString:@"#66aff6"];
}

+(UIColor *)hyBarUnselectedColor {
    return [UIColor colorWithString:@"d1e6fe"];
}

+ (UIColor *)hyRedColor {
    return [UIColor colorWithString:@"#F46582"];
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

+ (UIColor*)hyBlueTextColor {
    return [UIColor colorWithString:@"64ADF3"];
}

+ (UIColor*)hyLightBlueTextColor {
    return [UIColor colorWithString:@"7baffb"];
}

+ (UIColor *)hySeparatorColor {
    return [UIColor colorWithString:@"#ebebeb"];
}

+ (UIColor *)hyViewBackgroundColor {
    return [UIColor colorWithString:@"#E7F0FE"];
}

+ (UIColor *)hyCellBackgroundColor {
    return [UIColor colorWithString:@"#f1f1f1"];
}

+ (UIColor *)hyColorWithString:(NSString *) string{
    if (!string.length) return nil;
    return [UIColor colorWithString:string];
}

@end
