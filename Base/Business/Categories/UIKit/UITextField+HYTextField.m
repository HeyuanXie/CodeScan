//
//  UITextField+HYTextField.m
//  Base
//
//  Created by admin on 17/1/16.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "UITextField+HYTextField.h"

@implementation UITextField (HYTextField)
- (void)leftSpaceStyle{
    [self leftSpace:5.f];
}

- (void)leftSpace:(CGFloat) leftSpace{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, leftSpace, 10.f)];
    self.leftView = view;
    self.leftViewMode = UITextFieldViewModeAlways;
}
@end
