//
//  UIScrollView+EffectHeaderView.m
//  StretchyHeaders
//
//  Created by gt on 15/9/14.
//  Copyright (c) 2015年 gt4. All rights reserved.
//

#import "UIScrollView+EffectHeaderView.h"
#import <objc/runtime.h>

static char UIScrollViewEffectHeaderView;

@implementation UIScrollView (EffectHeaderView)
- (void)setEffectHeaderView:(HTEffectHeaderView *)effectHeaderView
{
    [self willChangeValueForKey:@"effectHeaderView"];
    objc_setAssociatedObject(self,
                             &UIScrollViewEffectHeaderView,
                             effectHeaderView,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"effectHeaderView"];
}

- (HTEffectHeaderView *)effectHeaderView
{
    return objc_getAssociatedObject(self, &UIScrollViewEffectHeaderView);
}

- (HTEffectHeaderView *)addEffectHeaderView:(UIImage *)image frame:(CGRect)frame Action:(void(^)(void))block{
    if (!self.effectHeaderView) {
        HTEffectHeaderView *headerView = [[HTEffectHeaderView alloc] initWithFrame:frame];
        headerView.scrollView = self;
        headerView.headerImage = image;
        headerView.pullToRefreshActionBlock = block;
        [self addSubview:headerView];
        self.effectHeaderView = headerView;
    }
    return self.effectHeaderView;
}

- (void)removeEffectKVO{
    [self.effectHeaderView unregisterFromKVO];
}

- (void)didFinishEffectPullToRefresh{
    [self.effectHeaderView endLoading];
}
@end
