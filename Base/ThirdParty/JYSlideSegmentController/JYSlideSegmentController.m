//
//  JYSlideSegmentController.m
//  JYSlideSegmentController
//
//  Created by Alvin on 14-3-16.
//  Copyright (c) 2014年 Alvin. All rights reserved.
//

#import "JYSlideSegmentController.h"
#import <ColorUtils.h>
#import "BaseViewController.h"

#define SEGMENT_BAR_HEIGHT (44)
#define INDICATOR_HEIGHT (2)

double lerp(double a, double b, double t)
{
    return a + (b - a) * t;
}

float lerpf(float a, float b, float t)
{
    return a + (b - a) * t;
}

NSString * const segmentBarItemID = @"JYSegmentBarItem";

@interface JYSegmentBarItem : UICollectionViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *badgeLabel;

@end


@implementation JYSegmentBarItem

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        [self.contentView setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.badgeLabel];
    }
    return self;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:self.contentView.bounds];
        _titleLabel.font = [UIFont systemFontOfSize:14.f];
        _titleLabel.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UILabel *)badgeLabel
{
    if (!_badgeLabel) {
        _badgeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.bounds)-28, 8, 16, 16)];
        _badgeLabel.font = [UIFont systemFontOfSize:8.f];
        _badgeLabel.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin);
        _badgeLabel.textAlignment = NSTextAlignmentCenter;
        _badgeLabel.textColor = [UIColor whiteColor];
        _badgeLabel.clipsToBounds = YES;
        _badgeLabel.layer.cornerRadius = 8;
        _badgeLabel.backgroundColor = [UIColor redColor];
    }
    return _badgeLabel;
}

- (void)setbadge:(NSInteger)number{
    if (number <= 0) {
        self.badgeLabel.hidden = YES;
        return;
    }
    self.badgeLabel.hidden = NO;
    if (number > 99) {
        self.badgeLabel.text = @"99+";
    }else{
        self.badgeLabel.text = [NSString stringWithFormat:@"%@", @(number)];
    }
}

@end

@interface JYSlideSegmentController ()
<UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong, readwrite) UIToolbar *toolBar;
@property (nonatomic, strong, readwrite) UICollectionView *segmentBar;
@property (nonatomic, strong, readwrite) UIScrollView *slideView;
@property (nonatomic, assign, readwrite) NSInteger selectedIndex;
@property (nonatomic, strong) UIView *indicator;
@property (nonatomic, strong) UIView *indicatorBgView;
@property (nonatomic, strong) UIView *separator;

@property (nonatomic, strong) UICollectionViewFlowLayout *segmentBarLayout;
@property (nonatomic, strong) NSMutableArray *titleSizes;
@property (nonatomic, assign) CGFloat itemsViewWidth;

@property (nonatomic, strong) NSArray *badges;
- (void)reset;

@end

@implementation JYSlideSegmentController
@synthesize viewControllers = _viewControllers;
@synthesize itemWidth = _itemWidth;
@synthesize separatorColor = _separatorColor;

- (instancetype)initWithViewControllers:(NSArray *)viewControllers
{
    self = [super init];
    if (self) {
        _topBarHidden = NO;
        _topInset = 0.f;
        _viewControllers = [viewControllers copy];
        
        _selectedIndex = NSNotFound;
        _titleSizes = [NSMutableArray array];
        _segmentBarColor = [UIColor clearColor];

        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupSubviews];
    [self reset];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

//- (void)viewWillAppear:(BOOL)animated
//{
//    if (!CGRectEqualToRect(self.fixedFrame, CGRectZero)) {
//        self.view.frame = self.fixedFrame;
//    }
//}

//- (void)setFixedFrame:(CGRect)fixedFrame
//{
//    _fixedFrame = fixedFrame;
//    [self calculteFrame];
//}




- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [_titleSizes removeAllObjects];
    
    for (int i = 0; i < [_segmentBar numberOfItemsInSection:0]; i++) {
        UIViewController *vc = self.viewControllers[i];
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:14.f];
        [label setText:vc.title];
        [label sizeToFit];
        [_titleSizes addObject:@(label.bounds.size.width)];
    }
    
    CGRect frame = CGRectMake(_itemWidth * self.selectedIndex,
                              self.segmentBar.frame.size.height - self.indicatorHeight - 10.f,
                              self.itemWidth,
                              self.indicatorHeight);
    self.indicatorBgView.frame = frame;
    
    CGFloat scrollOffset = _slideView.contentOffset.x / _slideView.frame.size.width;
    CGRect indicatorFrame = [self getIndicatorFrameWithScrollPercent:scrollOffset];
    self.indicator.frame = indicatorFrame;
    
    CGRect separatorFrame = CGRectMake(0,
                                       CGRectGetMaxY(self.segmentBar.frame),
                                       [UIScreen mainScreen].bounds.size.width,
                                       1/[UIScreen mainScreen].scale);
    self.separator.frame = separatorFrame;
    
    if (self.defaultSelectedIndex) {
        [self scrollToViewWithIndex:self.defaultSelectedIndex animated:NO];
        [self segmentBarScrollToIndex:self.defaultSelectedIndex animated:NO];
    }
}

