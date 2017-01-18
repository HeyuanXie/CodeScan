//
//  HTImageBrowserZoomableView.m
//  haitao-ios
//
//  Created by Cure on 14/12/9.
//  Copyright (c) 2014年 haitao. All rights reserved.
//

#import "HTImageBrowserZoomableView.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface HTImageBrowserZoomableView () <UIScrollViewDelegate>

@property (nonatomic, strong, readwrite) UIImageView *imageView;

@end

@implementation HTImageBrowserZoomableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.delegate = self;
        
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:_imageView];
        
        self.minimumZoomScale = 1.0f;
        self.maximumZoomScale = 2.0f;
        
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapped:)];
        doubleTap.numberOfTapsRequired = 2;
        [self addGestureRecognizer:doubleTap];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapped:)];
        singleTap.numberOfTapsRequired = 1;
        [self addGestureRecognizer:singleTap];
        
        [singleTap requireGestureRecognizerToFail:doubleTap]; // 防止两个手势冲突
    }
    return self;
}

#pragma mark - Property

- (void)setImageURL:(NSURL *)imageURL placeholderImage:(UIImage *)placeholderImage
{
    [_imageView sd_setImageWithURL:imageURL placeholderImage:placeholderImage];
}

- (void)setImage:(UIImage *)image
{
    [_imageView setImage:image];
}

#pragma mark - Gesture Recognizer

- (void)doubleTapped:(UITapGestureRecognizer *)recognizer
{
    if (self.zoomScale > 1.0f) {
        [UIView animateWithDuration:0.35f animations:^{
            self.zoomScale = 1.0f;
        }];
    } else {
        [UIView animateWithDuration:0.35f animations:^{
//            CGPoint point = [recognizer locationInView:self];
//            [self zoomToRect:CGRectMake(point.x, point.y, 0, 0) animated:YES];
            [self zoomToRect:CGRectMake(CGRectGetMidX([UIScreen mainScreen].bounds), CGRectGetMidY([UIScreen mainScreen].bounds), 0, 0) animated:YES];
        }];
    }
    
    if ([self.zoomableDelegate respondsToSelector:@selector(didDoubleTapZoomableView:)]) {
        [self.zoomableDelegate didDoubleTapZoomableView:self];
    }
}

- (void)singleTapped:(UITapGestureRecognizer *)recognizer
{
    if ([self.zoomableDelegate respondsToSelector:@selector(didSingleTapZoomableView:)]) {
        [self.zoomableDelegate didSingleTapZoomableView:self];
    }
}

//#pragma mark - Touch
//
//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    if ([self.zoomableDelegate respondsToSelector:@selector(didDoubleTapZoomableView:)]) {
//        [self.zoomableDelegate didDoubleTapZoomableView:self];
//    }
//}

#pragma mark - UIScrollViewDelegate Methods

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

@end
