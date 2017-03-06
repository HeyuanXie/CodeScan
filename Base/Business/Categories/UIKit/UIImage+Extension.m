//
//  UIImage+Extension.m
//  test
//
//  Created by admin on 16/9/30.
//  Copyright © 2016年 admin. All rights reserved.
//

#import "UIImage+Extension.h"

@implementation UIImage (Extension)

//创建颜色图片,不设置size时默认赋值(2,2)
-(UIImage*)colorImageWithColor:(UIColor*)color{

    return [self colorImageWithColor:color andSize:CGSizeMake(2, 2)];
}

-(UIImage*)colorImageWithColor:(UIColor*)color andSize:(CGSize)size{
    
    UIGraphicsBeginImageContextWithOptions(size, 0, 1);
    [color setFill];
    UIRectFillUsingBlendMode(CGRectMake(0, 0, size.width, size.height), kCGBlendModeXOR);
    CGImageRef cgImage = CGBitmapContextCreateImage(UIGraphicsGetCurrentContext());
    UIGraphicsEndImageContext();
    UIImage* image = [[UIImage imageWithCGImage:cgImage] stretchableImageWithLeftCapWidth:1 topCapHeight:1];
    return image;
}

-(UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size{
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

//压缩图片
-(UIImage *)imageWithSimpleImage:(CGSize)size{

    UIGraphicsBeginImageContext(size);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
