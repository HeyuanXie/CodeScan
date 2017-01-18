//
//  UIView+Layout.h
//  Base
//
//  Created by admin on 17/1/16.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Layout)

// 相对于父视图
@property (nonatomic) CGFloat top;
@property (nonatomic, readonly) CGFloat bottom;
@property (nonatomic) CGFloat left;
@property (nonatomic, readonly) CGFloat right;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;
@property (nonatomic) CGFloat centerX;
@property (nonatomic) CGFloat centerY;
@property (nonatomic) CGSize size;
@property (nonatomic) CGPoint origin;

// 相对于 window
@property (nonatomic, readonly) CGFloat topInWindow;
@property (nonatomic, readonly) CGFloat bottomInWindow;
@property (nonatomic, readonly) CGFloat leftInWindow;
@property (nonatomic, readonly) CGFloat rightInWindow;
@property (nonatomic, readonly) CGFloat centerXInWindow;
@property (nonatomic, readonly) CGFloat centerYInWindow;
@property (nonatomic, readonly) CGPoint originInWindow;

@end
