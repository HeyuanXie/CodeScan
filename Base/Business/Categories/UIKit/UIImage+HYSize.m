//
//  UIImage+HYSize.m
//  Base
//
//  Created by admin on 17/1/16.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "UIImage+HYSize.h"

@implementation UIImage (HYSize)

- (CGFloat)returnWidthWithScreenHeight{
    
    if (!self) return 0;
    
    return [self returnWidthWithNeedHeight:kScreen_Height];
}

- (CGFloat)returnHeightWithScreenWidth{
    if (!self) return 0;
    return [self returnHeightWithNeedWidth:kScreen_Width];
}

- (CGFloat)returnWidthWithNeedHeight:(CGFloat) needHeight{
    if (!self) return 0;
    
    return floorf([self returnImageSizeForWidth_Height_Proportion] * needHeight);
}

- (CGFloat)returnHeightWithNeedWidth:(CGFloat) needWidth{
    if (!self) return 0;
    
    return floorf([self returnImageSizeForHeight_Width_Proportion] * needWidth);
}

/// 图片压缩
- (UIImage*)compressImageWithScaledSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - private method

/**
 *  width / height
 *
 *  @return 宽高比例
 */
- (CGFloat)returnImageSizeForWidth_Height_Proportion{
    return self.size.width / self.size.height;
}

/**
 *  height / width
 *
 *  @return 高宽比例
 */
- (CGFloat)returnImageSizeForHeight_Width_Proportion{
    return self.size.height /  self.size.width;
}


@end
