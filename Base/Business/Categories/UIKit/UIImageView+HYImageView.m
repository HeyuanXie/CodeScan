//
//  UIImageView+HYImageView.m
//  Base
//
//  Created by admin on 17/1/16.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "UIImageView+HYImageView.h"

@implementation UIImageView (HYImageView)

- (void)setBorderedStyle {
    self.layer.borderColor = [UIColor hySeparatorColor].CGColor;
    self.layer.borderWidth = 1.f/[UIScreen mainScreen].scale;
}


/**
 设置毛玻璃效果,调用前要设置self.bounds

 @param style <#style description#>
 */
-(void)setBlurEffectStyle:(UIBlurEffectStyle)style {
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:style];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = self.bounds;
    [self addSubview:effectView];
}
@end
