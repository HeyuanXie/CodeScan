//
//  HTImageBrowserItemView.h
//  haitao-ios
//
//  Created by Cure on 14/12/9.
//  Copyright (c) 2014年 haitao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTImageBrowserZoomableView.h"

@class HTImageBrowserItemView;

@protocol HTImageBrowserItemViewDelegate <NSObject>

- (void)didDoubleTapZoomableViewForItem:(HTImageBrowserItemView *)itemView;
- (void)didSingleTapZoomableViewForItem:(HTImageBrowserItemView *)itemView;

@end

@interface HTImageBrowserItemView : UIView

@property (nonatomic, weak) id<HTImageBrowserItemViewDelegate> delegate;
@property (nonatomic, strong) HTImageBrowserZoomableView *zoomableView;

- (void)setItemImageURL:(NSURL *)imageURL placeholderImage:(UIImage *)placeholderImage;
- (void)setItemImage:(UIImage *)image;
- (void)prepareForReuse;

@end
