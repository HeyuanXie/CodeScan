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
@property (nonatomic, assign) BOOL backItemHidden;
@property (nonatomic, assign) BOOL navigationBarHidden;
@property (nonatomic, assign) BOOL navigationBarTransparent;      //导航栏是否透明
@property (nonatomic, assign) BOOL navigationLineHidden;    //是否隐藏导航栏线条
@property (nonatomic, assign) BOOL navigationBarBlue;     //导航栏是否为蓝色

//返回方法
- (void)backAction;
- (void)showLoadingAnimation;
- (void)hideLoadingAnimation;
- (void)showMessage:(NSString *)message;
- (void)showMessage:(NSString *)message complete:(void(^)())complate;

@end
