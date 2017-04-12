//
//  HYPayEngine.h
//  Base
//
//  Created by admin on 2017/1/17.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"

typedef void(^AlipayFinishCallback)(BOOL success, NSString* payMessage);
typedef void(^WXPayFinishCallback)(BOOL success, NSInteger code, NSString* payMessage);

@interface HYPayEngine : NSObject<WXApiDelegate>

+(instancetype)sharePayEngine;

+ (void) alipayWithPayInfo:(NSDictionary*)payInfo withFinishBlock:(AlipayFinishCallback) alipayCallback;

+ (void) wxpayWithPayInfo:(NSDictionary *) payInfo WithFinishBlock:(WXPayFinishCallback) wxpayCallback;

+ (void) wxpayCallbackWithResponse:(BaseResp *) resp;

@end
