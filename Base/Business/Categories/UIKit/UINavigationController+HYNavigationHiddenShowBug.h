//
//  UINavigationController+HYNavigationHiddenShowBug.h
//  Base
//
//  Created by admin on 17/1/16.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (HYNavigationHiddenShowBug)
- (void)pushViewControllerWithNavigationControllerTransition:(UIViewController *)viewController;
- (void)popViewControllerWithNavigationControllerTransition;
@end
