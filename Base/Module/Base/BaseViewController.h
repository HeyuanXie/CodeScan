//
//  BaseViewController.h
//  Base
//
//  Created by admin on 17/1/16.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController
@property(nonatomic, assign) BOOL needLogEvent;
@property (nonatomic, assign) BOOL backItemHidden;
@property (nonatomic, assign) BOOL navigationBarHidden;
//返回方法
- (void)backAction;
- (void)showLoadingAnimation;
- (void)hideLoadingAnimation;
- (void)showMessage:(NSString *)message;
- (void)showMessage:(NSString *)message complete:(void(^)())complate;
@end
