//
//  Consts.h
//  Base
//
//  Created by admin on 17/1/16.
//  Copyright © 2017年 XHY. All rights reserved.
//

#ifndef Consts_h
#define Consts_h
#import "NSString+AES.h"

//MARK:App风格风格属性
/// App主色
#define appThemeColor RGB(106,176,243,1.0)
/// 导航栏文本颜色
#define navigationTextColor [UIColor whiteColor]
/// 导航栏背景颜色
#define navigationBackgroundColor appThemeColor //[UIColor whiteColor]
/// 导航栏字体（titleView不允许被修改）
#define navigationTextFont  [UIFont systemFontOfSize:18]

/// 选中的文字 按扭 颜色
#define defaultSelectColor appThemeColor
/// 常规文字 （标题 icon）
#define defaultTextColor  RGB(85,86,87,1.0) 
#define defaultTextSize defaultSysFontWithSize(17)
/// 辅助 次要 文字 icon
#define defaultDetailTextColor RGB(174,174,174,1.0)
/// 小标题 描述  备注 评论 按扭  等
#define defaultDetailTextSize defaultSysFontWithSize(15)
/// 默认的分割线颜色
#define defaultLineColor RGB(299,299,299,1.0)

/// 默认灰色
#define defaultGrayColor RGB(240,240,240,1.0)
/// 默认背景色
#define defaultBackgroundColor defaultGrayColor
/// 默认灰色背景
#define defaultBackgroundGrayColor defaultGrayColor

// 次要标题 分类  备注
#define defaultButtonTextSize defaultSysFontWithSize(13)
#define defaultSysFontWithSize(size) [UIFont systemFontOfSize:size]

//灰色不可按button背景色
#define grayButtonBackgroundColor RGB(216,216,216,1.0)
/// 默认tableView背景色
#define tableViewdefaultBackgroundColor RGB(240,240,240,1.0)
/// 灰色的tableView背景色
#define tableViewGrayBackgroundColor RGB(241,242,243,1.0)

/// 默认Cell高度
#define tableViewCellDefaultHeight 56.0
/// 默念header高度
#define tableViewCellHeadDefaultHeight 10.0
/// 默认cell背景色
#define tableViewCellDefaultBackgroundColor [UIColor hyViewBackgroundColor]
/// 默认内容字体
#define tableViewCellDefaultTextFont [UIFont systemFontOfSize:17]
/// 默认内容颜色
#define tableViewCellDefaultTextColor defaultTextColor
/// 默认详情字体
#define tableViewCellDefaultDetailTextFont [UIFont systemFontOfSize:14]
/// 默认详情颜色
#define tableViewCellDefaultDetailTextColor [UIColor colorWithWhite:136/255.0 alpha:1.0]

//MARK:缩写
#define PI(obj) @property(nonatomic,assign) NSInteger obj
#define PB(obj) @property(nonatomic,assign) BOOL obj
#define PN(obj) @property(nonatomic,copy) NSString* obj

//MARK:-判断机型和系统
#define isiOS7Later (floor(NSFoundationVersionNumber) >= floor(NSFoundationVersionNumber_iOS_7_0))
#define isiOS8Later (floor(NSFoundationVersionNumber) >= floor(NSFoundationVersionNumber_iOS_8_0))
#define IS_IPHONE_4s ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define IS_IPHONE_5s ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
/// 系统名称
#define SYSTEM_NAME [[UIDevice currentDevice] systemName]
/// 系统版本号 （字符串）
#define SYSTEM_VERSION [[UIDevice currentDevice] systemVersion]
/// 系统版本号 （浮点数）
#define SYSTEM_VERSION_FLOAT [SYSTEM_VERSION floatValue]


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
#define RGB(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

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
#define kUserDefaults [NSUserDefaults standardUserDefaults]
//存
#define kSaveObjectToUserDefaults(object,key){\
    [kUserDefaults setObject:object forKey:key]; \
    [kUserDefaults synchronize]; \
}
//取
#define kGetObjectFromUserDefaults(key) [kUserDefaults objectForKey:key]
//删
#define kRemoveObjectFromUserDefault(key) {\
    [kUserDefaults removeObjectForKey:key];\
    [kUserDefaults synchronize];\
}
//MARK:-用户相关信息保存
//用户数据记录
#define k_SecretKey @"HeyuanXie"
#define kKeyCustomer [@"Customer" encrypt:k_SecretKey]
#define kKeyAccount [@"Account" encrypt:k_SecretKey]
#define kKeyPassword [@"Password" encrypt:k_SecretKey]

#define k_customer [ZMDCustomer yy_modelWithJSON:kGetObjectFromUserDefaults(kKeyCustomer)]
#define kSaveCustomer(customer) {\
    NSDictionary* dic = [customer yy_modelToJSONObject];\
    kSaveObjectToUserDefaults(dic, kKeyCustomer);\
}
#define kCleanCustomer kRemoveObjectFromUserDefault(kKeyCustomer)

///保存账号密码
#define kAccount [(NSString*)(kGetObjectFromUserDefaults(kKeyAccount)) decrypt:k_SecretKey]
#define kPassword [(NSString*)(kGetObjectFromUserDefaults(kKeyPassword)) decrypt:k_SecretKey]
#define kSaveAccountAndPassword(account,password) {\
    kSaveObjectToUserDefaults([account encrypt:k_SecretKey], kKeyAccount)\
    if (password == nil) {\
        kCleanPassword\
    }else{\
        kSaveObjectToUserDefaults([password encrypt:k_SecretKey], kKeyPassword)\
    }\
}
/// 清除密码
#define kCleanPassword {\
    kRemoveObjectFromUserDefault(kKeyPassword)\
}
/// 清除账号
#define kCleanAccount {\
    kRemoveObjectFromUserDefault(kKeyAccount)\
}



#endif /* Consts_h */
