//
//  AppDelegate+Extension.m
//  Base
//
//  Created by admin on 17/1/16.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "AppDelegate+Extension.h"
#import "UIStoryboard+HYStoryboard.h"
#import "BaseNavigationController.h"
#import "BaseViewController.h"
#import "CodeScanController.h"
#import "UIImage+HYImages.h"
#import <IQKeyboardManager.h>

#import "LoginViewController.h"


NS_ENUM(NSUInteger, TabType) {
    TabTypeHome = 0,
    TabTypeSecond,
    TabTypeThird,
    TabTypeForth,
};


@implementation AppDelegate (Extension)

-(void)verifyLogin {

    if (kPassword && kAccount) {
        [APIHELPER login:kAccount password:kPassword complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
            if (isSuccess) {
                [Global setUserAuth:responseObject[@"data"][@"auth"]];
                CodeScanController* vc = (CodeScanController*)VIEWCONTROLLER(kCodeScanController);
                UINavigationController* nvc = (UINavigationController*)kApplication.keyWindow.rootViewController;
                [nvc pushViewController:vc animated:YES];
            }
        }];
    }
    
    [self configTabbar];
    [self.window makeKeyAndVisible];
    
}

-(void)configTabbar {
    
    LoginViewController* loginVC = (LoginViewController*)VIEWCONTROLLER(kLoginViewController);
    loginVC.navigationLineHidden = YES;
    BaseNavigationController* root = [[BaseNavigationController alloc] initWithRootViewController:loginVC];
    self.window.rootViewController = root;
}

-(void)configUIAppearance {
    [[UINavigationBar appearance] setTranslucent:NO];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],
                                                           NSFontAttributeName: [UIFont systemFontOfSize:17.0f]}];
    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    
    // 字体颜色 选中
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:11.0F], NSForegroundColorAttributeName : [UIColor hyBarSelectedColor]} forState:UIControlStateSelected];
    
    // 字体颜色 未选中
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:11.0F],  NSForegroundColorAttributeName:[UIColor hyBarUnselectedColor]} forState:UIControlStateNormal];
    
    [[UITabBar appearance] setTranslucent:NO];
    [[UITabBar appearance] setBackgroundColor:[UIColor whiteColor]];
    
    [UITableView appearance].separatorColor = [UIColor hySeparatorColor];
    [UITableView appearance].separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
}


// 如果vc.navigationBarHidden=YES,则会隐藏导航栏
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if ([(BaseViewController *)viewController respondsToSelector:@selector(navigationBarHidden)]) {
        [navigationController setNavigationBarHidden:[(BaseViewController *)viewController navigationBarHidden] animated:YES];
    }
    
// 设置蓝色背景navigationBar
    if ([(BaseViewController *)viewController respondsToSelector:@selector(navigationBarBlue)]) {
        [navigationController.navigationBar setBackgroundImage:ImageNamed(@"gradualBackground") forBarMetrics:UIBarMetricsDefault];
    }else{
        [navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    }
}


-(void)configIQKeyBoardManager  {
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
}


@end
