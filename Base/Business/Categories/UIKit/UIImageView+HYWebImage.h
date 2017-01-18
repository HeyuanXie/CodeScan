//
//  UIImageView+HYWebImage.h
//  Base
//
//  Created by admin on 17/1/16.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (HYWebImage)

- (void)hy_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;

- (void)hy_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder animated:(BOOL)animated;

@end