#pragma mark - Setup
- (void)setupSubviews
{
    // iOS7 set layout
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [self.view addSubview:self.slideView];
    [self.view addSubview:self.toolBar];
    [self.view addSubview:self.segmentBar];
    [self.segmentBar registerClass:[JYSegmentBarItem class] forCellWithReuseIdentifier:segmentBarItemID];
    [self.segmentBar addSubview:self.indicatorBgView];
    
    CGRect separatorFrame = CGRectMake(0,
                                       CGRectGetMaxY(self.segmentBar.frame),
                                       CGRectGetWidth(self.segmentBar.frame),
                                       1/[UIScreen mainScreen].scale);
    _separator = [[UIView alloc] initWithFrame:separatorFrame];
    [_separator setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin];
    [_separator setBackgroundColor:self.separatorColor];
    [self.view addSubview:_separator];
    
    if (_topBarHidden) {
        _toolBar.hidden = YES;
        _segmentBar.hidden = YES;
        _indicator.hidden = YES;
        _indicatorBgView.hidden = YES;
        _separator.hidden = YES;
    }
}

#pragma mark - Property
- (UIScrollView *)slideView
{
    if (!_slideView) {
        CGRect frame = self.view.bounds;
        frame.origin.y = self.topInset;
        frame.size.height -= self.topInset;
        //frame.size.height -= _segmentBar.frame.size.height;
        //frame.origin.y = CGRectGetMaxY(_segmentBar.frame);
        _slideView = [[UIScrollView alloc] initWithFrame:frame];
        [_slideView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth
                                         | UIViewAutoresizingFlexibleHeight)];
        [_slideView setShowsHorizontalScrollIndicator:NO];
        [_slideView setShowsVerticalScrollIndicator:NO];
        [_slideView setPagingEnabled:YES];
        [_slideView setBounces:NO];
        [_slideView setDelegate:self];
        [_slideView setScrollsToTop:NO];
        _slideView.backgroundColor = [UIColor whiteColor];
        CGSize conentSize = CGSizeMake(self.view.frame.size.width * self.viewControllers.count, 0);
        [_slideView setContentSize:conentSize];
    }
    return _slideView;
}

- (UIToolbar *)toolBar {
    if (!_toolBar) {
        CGRect frame = self.view.bounds;
        frame.origin.y = self.topInset;
        frame.size.height = SEGMENT_BAR_HEIGHT;
        
        _toolBar = [[UIToolbar alloc] initWithFrame:frame];
        _toolBar.backgroundColor = [UIColor whiteColor];
    }
    
    return _toolBar;
}

