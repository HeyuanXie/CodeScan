//
//  UIViewController+Extension.m
//  Base
//
//  Created by admin on 2017/3/2.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "UIViewController+Extension.h"

@implementation UIViewController (Extension)

- (void)addBackgroundImage:(NSString *)imageName frame:(CGRect)frame {
    UIImageView* imageView = [[UIImageView alloc] initWithImage:ImageNamed(imageName)];
    imageView.frame = frame;
    [self.view addSubview:imageView];
    [self.view sendSubviewToBack:imageView];
}

- (void)addBackgroundImageWithFrame:(CGRect)frame {
    [self addBackgroundImage:@"gradualBackground" frame:frame];
}

@end
