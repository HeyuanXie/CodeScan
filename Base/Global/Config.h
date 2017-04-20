//
//  Config.h
//  Base
//
//  Created by admin on 17/1/16.
//  Copyright © 2017年 XHY. All rights reserved.
//

#ifndef Config_h
#define Config_h


/// CheckUpdate
#define APP_ID @"1226343681"
/// APP 本地version
#define APP_VERSION (NSString*)[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]
/// APP 下载地址
#define APP_URL_IN_ITUNE [NSString stringWithFormat:@"https://itunes.apple.com/cn/app/id%@?ls=1&mt=8",APP_ID]
/// APP 详细信息地址
#define APP_URL_DETAIL [NSString stringWithFormat:@"http://itunes.apple.com/cn/lookup?id=%@",APP_ID]



////////////////////////////////////////////////////////////////
//服务器地址配置
#define DEFAULT_SERVER @"http://api.xfx.zhimadi.cn" //http://admin.vipxfx.com
//#define DEFAULT_SERVER @"http://admin.vipxfx.com"
#define DEFAULT_END_POINT @"/"
#define DEFAULT_PATH @""

#define API_VERSION @"1.0"  //接口版本



////////////////////////////////////////////////////////////////
//配置其他第三方平台的相关信息(AppKey、APPSecret...)
#define kWX_APPID @"wx443d437fb523c7a6"
#define kWX_KEY @"378c7b2fd869e5ceb54142e142a8f0e0"

#define kQQ_APPID @"1106100126"
#define kQQ_KEY @"vuFTzubcAGyOGWPu"

#define kSINA_APPID @""
#define kSINA_KEY @""
#define kSINA_REDIRECTURL @""

#define kShareSDK_APPID @"1cf7407db19ac"
#define kShareSDK_KEY @"9ac05636db4a300fe0cf9ba5c38f10da"

#define AlIPAY_APPID @"2017032706422812"

#define JPUSH_APPKEY @"0e5f4a2cb80162f6af564d0f"
#define JPUSH_SECRET @"40921b24c1537c1f3d1b68f5"

#endif /* Config_h */
