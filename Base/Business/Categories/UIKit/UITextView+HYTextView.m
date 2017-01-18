//
//  UITextView+HYTextView.m
//  Base
//
//  Created by admin on 17/1/16.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "UITextView+HYTextView.h"

@implementation UITextView (HYTextView)
- (void)setBorderedStyle {
    self.layer.borderColor = [UIColor hySeparatorColor].CGColor;
    self.layer.borderWidth = 1.f/[UIScreen mainScreen].scale;
}
@end
