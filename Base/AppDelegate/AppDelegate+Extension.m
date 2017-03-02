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
#import "APIHelper+User.h"
#import "UIImage+HYImages.h"

NS_ENUM(NSUInteger, TabType) {
    TabTypeHome = 0,
    TabTypeSecond,
    TabTypeThird,
    TabTypeForth,
};

@implementation AppDelegate (Extension)

-(void)verifyLogin {
    //...
    if (kAccount != nil && kPassword != nil) {
        [APIHELPER loginAccount:kAccount password:kPassword complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
            if (isSuccess) {
                NSLog(@"autoLoginSuccess");
            }
        }];
    }
    [self configTabbar];
    
    [self.window makeKeyAndVisible];
    
}

-(void)configTabbar {
    UIViewController* main = [[UIStoryboard mainStoryboard] instantiateViewControllerWithIdentifier:@"HomeViewController"];
    main.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"首页" image:[ImageNamed(@"home") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[ImageNamed(@"home01") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    UIViewController* sort = [[UIStoryboard sortStoryboard] instantiateViewControllerWithIdentifier:@"SortViewController"];
    sort.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"分类" image:[ImageNamed(@"sort") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[ImageNamed(@"sort01") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    UIViewController* cart = [[UIStoryboard cartStoryboard] instantiateViewControllerWithIdentifier:@"ShoppingCartViewController"];
    cart.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"购物车" image:[ImageNamed(@"cart") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[ImageNamed(@"cart01") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    UIViewController* mine = [[UIStoryboard mineStoryboard] instantiateViewControllerWithIdentifier:@"MineHomeViewController"];
    mine.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我的" image:[ImageNamed(@"mine") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[ImageNamed(@"mine01") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    UITabBarController* tabController = [[UITabBarController alloc] init];
    tabController.tabBar.backgroundColor = [UIColor clearColor];
    NSMutableArray* vcs = [NSMutableArray arrayWithCapacity:4];
    vcs[TabTypeHome] = [[BaseNavigationController alloc] initWithRootViewController:main];
    vcs[TabTypeSecond] = [[BaseNavigationController alloc] initWithRootViewController:sort];
    vcs[TabTypeThird] = [[BaseNavigationController alloc] initWithRootViewController:cart];
    vcs[TabTypeForth] = [[BaseNavigationController alloc] initWithRootViewController:mine];
    tabController.viewControllers = vcs;
    
    for (BaseNavigationController* navC in vcs) {
        navC.delegate = self;
    }
    self.window.rootViewController = tabController;
}

-(void)configUIAppearance {
    [[UINavigationBar appearance] setTranslucent:NO];
    [[UINavigationBar appearance] setTintColor:[UIColor clearColor]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor clearColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],
                                                           NSFontAttributeName: [UIFont systemFontOfSize:17.0f]}];
    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    
    // 字体颜色 选中
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:10.0F], NSForegroundColorAttributeName : [UIColor hyBarTintColor]} forState:UIControlStateSelected];
    
    // 字体颜色 未选中
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:10.0F],  NSForegroundColorAttributeName:[UIColor hyBlackTextColor]} forState:UIControlStateNormal];
    
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
    
// 设置蓝色渐变navigationBar
    if ([(BaseViewController *)viewController respondsToSelector:@selector(navigationBarBlue)]) {
        [navigationController.navigationBar setBackgroundImage:ImageNamed(@"gradualBackground") forBarMetrics:UIBarMetricsDefault];
    }else{
        [navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    }
}


@end
