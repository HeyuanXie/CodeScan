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
#import "BaseNavigationController.h"

// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

@interface AppDelegate ()<JPUSHRegisterDelegate>

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
    [self configShareSDK];
    [self configPaySDK];
    [self configJPushOptions:launchOptions];
    
    [APIHELPER checkUpdate];
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
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"canReceiveNotification" object:nil];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    [JPUSHService registerDeviceToken:deviceToken];
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

#pragma mark- JPUSH
//MARK: init JPush
- (void)configJPushOptions:(NSDictionary *)launchOptions {
    
    //初始化apns
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }else{
        
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];

    //初始化JPush
    // notice: 2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    [JPUSHService setupWithOption:launchOptions appKey:JPUSH_APPKEY
                          channel:@"App Store"
                 apsForProduction:0
            advertisingIdentifier:nil];
    
    //设置Icon角标
    [kApplication setApplicationIconBadgeNumber:0];
    [JPUSHService resetBadge];
    
    //监听极光推送的自定义消息(只有在前台才能收到)
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
}

- (void)networkDidReceiveMessage:(NSNotification *)notification {
    NSDictionary * userInfo = [notification userInfo];
    //服务端中Extras字段，key是自己定义的
    NSInteger noticeCode = [[userInfo valueForKey:@"notice_code"] integerValue];
    NSInteger orderType = [[userInfo valueForKey:@"order_type"] integerValue];
    NSString *orderId = [userInfo valueForKey:@"order_id"];
    NSString *content = [userInfo valueForKey:@"content"];
    
    HYAlertView* alert = [HYAlertView sharedInstance];
    [alert showAlertView:@"您有新消息,是否立即查看!" message:content subBottonTitle:@"确定" cancelButtonTitle:@"取消" handler:^(AlertViewClickBottonType bottonType) {
        switch (bottonType) {
            case AlertViewClickBottonTypeSubBotton:
                if (noticeCode==0) {
                    APPROUTE(([NSString stringWithFormat:@"%@?type=%ld",kMessageListController,noticeCode]));
                }else{
                    if (orderType == 2) {
                        APPROUTE(([NSString stringWithFormat:@"%@?orderId=%@",kYearCardOrderController,orderId]));
                    }else{
                        APPROUTE(([NSString stringWithFormat:@"%@?contentType=%d&orderId=%@",kOrderDetailController,orderType==1?0:2,orderId]));
                    }
                }
                break;
            default:
                break;
        }
    }];
}


//MARK: JPush delegate
// iOS 10 Support(Foreground)
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    //服务端中Extras字段，key是自己定义的
    NSInteger noticeCode = [[userInfo valueForKey:@"notice_code"] integerValue];
    NSInteger orderType = [[userInfo valueForKey:@"order_type"] integerValue];
    NSString *orderId = [userInfo valueForKey:@"order_id"];
    NSString *content = [userInfo valueForKey:@"content"];
    
    HYAlertView* alert = [HYAlertView sharedInstance];
    [alert showAlertView:@"您有新消息,是否立即查看!" message:content subBottonTitle:@"确定" cancelButtonTitle:@"取消" handler:^(AlertViewClickBottonType bottonType) {
        switch (bottonType) {
            case AlertViewClickBottonTypeSubBotton:
                if (noticeCode==0) {
                    APPROUTE(([NSString stringWithFormat:@"%@?type=%ld",kMessageListController,noticeCode]));
                }else{
                    if (orderType == 2) {
                        APPROUTE(([NSString stringWithFormat:@"%@?orderId=%@",kYearCardOrderController,orderId]));
                    }else{
                        APPROUTE(([NSString stringWithFormat:@"%@?contentType=%d&orderId=%@",kOrderDetailController,orderType==1?0:2,orderId]));
                    }
                }
                break;
            default:
                break;
        }
    }];

    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}

// iOS 10 Support(background)
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    NSInteger badge = [userInfo[@"aps"][@"badge"] integerValue];
    [JPUSHService setBadge:badge-1];
    [kApplication setApplicationIconBadgeNumber:badge-1];
    //服务端中Extras字段，key是自己定义的
    NSInteger noticeCode = [[userInfo valueForKey:@"notice_code"] integerValue];
    NSInteger orderType = [[userInfo valueForKey:@"order_type"] integerValue];
    NSString *orderId = [userInfo valueForKey:@"order_id"];
    if (noticeCode==0) {
        APPROUTE(([NSString stringWithFormat:@"%@?type=%ld",kMessageListController,noticeCode]));
    }else{
        if (orderType == 2) {
            APPROUTE(([NSString stringWithFormat:@"%@?orderId=%@",kYearCardOrderController,orderId]));
        }else{
            APPROUTE(([NSString stringWithFormat:@"%@?contentType=%d&orderId=%@",kOrderDetailController,orderType==1?0:2,orderId]));
        }
    }
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        DLog(@"iOS10 收到远程通知");
        
    }
    completionHandler();  // 系统要求执行这个方法
}
@end
