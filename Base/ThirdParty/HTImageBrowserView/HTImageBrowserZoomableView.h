//
//  HTImageBrowserZoomableView.h
//  haitao-ios
//
//  Created by Cure on 14/12/9.
//  Copyright (c) 2014年 haitao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HTImageBrowserZoomableView;

@protocol HTImageBrowserZoomableViewDelegate <NSObject>

- (void)didDoubleTapZoomableView:(HTImageBrowserZoomableView *)zoomableView;
- (void)didSingleTapZoomableView:(HTImageBrowserZoomableView *)zoomableView;

@end

@interface HTImageBrowserZoomableView : UIScrollView

@property (nonatomic, weak) id<HTImageBrowserZoomableViewDelegate> zoomableDelegate;
@property (nonatomic, strong, readonly) UIImageView *imageView;

- (void)setImageURL:(NSURL *)imageURL placeholderImage:(UIImage *)placeholderImage;
- (void)setImage:(UIImage *)image;

@end
