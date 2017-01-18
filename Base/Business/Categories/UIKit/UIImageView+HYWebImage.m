//
//  UIImageView+HYWebImage.m
//  Base
//
//  Created by admin on 17/1/16.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "UIImageView+HYWebImage.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation UIImageView (HYWebImage)

- (void)hy_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder {
    __block UIImageView *weakSelf = self;
    [self sd_setImageWithURL:url
            placeholderImage:placeholder
                     options:SDWebImageRetryFailed
                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                       weakSelf.alpha = 1.f;
                   }];
}

- (void)hy_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder animated:(BOOL)animated {
    __block UIImageView *weakSelf = self;
    [self sd_setImageWithURL:url
            placeholderImage:placeholder
                     options:SDWebImageRetryFailed
                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                       if (animated && cacheType == SDImageCacheTypeNone && image != nil) {
                           weakSelf.alpha = 0.0;
                           [UIView transitionWithView:weakSelf
                                             duration:0.5f
                                              options:UIViewAnimationOptionTransitionCrossDissolve
                                           animations:^{
                                               weakSelf.alpha = 1.f;
                                           } completion:NULL];
                       } else {
                           self.alpha = 1.f;
                       }
                   }];
}

@end
