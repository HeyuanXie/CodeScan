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
#import "UIImage+HYImages.h"
#import <IQKeyboardManager.h>
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

//微信SDK头文件
#import "WXApi.h"

//新浪微博SDK头文件
#import "WeiboSDK.h"

NS_ENUM(NSUInteger, TabType) {
    TabTypeHome = 0,
    TabTypeSecond,
    TabTypeThird,
    TabTypeForth,
};

@implementation AppDelegate (Extension)

-(void)verifyLogin {

    if ([Global userAuth]) {
        [APIHELPER fetchUserInfo:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
            if (isSuccess) {
                APIHELPER.userInfo = [UserInfoModel yy_modelWithDictionary:responseObject[@"data"]];
            }
        }];
    }
    [APIHELPER fetchConfiguration:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
        if (isSuccess) {
            APIHELPER.config = responseObject[@"data"];
        }
    }];
    
    [self configTabbar];
    [self.window makeKeyAndVisible];
    
}

-(void)configTabbar {
    UIViewController* main = [[UIStoryboard mainStoryboard] instantiateViewControllerWithIdentifier:@"HomeViewController"];
    main.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"首页" image:[ImageNamed(@"tab_home02") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[ImageNamed(@"tab_home01") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    UIViewController* collect = [[UIStoryboard collectStoryboard] instantiateViewControllerWithIdentifier:@"CollectViewController"];
    collect.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"收藏" image:[ImageNamed(@"tab_collect02") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[ImageNamed(@"tab_collect01") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    UIViewController* order = [[UIStoryboard orderStoryboard] instantiateViewControllerWithIdentifier:@"OrderHomeController"];
    order.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"订单" image:[ImageNamed(@"tab_order02") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[ImageNamed(@"tab_order01") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    UIViewController* mine = [[UIStoryboard mineStoryboard] instantiateViewControllerWithIdentifier:@"MineHomeViewController"];
    mine.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我的" image:[ImageNamed(@"tab_my02") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[ImageNamed(@"tab_my01") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    UITabBarController* tabController = [[UITabBarController alloc] init];
    tabController.tabBar.backgroundColor = [UIColor clearColor];
    NSMutableArray* vcs = [NSMutableArray arrayWithCapacity:4];
    vcs[TabTypeHome] = [[BaseNavigationController alloc] initWithRootViewController:main];
    vcs[TabTypeSecond] = [[BaseNavigationController alloc] initWithRootViewController:collect];
    vcs[TabTypeThird] = [[BaseNavigationController alloc] initWithRootViewController:order];
    vcs[TabTypeForth] = [[BaseNavigationController alloc] initWithRootViewController:mine];
    tabController.viewControllers = vcs;
    
    for (BaseNavigationController* navC in vcs) {
        navC.delegate = self;
    }
    self.window.rootViewController = tabController;
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


- (void)configShareSDK{
    [ShareSDK registerApp:kShareSDK_APPID
          activePlatforms:@[
                            @(SSDKPlatformTypeSinaWeibo),
                            @(SSDKPlatformSubTypeWechatSession),
                            @(SSDKPlatformSubTypeWechatTimeline),
                            @(SSDKPlatformTypeQQ)]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
             case SSDKPlatformTypeSinaWeibo:
                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                 break;
             default:
                 break;
         }
     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
             case SSDKPlatformTypeSinaWeibo:
                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                 [appInfo SSDKSetupSinaWeiboByAppKey:kSINA_APPID
                                           appSecret:kSINA_KEY
                                         redirectUri:kSINA_REDIRECTURL
                                            authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:kWX_APPID
                                       appSecret:kWX_KEY];
                 break;
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:kQQ_APPID
                                      appKey:kQQ_KEY
                                    authType:SSDKAuthTypeBoth];
                 break;
             default:
                 break;
         }
     }];
}


-(void)configPaySDK {
    
    [WXApi registerApp:kWX_KEY withDescription:@"demo"];
}

@end
