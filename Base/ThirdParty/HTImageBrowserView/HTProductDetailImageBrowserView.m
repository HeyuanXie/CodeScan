//
//  HTProductDetailImageBrowserView.m
//  haitao-ios
//
//  Created by Cure on 15/1/16.
//  Copyright (c) 2015年 haitao. All rights reserved.
//

#import "HTProductDetailImageBrowserView.h"
#import <PureLayout/PureLayout.h>
#import "UIColor+HYColors.h"

@interface HTProductDetailImageBrowserView ()

@end

@implementation HTProductDetailImageBrowserView

- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel
{
    [super carouselCurrentItemIndexDidChange:carousel];
}

#pragma mark -

- (void)showFromIndex:(NSInteger)index
{
    [self showWithCompletion:^{
        //
    }];
    if (index < [self.dataSource numberOfImagesForImageBrowser:self]) {
        [self.imageCarousel scrollToItemAtIndex:index animated:NO];
    }
}

- (void)hideWithCompletion:(void (^)(BOOL))completion
{
    [self hideWithAnimation:^{
        //
    } completion:completion];
}

@end
