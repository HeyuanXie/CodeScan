//
//  HTImageBrowserView.m
//  haitao-ios
//
//  Created by Cure on 14/12/9.
//  Copyright (c) 2014年 haitao. All rights reserved.
//

#import "HTImageBrowserView.h"
#import "HTImageBrowserItemView.h"
#import <PureLayout/PureLayout.h>
#import <SMPageControl/SMPageControl.h>

@interface HTImageBrowserView () <HTImageBrowserItemViewDelegate>

@property (nonatomic, strong) UIWindow *previousWindow;
@property (nonatomic, strong) UIWindow *currentWindow;

@property (nonatomic, strong) SMPageControl *pageControl;
@property (nonatomic, strong) NSLayoutConstraint *pageControlWidthConstaint;

@property (nonatomic, assign) BOOL didSetupConstraints;

@end

@implementation HTImageBrowserView

- (instancetype)initWithFrame:(CGRect)frame
{
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    self = [super initWithFrame:screenBounds]; // 全屏
    if (self) {
        self.userInteractionEnabled = NO;
        self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.0f];
        
        _imageCarousel = [[iCarousel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(screenBounds), CGRectGetHeight(screenBounds))];
        _imageCarousel.dataSource = self;
        _imageCarousel.delegate = self;
        _imageCarousel.type = iCarouselTypeLinear;
        _imageCarousel.pagingEnabled = YES;
        _imageCarousel.backgroundColor = [UIColor clearColor];
        _imageCarousel.alpha = 0.0f;
        _imageCarousel.vertical = NO;
        [self addSubview:_imageCarousel];
        
        _pageControl = [[SMPageControl alloc] initWithFrame:CGRectZero];
        _pageControl.hidesForSinglePage = YES;
        _pageControl.currentPageIndicatorImage = [UIImage imageNamed:@"Gallery_PageCurrent"];
        _pageControl.pageIndicatorImage = [UIImage imageNamed:@"Gallery_Page"];
        [_pageControl addTarget:self action:@selector(pageControlValueChanged:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:_pageControl];
        
        UIPanGestureRecognizer *gestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPanGesture:)];
        [self addGestureRecognizer:gestureRecognizer];
    }
    return self;
}

- (void)dealloc
{
    _imageCarousel.dataSource = nil;
    _imageCarousel.delegate = nil;
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        [_pageControl autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [_pageControl autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:30.0f];
        [_pageControl autoSetDimension:ALDimensionHeight toSize:30.0f];
        _pageControlWidthConstaint = [_pageControl autoSetDimension:ALDimensionWidth toSize:[_pageControl sizeForNumberOfPages:_pageControl.numberOfPages + 1].width];
        
        self.didSetupConstraints = YES;
    }
    
    _pageControlWidthConstaint.constant = [_pageControl sizeForNumberOfPages:_pageControl.numberOfPages + 1].width;
    
    [super updateConstraints];
}

#pragma mark - Action

- (void)pageControlValueChanged:(UIPageControl *)pageControl
{
    NSUInteger toIndex = pageControl.currentPage;
    if (toIndex != _imageCarousel.currentItemIndex) {
        [_imageCarousel scrollToItemAtIndex:toIndex animated:YES];
    }
}

#pragma mark - Gesture Recognizer

- (void)singleTapped:(UIGestureRecognizer *)recognizer
{
    if ([self.delegate respondsToSelector:@selector(didSingleTapImageBrowser:)]) {
        [self.delegate didSingleTapImageBrowser:self];
    }
}

#pragma mark - iCarouselDataSource Methods

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    _pageControl.numberOfPages = [self.dataSource numberOfImagesForImageBrowser:self];
    return [self.dataSource numberOfImagesForImageBrowser:self];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    HTImageBrowserItemView *itemView = (HTImageBrowserItemView *)view;
    if (!itemView) {
        itemView = [[HTImageBrowserItemView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        itemView.delegate = self;
        [carousel.contentView.gestureRecognizers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if (![obj isKindOfClass:[UIPanGestureRecognizer class]]) return;
            [itemView.zoomableView.panGestureRecognizer requireGestureRecognizerToFail:obj];
        }];
    }
    
    [itemView prepareForReuse];
    
    UIImage *placeholderImage = nil;
    if ([_dataSource respondsToSelector:@selector(imageBrowser:placeholderImageAtIndex:)]) {
        placeholderImage = [_dataSource imageBrowser:self placeholderImageAtIndex:index];
    }
    
    if ([_dataSource respondsToSelector:@selector(imageBrowser:URLForImageAtIndex:)]) {
        [itemView setItemImageURL:[_dataSource imageBrowser:self URLForImageAtIndex:index] placeholderImage:placeholderImage];
    } else if ([_dataSource respondsToSelector:@selector(imageBrowser:URLStringForImageAtIndex:)]) {
        [itemView setItemImageURL:[NSURL URLWithString:[_dataSource imageBrowser:self URLStringForImageAtIndex:index]] placeholderImage:placeholderImage];
    }
    if ([_dataSource respondsToSelector:@selector(imageBrowser:imageAtIndex:)]) {
        UIImage *img = [_dataSource imageBrowser:self imageAtIndex:index];
        if (img) {
            [itemView setItemImage:img];
        }
    }
    
    return itemView;
}

#pragma mark - iCarouselDelegate Methods

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    switch (option) {
        case iCarouselOptionWrap:
            return NO;
            break;
        default:
            return value;
            break;
    }
}

- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel
{
    _pageControl.currentPage = carousel.currentItemIndex;
}

- (void)carouselDidScroll:(iCarousel *)carousel
{
    CGFloat overOffset = carousel.scrollOffset - (carousel.numberOfItems - 1.0f);
    if (carousel.scrollOffset > 0.0f
        && overOffset > 0.0f
        && [self.delegate respondsToSelector:@selector(imageBrowser:didScrollOverRightBoundary:)]) {
        [self.delegate imageBrowser:self didScrollOverRightBoundary:overOffset];
    }
}

#pragma mark - HTImageBrowserItemViewDelegate Methods

- (void)didDoubleTapZoomableViewForItem:(HTImageBrowserItemView *)itemView
{
    
}

- (void)didSingleTapZoomableViewForItem:(HTImageBrowserItemView *)itemView
{
    if ([self.delegate respondsToSelector:@selector(didSingleTapImageBrowser:)]) {
        [self.delegate didSingleTapImageBrowser:self];
    }
}

#pragma mark - Utilities

- (void)showWithCompletion:(void (^)(void))completion
{
    _previousWindow = [[UIApplication sharedApplication] keyWindow];
    
    _currentWindow = [[UIWindow alloc] initWithFrame:_previousWindow.bounds];
    _currentWindow.windowLevel = UIWindowLevelStatusBar;
    _currentWindow.hidden = NO;
    _currentWindow.backgroundColor = [UIColor clearColor];
    [_currentWindow makeKeyAndVisible];
    [_currentWindow addSubview:self];
    
    [self.imageCarousel reloadData]; // 从动画completion里挪到这里，防止第一次加载的时候，跳不到相应index
    
    [UIView animateWithDuration:0.35f animations:^{
        self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:1.0f];
    } completion:^(BOOL finished) {
        if (finished) {
            self.userInteractionEnabled = YES;
            self.imageCarousel.alpha = 1.0f;
            self.pageControl.alpha = 1.0f;
            if (completion) {
                completion();
            }
        }
    }];
}

- (void)showFromIndex:(NSInteger)index
{
    [self showWithCompletion:nil];
    if (index < [self.dataSource numberOfImagesForImageBrowser:self]) {
        [self.imageCarousel scrollToItemAtIndex:index animated:NO];
    }
}

- (void)hideWithAnimation:(void (^)(void))animation completion:(void (^)(BOOL))completion
{
    [UIView animateWithDuration:0.35f animations:^{
        self.imageCarousel.alpha = 0.0f;
        self.pageControl.alpha = 0.0f;
        self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.0f];
        if (animation) {
            animation();
        }
    } completion:^(BOOL finished) {
        self.userInteractionEnabled = NO;
        [self removeFromSuperview];
        [self.previousWindow makeKeyAndVisible];
        self.currentWindow.hidden = YES;
        self.currentWindow = nil;
        if (completion) {
            completion(finished);
        }
    }];
}

- (void)hideWithCompletion:(void (^)(BOOL))completion
{
    [self hideWithAnimation:nil completion:completion];
}


-(void)onPanGesture:(UIPanGestureRecognizer*)gestureRecognizer{
    //设置移动
    CGPoint point = [gestureRecognizer translationInView:self.imageCarousel];
    self.imageCarousel.center = CGPointMake(self.imageCarousel.center.x, self.imageCarousel.center.y + point.y);
    [gestureRecognizer setTranslation:CGPointMake(0, 0) inView:self.imageCarousel];
    
    //计算alpha
    CGFloat alpha = 1.0 - fabs(self.imageCarousel.center.y - CGRectGetMidY(self.imageCarousel.bounds))/CGRectGetMidY(self.imageCarousel.bounds);
    self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:alpha];
    
    //开启上下滑时隐藏pageControl
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan){
        self.pageControl.alpha = 0.0f;
    }
    
    //结束touch
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded ||
        gestureRecognizer.state ==  UIGestureRecognizerStateCancelled ||
        gestureRecognizer.state ==  UIGestureRecognizerStateFailed){
        
        //如果用户放回原处
        CGFloat offsetY = fabs(CGRectGetMidY(self.imageCarousel.bounds)-self.imageCarousel.center.y);
        if (offsetY < 5.0 && offsetY > -5.0){
            self.imageCarousel.center = CGPointMake(self.imageCarousel.center.x, CGRectGetMidY(self.imageCarousel.bounds));
            self.pageControl.alpha = 1.0;
            return;
        }
        
        //计算目标位置值
        CGFloat dirCenterY = - CGRectGetMidY(self.imageCarousel.bounds);
        if (self.imageCarousel.center.y > CGRectGetMidY(self.imageCarousel.bounds)) {
            dirCenterY = CGRectGetMidY(self.imageCarousel.bounds) * 3;
        }
        [UIView animateWithDuration:0.3 animations:^{
            self.imageCarousel.center = CGPointMake(self.imageCarousel.center.x, dirCenterY);
        }completion:^(BOOL finished) {
            //恢复状态
            self.userInteractionEnabled = NO;
            [self removeFromSuperview];
            [self.previousWindow makeKeyAndVisible];
            self.currentWindow.hidden = YES;
            self.currentWindow = nil;
            self.imageCarousel.center = CGPointMake(self.imageCarousel.center.x, CGRectGetMidY(self.imageCarousel.bounds));
        }];
    }
}
@end
