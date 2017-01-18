//
//  HTEffectHeaderView.m
//  StretchyHeaders
//
//  Created by gt4 on 15/8/18.
//  Copyright (c) 2015年 gt4. All rights reserved.
//


#import "HTEffectHeaderView.h"
#import <CoreGraphics/CoreGraphics.h>

CGFloat HTPullToRefreshViewHeight = 75.0f;


@interface HTEffectHeaderView ()

@property (nonatomic,strong) UIImageView * imageView;
@property (nonatomic, assign) CGFloat scrollViewInsetTop;

@end


@implementation HTEffectHeaderView
- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self creatUI];
    }
    return self;
}
-(void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    
    self.scrollViewInsetTop = self.scrollView.contentInset.top;
    UIEdgeInsets insets = self.scrollView.contentInset;
    insets.top = self.scrollViewInsetTop + self.bounds.size.height;
    self.scrollView.contentInset = insets;
    self.scrollViewInsetTop = insets.top;
}

#pragma mark - setupUI

- (void)creatUI{
    self.clipsToBounds = YES;
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.backgroundColor = [UIColor blackColor];
    self.imageView = imageView;
    [self addSubview:self.imageView];
}

#pragma mark - private method

- (void)setHeaderImage:(UIImage *)headerImage{
    _headerImage = headerImage;
    self.imageView.image = headerImage;
}

- (void)setScrollView:(UIScrollView *)scrollView
{
    [self unregisterFromKVO];
    _scrollView = scrollView;
    [self registerForKVO];
}

#pragma mark - KVO

- (void)registerForKVO
{
    for (NSString *keyPath in [self observableKeyPaths]) {
        [self.scrollView addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    }
}

- (void)unregisterFromKVO
{
    for (NSString *keyPath in [self observableKeyPaths]) {
        [self.scrollView removeObserver:self forKeyPath:keyPath];
    }
    _scrollView = nil;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([NSThread isMainThread]) {
        [self updateUIForKeyPath:keyPath];
    } else {
        [self performSelectorOnMainThread:@selector(updateUIForKeyPath:) withObject:keyPath waitUntilDone:NO];
    }
}

- (void)updateUIForKeyPath:(NSString *)keyPath
{
    //    NSLog(@"contentoffSet = %f ,originalContentInsetY = %f",self.scrollView.contentOffset.y,self.originalContentInsetY);
    if (self.scrollView.contentOffset.y + self.scrollViewInsetTop <= 0) {
        if ([keyPath isEqualToString:@"pan.state"]) {
            [self handleScrollViewPanGesture];
        } else if ([keyPath isEqualToString:@"contentOffset"]) {
            [self scrollViewContentOffsetDidChange];
        }
    }
}

#pragma mark - Utilities
- (NSArray *)observableKeyPaths
{
    return @[@"contentOffset", @"pan.state"];
}

- (void)endLoading{
    if (self.state == GTEffectPullToRefreshStateLoading) {
        self.triggered = NO;
        self.state = GTEffectPullToRefreshStateCompleted;
        self.state = GTEffectPullToRefreshStatePulling;
    }
}

- (void)handleScrollViewPanGesture
{
    if (self.scrollView.panGestureRecognizer.state == UIGestureRecognizerStateEnded
        && self.triggered) {
        [self triggerRefresh];
    }
}

- (void)triggerRefresh {
    self.state = GTEffectPullToRefreshStateLoading;
    if (self.pullToRefreshActionBlock) {
        self.pullToRefreshActionBlock();
    }
}

- (void)scrollViewContentOffsetDidChange
{
    CGFloat offsetY = self.scrollView.contentOffset.y - (-self.scrollView.contentInset.top);
//    NSLog(@"offsetY---------------%@", @(offsetY));
    if (offsetY < 0) {//从顶部向下
        //图片放大 view容器也要跟着放大
        CGFloat y = self.scrollView.contentOffset.y;
        CGFloat height = fabs(self.scrollView.contentOffset.y);
        self.frame = CGRectMake(0, y, CGRectGetWidth(self.bounds), height);
    }

    if (self.state != GTEffectPullToRefreshStateLoading && self.state != GTEffectPullToRefreshStateCompleted) {
        if (self.scrollView.isDragging
            && self.scrollView.contentOffset.y + self.scrollViewInsetTop < -HTPullToRefreshViewHeight
            && !self.triggered) {
            self.triggered = YES;
        } else {
            if (self.scrollView.isDragging
                && self.scrollView.contentOffset.y + self.scrollViewInsetTop > -HTPullToRefreshViewHeight) {
                
                self.triggered = NO;
            }
            self.state = GTEffectPullToRefreshStatePulling;
        }
    }
}

@end
