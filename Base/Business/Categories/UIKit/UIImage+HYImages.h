//
//  UIImage+HYImages.h
//  Base
//
//  Created by admin on 17/1/16.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (HYImages)

+ (UIImage *)hyRoundRectImageWithFillColor:(UIColor *)fillColor
                               borderColor:(UIColor *)borderColor
                               borderWidth:(CGFloat)borderWidth
                              cornerRadius:(CGFloat)cornerRadius;

+ (UIImage *)hyRoundRectImageWithFillColor:(UIColor *)fillColor
                              cornerRadius:(CGFloat)cornerRadius;

// Page Indicator

+ (UIImage *)hyIndicatorImage;

+ (UIImage *)hySelectedIndicatorImage;

// Button Backgrounds

+ (UIImage *)hyLightImageWithCornerRadius:(CGFloat)cornerRadius;

@end
