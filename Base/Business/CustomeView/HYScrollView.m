//
//  HYScrollView.m
//  Base
//
//  Created by admin on 2017/2/8.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "HYScrollView.h"

@interface HYScrollView ()<iCarouselDelegate,iCarouselDataSource>

@property(strong, nonatomic) iCarousel * carousel;
@property(strong, nonatomic) NSTimer * timer;

@end

@implementation HYScrollView

- (instancetype)initWithFrame:(CGRect )frame{
    if (self = [super init]) {
        
        _rollView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,kScreen_Width, 200)];
        self.rollView.frame = frame;
        self.carousel.frame = self.rollView.bounds;
        
        self.carousel = [[iCarousel alloc] initWithFrame:_rollView.bounds];
        
        self.carousel.delegate = self;
        self.carousel.dataSource = self;
        
        //属性默认值设置
        self.type = iCarouselTypeLinear;
        self.canWrap = YES;
        self.carousel.scrollSpeed = 6;
        self.carousel.pagingEnabled = YES;
        
        self.imageViewSize = CGSizeMake(kScreen_Width, 200);
        
        [_rollView addSubview:self.carousel];
        
        self.pageControl = [[UIPageControl alloc] init];
        self.pageControl.numberOfPages = _dataArray.count;
        self.pageControl.center = CGPointMake(_rollView.center.x, _rollView.frame.size.height - 10);
        
        [_rollView addSubview:self.pageControl];
        
        [self addTimer];
        
    }
    return self;
}

- (void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    
    self.pageControl.numberOfPages = dataArray.count;
    
    //如果是网络的地址 就缓存
    //    if([dataArray.firstObject hasPrefix:@"htttp"]){
    //        [dataArray writeToFile:nil atomically:YES];
    //
    //    }
    
    [self.carousel reloadData];
}

- (void)setType:(iCarouselType)type{
    _type = type;
    
    self.carousel.type = type;
    
}

#pragma mark -- 私有
- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    
    return _dataArray.count;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    //create new view if no view is available for recycling
    if (view == nil)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.imageViewSize.width, self.imageViewSize.height)];
        imageView.contentMode = self.imageViewType;
        
        NSString *str = _dataArray[index];
        
        if ([str hasPrefix:@"http"]) {
            
            [imageView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:nil];
            
        }else{
            
            imageView.image = [UIImage imageNamed:str];
        }
        
        view = imageView;
    }
    
    
    return view;
}

-(CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value {
    switch (option) {
        case iCarouselOptionWrap:
            return self.canWrap;
            break;
        default:
            return value;
            break;
    }
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index{
    
    if (self.clickAction) {
        self.clickAction(index,self.dataArray);
    }
}

-(void)addTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0
                                                  target:self
                                                selector:@selector(nextImage)
                                                userInfo:nil
                                                 repeats:YES];
    //添加到runloop中
    [[NSRunLoop mainRunLoop]addTimer:self.timer
                             forMode:NSRunLoopCommonModes];
}

- (void)removeTimer
{
    [self.timer invalidate];
}


- (void)nextImage
{
    
    NSInteger index = self.carousel.currentItemIndex + 1;
    if (index == _dataArray.count ) {
        index = 0;
    }
    
    [self.carousel scrollToItemAtIndex:index
                              animated:YES];
    
    
}

- (void)carouselDidScroll:(iCarousel *)carousel;
{
    self.pageControl.currentPage = carousel.currentItemIndex;
}
- (void)carouselWillBeginDragging:(iCarousel *)carousel{
    [self removeTimer];
}

- (void)carouselDidEndDragging:(iCarousel *)carousel
                willDecelerate:(BOOL)decelerate{
    //    开启定时器
    [self addTimer];
}


@end
