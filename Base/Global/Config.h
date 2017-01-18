//
//  Config.h
//  Base
//
//  Created by admin on 17/1/16.
//  Copyright © 2017年 XHY. All rights reserved.
//

#ifndef Config_h
#define Config_h

////////////////////////////////////////////////////////////////
//服务器地址配置

#define API_VERSION @"1.0"  //接口版本

#ifdef HY_PRODUCT        //线上环境

#define DEFAULT_SERVER @"https://talent.ssl.gov.cn/api"
#define DEFAULT_END_POINT @"/"
#define DEFAULT_PATH @"api"

#else                   //线下环境

#define DEFAULT_SERVER @"https://talent.ssl.gov.cn"
#define DEFAULT_END_POINT @"/"
#define DEFAULT_PATH @""

#endif


////////////////////////////////////////////////////////////////
//配置其他第三方平台的相关信息(AppKey、APPSecret...)

#endif /* Config_h */
