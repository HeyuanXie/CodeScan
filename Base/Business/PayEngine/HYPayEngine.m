//
//  HYPayEngine.m
//  Base
//
//  Created by admin on 2017/1/17.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "HYPayEngine.h"
#import <AlipaySDK/AlipaySDK.h>

static NSString *const AppScheme = @"alisdkLittleElephant";

static NSString *const payApi = @"mobile_securitypay_pay";

@interface HYPayEngine()

@property(nonatomic, copy)WXPayFinishCallback wxPayCompletionHandler;

@end

@implementation HYPayEngine

+ (instancetype)sharePayEngine {
    static HYPayEngine* engine = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        engine = [[HYPayEngine alloc] init];
    });
    return engine;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (void)alipayWithOrderStr:(NSString *)orderStr withFinishBlock:(AlipayFinishCallback)alipayCallback {
    [[AlipaySDK defaultService] payOrder:orderStr fromScheme:AppScheme callback:^(NSDictionary *resultDic) {
        if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]) {
            alipayCallback(YES,nil);
        }
        else if ([resultDic[@"resultStatus"] isEqualToString:@"6001"]){
            alipayCallback(NO,@"您已经取消了支付");
        }
        else{
            alipayCallback(NO,resultDic[@"memo"]);
        }
        NSLog(@"%@",resultDic);
    }];
}

+ (void) wxpayWithPayInfo:(NSDictionary *) payInfo WithFinishBlock:(WXPayFinishCallback) wxpayCallback {
    
    if (![WXApi isWXAppInstalled]) {
        wxpayCallback(NO,10086,@"没有安装微信");
        return;
    }
    
    NSDictionary* dic = payInfo[@"pay_data"];
    PayReq *request = [[PayReq alloc] init];
    
    request.partnerId = dic[@"partnerid"];
    request.prepayId = dic[@"prepayid"];
    request.package = dic[@"package"];
    request.nonceStr = dic[@"noncestr"];
    request.timeStamp = [dic[@"timestamp"] intValue];
    request.sign = dic[@"sign"];
    
    [WXApi sendReq:request];
}


+ (void)wxpayCallbackWithResponse:(id)resp {
    [[HYPayEngine sharePayEngine] wxpayCallbackWithResponse:resp];
}
- (void) wxpayCallbackWithResponse:(BaseResp *) resp{
    switch (resp.errCode) {
        case WXSuccess:
        {
            if (self.wxPayCompletionHandler) {
                self.wxPayCompletionHandler(YES,WXSuccess,nil);
            }
        }
            break;
        case WXErrCodeUserCancel:{
            if (self.wxPayCompletionHandler) {
                self.wxPayCompletionHandler(NO,resp.errCode,@"您已经取消了支付");
            }
        }
            break;
        default:
        {
            if (self.wxPayCompletionHandler) {
                self.wxPayCompletionHandler(NO,resp.errCode,resp.errStr);
            }
        }
            break;
    }
}

@end
