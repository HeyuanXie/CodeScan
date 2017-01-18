//
//  HTImageBrowserItemView.m
//  haitao-ios
//
//  Created by Cure on 14/12/9.
//  Copyright (c) 2014年 haitao. All rights reserved.
//

#import "HTImageBrowserItemView.h"
#import "HTImageBrowserZoomableView.h"
#import <PureLayout/PureLayout.h>

@interface HTImageBrowserItemView () <HTImageBrowserZoomableViewDelegate>

@property (nonatomic, assign) BOOL didSetupConstraints;

@end

@implementation HTImageBrowserItemView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _zoomableView = [[HTImageBrowserZoomableView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _zoomableView.userInteractionEnabled = YES;
        _zoomableView.zoomableDelegate = self;
        [self addSubview:_zoomableView];
    }
    return self;
}

- (void)dealloc
{
    _zoomableView.zoomableDelegate = nil;
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        [_zoomableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        self.didSetupConstraints = YES;
    }
    
    [super updateConstraints];
}

#pragma mark - HTImageBrowserZoomableViewDelegate Methods

- (void)didDoubleTapZoomableView:(HTImageBrowserZoomableView *)zoomableView
{
    if ([self.delegate respondsToSelector:@selector(didDoubleTapZoomableViewForItem:)]) {
        [self.delegate didDoubleTapZoomableViewForItem:self];
    }
}

- (void)didSingleTapZoomableView:(HTImageBrowserZoomableView *)zoomableView
{
    if ([self.delegate respondsToSelector:@selector(didSingleTapZoomableViewForItem:)]) {
        [self.delegate didSingleTapZoomableViewForItem:self];
    }
}

#pragma mark - Utilities

- (void)setItemImageURL:(NSURL *)imageURL placeholderImage:(UIImage *)placeholderImage
{
    [_zoomableView setImageURL:imageURL placeholderImage:placeholderImage];
    [self setNeedsUpdateConstraints];
}

- (void)setItemImage:(UIImage *)image
{
    [_zoomableView setImage:image];
    [self setNeedsUpdateConstraints];
}

- (void)prepareForReuse
{
    [_zoomableView setZoomScale:1.0f];
}

@end
