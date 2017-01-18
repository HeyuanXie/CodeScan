//
//  UIView+Layout.m
//  Base
//
//  Created by admin on 17/1/16.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "UIView+Layout.h"

@implementation UIView (Layout)

- (CGFloat)top{
    return CGRectGetMinY(self.frame);
}
- (void)setTop:(CGFloat)top{
    CGRect frame = self.frame;
    frame.origin.y = top;
    self.frame = frame;
}

- (CGFloat)bottom{
    return CGRectGetMaxY(self.frame);
}


- (CGFloat)left{
    return CGRectGetMinX(self.frame);
}

- (void)setLeft:(CGFloat)left{
    CGRect frame = self.frame;
    frame.origin.x = left;
    self.frame = frame;
}

- (CGFloat)right{
    return CGRectGetMaxX(self.frame);
}

- (CGFloat)width{
    return CGRectGetWidth(self.frame);
}

- (void)setWidth:(CGFloat)width{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height{
    return CGRectGetHeight(self.frame);
}

- (void)setHeight:(CGFloat)height{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)centerX{
    return CGRectGetMidX(self.frame);
}

- (void)setCenterX:(CGFloat)centerX{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerY{
    return CGRectGetMidY(self.frame);
}

- (void)setCenterY:(CGFloat)centerY{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGPoint)origin{
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)size{
    return self.frame.size;
}

- (void)setSize:(CGSize)size{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

#pragma mark - 相对于window

static inline CGRect GetFrameInWindow(UIView *tempSelf){
    return [tempSelf.superview convertRect:tempSelf.frame toView:nil];
}

- (CGFloat)topInWindow{
    return CGRectGetMinY(GetFrameInWindow(self));
}

- (CGFloat)bottomInWindow{
    return CGRectGetMaxY(GetFrameInWindow(self));
}

- (CGFloat)leftInWindow{
    return CGRectGetMinX(GetFrameInWindow(self));
}

- (CGFloat)rightInWindow{
    return CGRectGetMaxX(GetFrameInWindow(self));
}

- (CGFloat)centerXInWindow{
    return CGRectGetMidX(GetFrameInWindow(self));
}

- (CGFloat)centerYInWindow{
    return CGRectGetMidY(GetFrameInWindow(self));
}

- (CGPoint)originInWindow{
    return GetFrameInWindow(self).origin;
}


@end
