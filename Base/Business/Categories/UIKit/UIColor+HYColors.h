//
//  UIColor+HYColors.h
//  Base
//
//  Created by admin on 17/1/16.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (HYColors)

/**
 导航栏颜色

 @return color
 */
+(UIColor*)hyBarTintColor;

/**
 TabBar选中颜色

 @return color
 */
+(UIColor*)hyBarSelectedColor;

+(UIColor*)hyBarUnselectedColor;

+(UIColor*)hyRedColor;

+(UIColor*)hyBlackTextColor;

+(UIColor*)hyHighlightedGrayColor;

+(UIColor*)hyGrayTextColor;

+(UIColor*)hyLightGrayColor;

+ (UIColor*)hyBlueTextColor;

+ (UIColor*)hyLightBlueTextColor;

+(UIColor*)hySeparatorColor;

+(UIColor*)hyViewBackgroundColor;

+(UIColor*)hyCellBackgroundColor;

+(UIColor*)hyColorWithString:(NSString*)stirng;

@end
