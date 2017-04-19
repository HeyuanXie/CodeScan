//
//  AppDelegate.m
//  Base
//
//  Created by admin on 17/1/13.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+Extension.h"
#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>
#import "HYPayEngine.h"
#import "HYAlertView.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor blackColor];
    
    //Moudules init
    [[OpenRoutesManager shareInstance] registSchema];
    
    //UI init
    [self verifyLogin];
    [self configUIAppearance];
    [self configIQKeyBoardManager];
    [self configPaySDK];
    
    return YES;
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {

}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    [WXApi handleOpenURL:url delegate:[HYPayEngine sharePayEngine]];
    
    if ([url.host isEqualToString:@"safepay"]) {
//         支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSString * strTitle = [NSString stringWithFormat:@"支付结果"];
            NSString *strMsg;
            if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]) {
                
                strMsg = @"恭喜您，支付成功!";
                
            }else if([resultDic[@"resultStatus"] isEqualToString:@"6001"])
            {
                strMsg = @"已取消支付!";
                
            }else{
                strMsg = @"支付失败!";
            }
            HYAlertView* alert = [HYAlertView sharedInstance];
            [alert showAlertView:strTitle message:strMsg subBottonTitle:@"确定" handler:^(AlertViewClickBottonType bottonType) {
                if ([strMsg isEqualToString:@"恭喜您，支付成功!"]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:kPaySuccessNotification object:nil];
                }
                if ([strMsg isEqualToString:@"已取消支付!"]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:kPayCancelNotification object:nil];
                }
            }];
        }];
    }
    return YES;
}

@end