- (UICollectionView *)segmentBar
{
    if (!_segmentBar) {
        CGRect frame = self.view.bounds;
        frame.origin.y = self.topInset;
        frame.size.height = SEGMENT_BAR_HEIGHT;
        
        if (self.itemsViewWidth) {
            frame.size.width = self.itemsViewWidth;
            frame.origin.x = CGRectGetWidth(self.view.bounds) / 2 - self.itemsViewWidth/2;
        }
        
        
        _segmentBar = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:self.segmentBarLayout];
        //    _segmentBar.backgroundColor = (_segmentBarColor != nil ? _segmentBarColor : [UIColor clearColor]);
        _segmentBar.backgroundColor = (self.itemsViewWidth ? [UIColor clearColor] : [UIColor whiteColor]);
        _segmentBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _segmentBar.delegate = self;
        _segmentBar.dataSource = self;
        _segmentBar.showsHorizontalScrollIndicator = NO;
        _segmentBar.showsVerticalScrollIndicator = NO;
        _segmentBar.scrollsToTop = NO;
    }
    return _segmentBar;
}

- (UIView *)indicatorBgView
{
    if (!_indicatorBgView) {
        CGRect frame = CGRectMake(0,
                                  self.segmentBar.frame.size.height - self.indicatorHeight - 10.f,
                                  self.itemWidth,
                                  self.indicatorHeight);
        _indicatorBgView = [[UIView alloc] initWithFrame:frame];
        _indicatorBgView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        _indicatorBgView.backgroundColor = [UIColor clearColor];
        [_indicatorBgView addSubview:self.indicator];
    }
    return _indicatorBgView;
}

- (UIView *)indicator
{
    if (!_indicator) {
        CGFloat width = self.itemWidth - self.indicatorInsets.left - self.indicatorInsets.right;
        CGRect frame = CGRectMake(self.indicatorInsets.left, 0, width, self.indicatorHeight);
        _indicator = [[UIView alloc] initWithFrame:frame];
        _indicator.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        _indicator.backgroundColor = self.indicatorColor ? : [UIColor yellowColor];
    }
    return _indicator;
}

- (CGFloat)indicatorHeight
{
    if (!_indicatorHeight) {
        _indicatorHeight = INDICATOR_HEIGHT;
    }
    return _indicatorHeight;
}

- (CGFloat)itemWidth
{
    if (!_itemWidth) {
        _itemWidth = CGRectGetWidth(self.segmentBar.frame) / self.viewControllers.count;
    }
    return _itemWidth;
}

- (void)setItemWidth:(CGFloat)itemWidth
{
    _itemWidth = itemWidth;
    if (_segmentBarLayout && _segmentBar) {
        _segmentBarLayout.itemSize = CGSizeMake(_itemWidth, SEGMENT_BAR_HEIGHT);
        [_segmentBar setCollectionViewLayout:_segmentBarLayout animated:NO];
        [self.view setNeedsLayout];
    }
}

- (void)setIndicatorColor:(UIColor *)indicatorColor
{
    _indicatorColor = indicatorColor;
    _indicator.backgroundColor = _indicatorColor;
}

- (UIColor *)separatorColor
{
    if (!_separatorColor) {
        _separatorColor = [UIColor colorWithString:@"#DDDDDD"];
    }
    return _separatorColor;
}

- (void)setSeparatorColor:(UIColor *)separatorColor
{
    _separatorColor = separatorColor;
    self.separator.backgroundColor = _separatorColor;
}

- (UICollectionViewFlowLayout *)segmentBarLayout
{
    if (!_segmentBarLayout) {
        _segmentBarLayout = [[UICollectionViewFlowLayout alloc] init];
        _segmentBarLayout.itemSize = CGSizeMake(self.itemWidth, SEGMENT_BAR_HEIGHT);
        _segmentBarLayout.sectionInset = UIEdgeInsetsZero;
        _segmentBarLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _segmentBarLayout.minimumLineSpacing = 0;
        _segmentBarLayout.minimumInteritemSpacing = 0;
    }
    return _segmentBarLayout;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    if (_selectedIndex == selectedIndex) {
        return;
    }
    
    NSParameterAssert(selectedIndex >= 0 && selectedIndex < self.viewControllers.count);
    
    UIViewController *toSelectController = [self.viewControllers objectAtIndex:selectedIndex];
    
    // Add selected view controller as child view controller
    if (!toSelectController.parentViewController) {
        
        if (self.selectedIndex >= 0 && self.selectedIndex < self.viewControllers.count && self.selectedViewController.parentViewController) {
            [self.selectedViewController removeFromParentViewController];
        }
        
        [self addChildViewController:toSelectController];
        CGRect rect = self.slideView.bounds;
        rect.origin.x = rect.size.width * selectedIndex;
        rect.origin.y = CGRectGetMaxY(self.segmentBar.frame);
        rect.size.height -= rect.origin.y;
        toSelectController.view.frame = rect;
        [self.slideView addSubview:toSelectController.view];
        [toSelectController didMoveToParentViewController:self];
    }
    
    
    _selectedIndex = selectedIndex;
    if ([_delegate respondsToSelector:@selector(didSelectViewController:)]) {
        [_delegate didSelectViewController:self.selectedViewController];
    }
}

