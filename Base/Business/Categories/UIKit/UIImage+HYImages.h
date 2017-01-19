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


/**
 创建一个颜色图片
 
 :param: color 颜色
 :param: size  如果不设置，则为  ｛2， 2｝
 :returns: 返回图片，图片的scale为当前屏幕的scale
 */
+(UIImage*)hyColorImage:(UIColor*)color;

+(UIImage*)hyColorImage:(UIColor*)color size:(CGSize)size;

+(UIImage*)hyImageWithColor:(UIColor*)color size:(CGSize)size;

+(UIImage*)screenShotOnView:(UIView*)view;

+(UIImage*)screenShot;
@end
