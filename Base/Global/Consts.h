//
//  Consts.h
//  Base
//
//  Created by admin on 17/1/16.
//  Copyright © 2017年 XHY. All rights reserved.
//

#ifndef Consts_h
#define Consts_h

#import "NSObject+Routes.h"
#import "OpenRoutesManager.h"
#import "UIColor+HYColors.h"

//MARK:-判断机型和系统
#define isiOS7Later (floor(NSFoundationVersionNumber) >= floor(NSFoundationVersionNumber_iOS_7_0))
#define isiOS8Later (floor(NSFoundationVersionNumber) >= floor(NSFoundationVersionNumber_iOS_8_0))
#define IS_IPHONE_4s ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define IS_IPHONE_5s ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)


//MARK:-自定义打印(文件、方法、行数)
//2017-01-11 14:33:38.479 test[26337:1210426] -[ViewController requestData] [Line 31] A请求数据
#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"\n%@ %s [Line %d] " fmt), [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DLog(...)
#endif

//以UIAlert方式打印
#ifdef DEBUG
#define ULog(fmt, ...)  { UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%s\n [Line %d] ", __PRETTY_FUNCTION__, __LINE__] message:[NSString stringWithFormat:fmt, ##__VA_ARGS__]  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]; [alert show]; }
#else
#define ULog(...)
#endif

//MARK:-屏幕尺寸相关
#define kScreen_Height   ([UIScreen mainScreen].bounds.size.height)
#define kScreen_Width    ([UIScreen mainScreen].bounds.size.width)
#define KScreen_Scale    ([UIScreen mainScreen].scale)
#define zoom(value)     value*kScreen_Width/375.0

#define kDefaultNavigationBarHeight 64 //navigation bar高度


//MARK:-RGB(颜色)
#define UIColorFromHEX(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0 blue:((float)(rgbValue & 0xFF)) / 255.0 alpha:1.0]
#define UIColorFromHEXWithAlpha(rgbValue, a) [UIColor           \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 \
green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0    \
blue:((float)(rgbValue & 0xFF)) / 255.0             \
alpha:a]
#define RGB(r,g,b,a) [UIColor colorWithRed:r green:g blue:b alpha:a]

//MARK:-通知相关常量
#define kAfterUserLoginSuccessNotification     @"afterUserLoginSuccessNotification"
#define kNetNotReachabilityNotification      @"netNotReachabilityNotification"
#define kUserLogoutNotification             @"userLogoutNotification"

//MARK:-动画时间
#define HUD_MESSAGE_SHOWTIME 1.6f
#define VIEW_SHOW_ANIMATE_TIME 0.4f

//MARK:-GCD
#define kBACK(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
#define kMAIN(block) dispatch_async(dispatch_get_main_queue(),block)


//MARK:-其他
#define kNotificationCenter [NSNotificationCenter defaultCenter]
#define kApplication [UIApplication sharedApplication]
#define kAppDelegate ((AppDelegate*)[UIApplication sharedApplication].delegate)

#define ImageNamed(fp) [UIImage imageNamed:fp]

//#define kSaveObject




#endif /* Consts_h */