- (void)setViewControllers:(NSArray *)viewControllers
{
    // Need remove previous viewControllers
    for (UIViewController *vc in _viewControllers) {
        [vc removeFromParentViewController];
    }
    _viewControllers = [viewControllers copy];
    [self reset];
}

- (NSArray *)viewControllers
{
    return [_viewControllers copy];
}

- (UIViewController *)selectedViewController
{
    return self.viewControllers[self.selectedIndex];
}

- (void) setBadges:(NSArray *)numbers{
    if (_badges != numbers) {
        _badges = numbers;
        [self.segmentBar reloadData];
    }
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if ([_dataSource respondsToSelector:@selector(numberOfSectionsInslideSegment:)]) {
        return [_dataSource numberOfSectionsInslideSegment:collectionView];
    }
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if ([_dataSource respondsToSelector:@selector(slideSegment:numberOfItemsInSection:)]) {
        return [_dataSource slideSegment:collectionView numberOfItemsInSection:section];
    }
    return self.viewControllers.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_dataSource respondsToSelector:@selector(slideSegment:cellForItemAtIndexPath:)]) {
        return [_dataSource slideSegment:collectionView cellForItemAtIndexPath:indexPath];
    }
    
    JYSegmentBarItem *segmentBarItem = [collectionView dequeueReusableCellWithReuseIdentifier:segmentBarItemID
                                                                                 forIndexPath:indexPath];
    if (indexPath.row == _selectedIndex) {
        [segmentBarItem.titleLabel setTextColor:self.indicatorColor];
    } else {
        [segmentBarItem.titleLabel setTextColor:[UIColor darkGrayColor]];
    }
    UIViewController *vc = self.viewControllers[indexPath.row];
    segmentBarItem.titleLabel.text = vc.title;
    segmentBarItem.badgeLabel.hidden = YES;
    if (self.badges && indexPath.row < self.badges.count) {
        [segmentBarItem setbadge:[self.badges[indexPath.row] integerValue]];
    }
    return segmentBarItem;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < 0 || indexPath.row >= self.viewControllers.count) {
        return;
    }
    
    [self setSelectedIndex:indexPath.row];
    [self scrollToViewWithIndex:self.selectedIndex animated:NO];
    [self segmentBarScrollToIndex:_selectedIndex animated:YES];
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < 0 || indexPath.row >= self.viewControllers.count) {
        return NO;
    }
    
    BOOL flag = YES;
    UIViewController *vc = self.viewControllers[indexPath.row];
    if ([_delegate respondsToSelector:@selector(shouldSelectViewController:)]) {
        flag = [_delegate shouldSelectViewController:vc];
    }
    return flag;
}

