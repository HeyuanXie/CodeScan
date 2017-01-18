//
//  UINavigationController+HYNavigationHiddenShowBug.m
//  Base
//
//  Created by admin on 17/1/16.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "UINavigationController+HYNavigationHiddenShowBug.h"

static CALayer *kHYCurrentLayer = nil;
static CALayer *kHYNextLayer = nil;
static NSTimeInterval const kTransitionDuration = .3f;

@interface HYNavigationControllerTransitionAnimiationDelegate : NSObject
- (void)animationDidStop:(CAAnimation *)animation finished:(BOOL)flag;
+ (HYNavigationControllerTransitionAnimiationDelegate *)sharedDelegate;
@end

@implementation HYNavigationControllerTransitionAnimiationDelegate

- (void)animationDidStop:(CAAnimation *)animation finished:(BOOL)flag
{
    [kHYCurrentLayer removeFromSuperlayer];
    [kHYNextLayer removeFromSuperlayer];
}

+ (HYNavigationControllerTransitionAnimiationDelegate *)sharedDelegate
{
    static dispatch_once_t onceToken;
    __strong static id _sharedDelegate = nil;
    dispatch_once(&onceToken, ^{
        _sharedDelegate = [[self alloc] init];
    });
    return _sharedDelegate;
}

@end

@implementation UINavigationController (HYNavigationHiddenShowBug)

- (void)pushViewControllerWithNavigationControllerTransition:(UIViewController *)viewController
{
    kHYCurrentLayer = [self _layerSnapshotWithTransform:CATransform3DIdentity];
    
    [self pushViewController:viewController animated:NO];
    
    kHYNextLayer = [self _layerSnapshotWithTransform:CATransform3DIdentity];
    kHYNextLayer.frame = (CGRect){{CGRectGetWidth(self.view.bounds), CGRectGetMinY(self.view.bounds)}, self.view.bounds.size};
    
    [self.view.layer addSublayer:kHYCurrentLayer];
    [self.view.layer addSublayer:kHYNextLayer];
    
    [CATransaction flush];
    
    [kHYCurrentLayer addAnimation:[self _animationWithTranslation:-CGRectGetWidth(self.view.bounds)] forKey:nil];
    [kHYNextLayer addAnimation:[self _animationWithTranslation:-CGRectGetWidth(self.view.bounds)] forKey:nil];
}

- (void)popViewControllerWithNavigationControllerTransition
{
    kHYCurrentLayer = [self _layerSnapshotWithTransform:CATransform3DIdentity];
    
    [self popViewControllerAnimated:NO];
    
    kHYNextLayer = [self _layerSnapshotWithTransform:CATransform3DIdentity];
    kHYNextLayer.frame = (CGRect){{-CGRectGetWidth(self.view.bounds), CGRectGetMinY(self.view.bounds)}, self.view.bounds.size};
    
    [self.view.layer addSublayer:kHYCurrentLayer];
    [self.view.layer addSublayer:kHYNextLayer];
    
    [CATransaction flush];
    
    [kHYCurrentLayer addAnimation:[self _animationWithTranslation:CGRectGetWidth(self.view.bounds)] forKey:nil];
    [kHYNextLayer addAnimation:[self _animationWithTranslation:CGRectGetWidth(self.view.bounds)] forKey:nil];
}

- (CABasicAnimation *)_animationWithTranslation:(CGFloat)translation
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.toValue = [NSValue valueWithCATransform3D:CATransform3DTranslate(CATransform3DIdentity, translation, 0.f, 0.f)];
    animation.duration = kTransitionDuration;
    animation.delegate = [HYNavigationControllerTransitionAnimiationDelegate sharedDelegate];
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    return animation;
}

- (CALayer *)_layerSnapshotWithTransform:(CATransform3D)transform
{
    if (UIGraphicsBeginImageContextWithOptions){
        UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, [UIScreen mainScreen].scale);
    }
    else {
        UIGraphicsBeginImageContext(self.view.bounds.size);
    }
    
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *snapshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CALayer *snapshotLayer = [CALayer layer];
    snapshotLayer.transform = transform;
    snapshotLayer.anchorPoint = CGPointMake(1.f, 1.f);
    snapshotLayer.frame = self.view.bounds;
    snapshotLayer.contents = (id)snapshot.CGImage;
    return snapshotLayer;
}

@end
