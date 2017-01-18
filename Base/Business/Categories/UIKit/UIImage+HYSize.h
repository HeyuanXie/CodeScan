//
//  UIImage+HYSize.h
//  Base
//
//  Created by admin on 17/1/16.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (HYSize)

- (CGFloat)returnWidthWithScreenHeight;

- (CGFloat)returnHeightWithScreenWidth;

- (CGFloat)returnWidthWithNeedHeight:(CGFloat) needHeight;

- (CGFloat)returnHeightWithNeedWidth:(CGFloat) needWidth;

@end