#pragma mark - Helper
- (void)changeTitleColorWithScrollPercent:(CGFloat)scrollOffset {
    NSInteger floorIndex = floor(scrollOffset);
    NSInteger ceilIndex = ceil(scrollOffset);
    if (floorIndex == ceilIndex) {
        return;
    }
    CGFloat delta = scrollOffset - floorIndex;
    
    CGFloat r,g,b,a;
    UIColor *ceilColor = self.indicatorColor;
    [ceilColor getRed:&r green:&g blue:&b alpha:&a];
    ceilColor = [UIColor colorWithRed:r*delta green:g*delta blue:b*delta alpha:1.0];
    if (ceilIndex >= 0 && ceilIndex < self.viewControllers.count) {
        JYSegmentBarItem *segmentBarItem = (JYSegmentBarItem *)[self.segmentBar cellForItemAtIndexPath:[NSIndexPath indexPathForRow:ceilIndex inSection:0]];
        segmentBarItem.titleLabel.textColor = ceilColor;
    }
    
    UIColor *floorColor = [UIColor colorWithRed:r*(1.0-delta) green:g*(1.0-delta) blue:b*(1.0-delta) alpha:1.0];
    if (floorIndex >= 0 && floorIndex < self.viewControllers.count) {
        JYSegmentBarItem *segmentBarItem = (JYSegmentBarItem *)[self.segmentBar cellForItemAtIndexPath:[NSIndexPath indexPathForRow:floorIndex inSection:0]];
        segmentBarItem.titleLabel.textColor = floorColor;
    }
    
    //    _indicator.backgroundColor = delta<0.5?floorColor:ceilColor;
    
}
- (CGRect)getIndicatorFrameWithScrollPercent:(CGFloat)scrollOffset {
    NSInteger floorIndex = floor(scrollOffset);
    NSInteger ceilIndex = ceil(scrollOffset);
    
    CGFloat floorWidth = [(NSNumber *)[_titleSizes objectAtIndex:floorIndex] floatValue];
    CGFloat ceilWidth = [(NSNumber *)[_titleSizes objectAtIndex:ceilIndex] floatValue];
    
    CGFloat delta = scrollOffset - floorIndex;
    
    CGFloat x = lerpf((_itemWidth - floorWidth)/2,
                      (_itemWidth - ceilWidth)/2,
                      delta);
    
    CGFloat width = lerpf(floorWidth, ceilWidth, delta);
    
    return  CGRectMake(x,
                       0,
                       width,
                       self.indicatorHeight);
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.slideView) {
        // set indicator frame
        CGRect frame = self.indicatorBgView.frame;
        CGFloat percent = scrollView.contentOffset.x / scrollView.contentSize.width;
        
        CGFloat scrollOffset = scrollView.contentOffset.x / scrollView.frame.size.width;
        
        frame.origin.x = self.segmentBar.contentSize.width * percent;
        self.indicatorBgView.frame = frame;
        
        CGRect indicatorFrame = [self getIndicatorFrameWithScrollPercent:scrollOffset];
        self.indicator.frame = indicatorFrame;
        
        [self changeTitleColorWithScrollPercent:scrollOffset];
        
        NSInteger index = ceilf(percent * self.viewControllers.count);
        if (index >= 0 && index < self.viewControllers.count) {
            [self setSelectedIndex:index];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.slideView) {
        [self segmentBarScrollToIndex:_selectedIndex animated:YES];
        if ([_delegate respondsToSelector:@selector(didFullyShowViewController:)]) {
            [_delegate didFullyShowViewController:self.selectedViewController];
        }
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (scrollView == self.slideView) {
        [self segmentBarScrollToIndex:_selectedIndex animated:YES];
        if ([_delegate respondsToSelector:@selector(didFullyShowViewController:)]) {
            [_delegate didFullyShowViewController:self.selectedViewController];
        }
    }
}

#pragma mark - Action
- (void)scrollToViewWithIndex:(NSInteger)index animated:(BOOL)animated
{
    CGRect rect = self.slideView.bounds;
    rect.origin.x = rect.size.width * index;
    [self.slideView setContentOffset:CGPointMake(rect.origin.x, rect.origin.y) animated:animated];
    if (!animated && [_delegate respondsToSelector:@selector(didFullyShowViewController:)]) {
        [_delegate didFullyShowViewController:self.selectedViewController];
    }
}

- (void)reset
{
    _selectedIndex = NSNotFound;
    [self setSelectedIndex:0];
    [self scrollToViewWithIndex:0 animated:NO];
    [self segmentBarScrollToIndex:0 animated:NO];
    [self.segmentBar reloadData];
}

- (void)segmentBarScrollToIndex:(NSInteger)index animated:(BOOL)animated
{
    [_segmentBar reloadData];
    [self.segmentBar scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]
                            atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:animated];
}

- (void) setCompressWithItemsViewWidth:(CGFloat ) itemsViewWidth{
    self.itemsViewWidth = itemsViewWidth;
}

@end

