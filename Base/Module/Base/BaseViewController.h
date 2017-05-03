//
//  BaseViewController.h
//  Base
//
//  Created by admin on 17/1/16.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController
@property (nonatomic, assign) BOOL needLogEvent;

/**
 是否隐藏返回按钮
 */
@property (nonatomic, assign) BOOL backItemHidden;

/**
 是否隐藏导航栏
 */
@property (nonatomic, assign) BOOL navigationBarHidden;

/**
 导航栏是否透明
 */
@property (nonatomic, assign) BOOL navigationBarTransparent;      

/**
 导航栏横线是否隐藏
 */
@property (nonatomic, assign) BOOL navigationLineHidden;

/**
 导航栏是否为蓝色
 */
@property (nonatomic, assign) BOOL navigationBarBlue;

//返回方法
- (void)backAction;
- (void)showLoadingAnimation;
- (void)hideLoadingAnimation;
- (void)showMessage:(NSString *)message;
- (void)showMessage:(NSString *)message complete:(void(^)())complate;

- (BOOL)checkUserLogined;

#pragma mark - 设置导航栏透明
- (void)hideBackView:(UIView *) superView;
- (void)showBackView:(UIView*)superView;

@end
