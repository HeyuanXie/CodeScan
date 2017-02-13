//
//  HYScrollView.h
//  Base
//
//  Created by admin on 2017/2/8.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <iCarousel.h>

@interface HYScrollView : NSObject


- (instancetype)initWithFrame:(CGRect )frame;

/** 视图  */
@property (nonatomic, strong) UIView *rollView;

/** 数据数组
 可存放本地图片名称
 网络图片地址
 */
@property (nonatomic, strong) NSArray *dataArray;

@property (strong, nonatomic) UIPageControl *pageControl;

/** 类型设置  默认类型：iCarouselTypeLiner */
@property (nonatomic, assign) iCarouselType type;
/** 滚动到最后一张时是否可以继续滚动到第一张*/
@property (nonatomic, assign) BOOL canWrap;
/** item上图片ContentType*/
@property (nonatomic, assign) UIViewContentMode imageViewType;
/** item上图片的Size*/
@property (nonatomic, assign) CGSize imageViewSize;


/** 点击事件 会返回点击的index  和 数据数组 */
@property (nonatomic, copy) void (^clickAction)(NSInteger index, NSArray *dataArray);

@end
