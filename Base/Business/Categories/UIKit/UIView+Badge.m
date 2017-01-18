//
//  UIView+Badge.m
//  Base
//
//  Created by admin on 17/1/16.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "UIView+Badge.h"
#import <objc/runtime.h>
#import <PureLayout.h>

@interface UIView()

@property(nonatomic,strong) UILabel* badge;

@end

static char UIViewBadge;    //badge的值

@implementation UIView (Badge)
-(void)setBadge:(UILabel *)badge{
    [self willChangeValueForKey:@"badge"];
    objc_setAssociatedObject(self, &UIViewBadge, badge, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"badge"];
}

-(UILabel *)badge{
    return objc_getAssociatedObject(self, &UIViewBadge);
}

-(void)showBadge:(NSString *)value {
    if (!self.badge) {
        self.badge = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
        [self addSubview:self.badge];
        [self.badge autoSetDimensionsToSize:CGSizeMake(16, 16)];
        [self.badge autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:-4.0];
        [self.badge autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:-4.0];
        self.badge.backgroundColor = [UIColor redColor];
        self.badge.textColor = [UIColor whiteColor];
        self.badge.textAlignment = NSTextAlignmentCenter;
        self.badge.font = [UIFont systemFontOfSize:8];
        self.badge.layer.cornerRadius = 8.0;
        self.badge.clipsToBounds = YES;
    }
    self.badge.text = value;
}

-(void)hiddenBadge {
    if (self.badge) {
        [self.badge removeFromSuperview];
        self.badge = nil;
    }
}
@end
