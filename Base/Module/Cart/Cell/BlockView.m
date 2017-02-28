//
//  BlockView.m
//  Base
//
//  Created by admin on 2017/2/24.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "BlockView.h"

@interface BlockView ()

@property(nonatomic,strong)CADisplayLink* displayLink;


@end

@implementation BlockView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.from = 10;
        self.to = kScreen_Height-self.frame.size.height/2;
    }
    return self;
}

- (void)startAnimation {
    if (!_displayLink) {
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(tick:)];
        [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        _displayLink.paused = YES;
    }
}

- (void)completeAnimation {
    [_displayLink invalidate];
    _displayLink = nil;
}

- (void)tick:(CADisplayLink*)displayLink {
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    self.from = kScreen_Height-self.frame.size.height/2;
    self.to = 64;
    CALayer *layer = self.layer.presentationLayer;
    CGFloat progress = 1 - (layer.position.y - self.to) / (self.from - self.to);
    CGFloat height = CGRectGetHeight(rect);
    CGFloat deltaHeight = height / 2 * (0.5 - fabs(progress - 0.5));
    CGPoint topLeft = CGPointMake(0, deltaHeight);
    CGPoint topRight = CGPointMake(CGRectGetWidth(rect), deltaHeight);
    CGPoint bottomLeft = CGPointMake(0, height);
    CGPoint bottomRight = CGPointMake(CGRectGetWidth(rect), height);
    UIBezierPath* path = [UIBezierPath bezierPath];
    [[UIColor blueColor] setFill];
    [path moveToPoint:topLeft];
    [path addQuadCurveToPoint:topRight controlPoint:CGPointMake(CGRectGetMidX(rect), 0)];
    [path addLineToPoint:bottomRight];
    [path addQuadCurveToPoint:bottomLeft controlPoint:CGPointMake(CGRectGetMidX(rect), height - deltaHeight)];
    [path closePath];
    [path fill];
}

@end
