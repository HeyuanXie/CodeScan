//
//  UIImage+HYImages.m
//  Base
//
//  Created by admin on 17/1/16.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "UIImage+HYImages.h"

@implementation UIImage (HYImages)

+ (UIImage *)hyRoundRectImageWithFillColor:(UIColor *)fillColor
                               borderColor:(UIColor *)borderColor
                               borderWidth:(CGFloat)borderWidth
                              cornerRadius:(CGFloat)cornerRadius
{
    CGFloat halfBorderWidth = borderWidth * 0.5f;
    CGFloat w = cornerRadius + halfBorderWidth;
    
    CGFloat dw = w * 2 +2;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(dw, dw), NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(halfBorderWidth, halfBorderWidth, dw - borderWidth, dw - borderWidth) cornerRadius:cornerRadius];
    [fillColor setFill];
    [path fill];
    
    if (borderWidth > 0.0f && borderColor) {
        [borderColor setStroke];
        path.lineWidth = borderWidth;
        [path stroke];
    }
    
    CGContextAddPath(context, path.CGPath);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return [image resizableImageWithCapInsets:UIEdgeInsetsMake(w+1, w+1, w+1, w+1)];
}

+ (UIImage *)hyRoundRectImageWithFillColor:(UIColor *)fillColor
                              cornerRadius:(CGFloat)cornerRadius
{
    
    return [self hyRoundRectImageWithFillColor:fillColor borderColor:nil borderWidth:0.0f cornerRadius:cornerRadius];
}

// Page Indicator

+ (UIImage *)hyIndicatorImage
{
    UIImage *image = [self hyRoundRectImageWithFillColor:[UIColor clearColor] borderColor:[UIColor hyRedColor] borderWidth:1.f/[UIScreen mainScreen].scale cornerRadius:4.f];
    return image;
}

+ (UIImage *)hySelectedIndicatorImage
{
    UIImage *image = [self hyRoundRectImageWithFillColor:[UIColor hyRedColor] borderColor:[UIColor hyRedColor] borderWidth:1.f/[UIScreen mainScreen].scale  cornerRadius:4.f];
    return image;
}

// Button Backgrounds

+ (UIImage *)hyLightImageWithCornerRadius:(CGFloat)cornerRadius {
    return [self hyRoundRectImageWithFillColor:[UIColor clearColor]
                                   borderColor:[UIColor hyRedColor]
                                   borderWidth:1.f/[UIScreen mainScreen].scale
                                  cornerRadius:cornerRadius];
}


+(UIImage*)hyColorImage:(UIColor*)color {
    return [self hyColorImage:color size:CGSizeMake(2, 2)];
}

+(UIImage*)hyColorImage:(UIColor*)color size:(CGSize)size {
    
    UIGraphicsBeginImageContextWithOptions(size, false, 1);
    [color setFill];
    UIRectFillUsingBlendMode(CGRectMake(0, 0, size.width, size.height), kCGBlendModeXOR);
    CGImageRef cgImage = CGBitmapContextCreateImage(UIGraphicsGetCurrentContext());
    UIGraphicsEndImageContext();
    return [[UIImage imageWithCGImage:cgImage] stretchableImageWithLeftCapWidth:1 topCapHeight:1];
}

+(UIImage*)hyImageWithColor:(UIColor*)color size:(CGSize)size {
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


/**
 获取指定view范围内图像，返回PNG格式

 @param view 指定的view
 @return PNG格式的UIImage
 */
+(UIImage*)screenShotOnView:(UIView*)view {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size,NO,0);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData* imgData = UIImagePNGRepresentation(image);
    UIImage* pngImg = [UIImage imageWithData:imgData];
    return pngImg;
}


/**
 全屏截屏

 @return PNG格式的UIImage
 */
+(UIImage*)screenShot {
    UIWindow* keyWindow = [[UIApplication sharedApplication] keyWindow];
    return [self screenShotOnView:keyWindow];
}

@end
