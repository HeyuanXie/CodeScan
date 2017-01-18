//
//  HTImageBrowserView.h
//  haitao-ios
//
//  Created by Cure on 14/12/9.
//  Copyright (c) 2014年 haitao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iCarousel/iCarousel.h>

@class HTImageBrowserView;

@protocol HTImageBrowserViewDataSource <NSObject>

- (NSInteger)numberOfImagesForImageBrowser:(HTImageBrowserView *)imageBrowser;

@optional
- (UIImage *)imageBrowser:(HTImageBrowserView *)imageBrowser placeholderImageAtIndex:(NSInteger)index;
- (UIImage *)imageBrowser:(HTImageBrowserView *)imageBrowser imageAtIndex:(NSInteger)index;
- (NSString *)imageBrowser:(HTImageBrowserView *)imageBrowser URLStringForImageAtIndex:(NSInteger)index;
- (NSURL *)imageBrowser:(HTImageBrowserView *)imageBrowser URLForImageAtIndex:(NSInteger)index;

@end

@protocol HTImageBrowserViewDelegate <NSObject>

- (void)didSingleTapImageBrowser:(HTImageBrowserView *)imageBrowser;

@optional
- (void)imageBrowser:(HTImageBrowserView *)imageBrowser didScrollOverRightBoundary:(CGFloat)overOffset;

@end

@interface HTImageBrowserView : UIView <iCarouselDataSource, iCarouselDelegate>

@property (nonatomic, strong) iCarousel *imageCarousel;
@property (nonatomic, weak) id<HTImageBrowserViewDataSource> dataSource;
@property (nonatomic, weak) id<HTImageBrowserViewDelegate> delegate;

- (void)showFromIndex:(NSInteger)index;
- (void)showWithCompletion:(void (^)(void))completion;
- (void)hideWithCompletion:(void (^)(BOOL finished))completion;
- (void)hideWithAnimation:(void (^)(void))animation completion:(void (^)(BOOL finished))completion;

@end
