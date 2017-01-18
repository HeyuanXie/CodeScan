//
//  HYPayEngine.m
//  Base
//
//  Created by admin on 2017/1/17.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "HYPayEngine.h"
#import <AlipaySDK/AlipaySDK.h>

static NSString *const AppScheme = @"";

static NSString *const payApi = @"mobile_securitypay_pay";

@interface HYPayEngine()

@property(nonatomic, copy)WXPayFinishCallback wxpayCompletionHandler;

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



+ (void)alipayArticleInfo:(NSDictionary *)payInfo WithFinishBlock:(AlipayFinishCallback)alipayCallback {
    [[HYPayEngine sharePayEngine] aliPayArticleInfo:payInfo WithFinishBlock:alipayCallback];
}
- (void) aliPayArticleInfo:(NSDictionary *) payInfo
           WithFinishBlock:(AlipayFinishCallback) alipayCallback{
    
    
    NSMutableDictionary * mutableDic = [NSMutableDictionary dictionaryWithDictionary:payInfo];
    [mutableDic setObject:@"1" forKey:@"pay_methods"];
    
    //    [GT_CLIENT call:payApi parameters:mutableDic success:^(id dic) {
    //        NSDictionary * responseDic = dic;
    //
    //        [[AlipaySDK defaultService] payOrder:responseDic[@"payurl"] fromScheme:AppScheme callback:^(NSDictionary *resultDic) {
    //            if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]) {
    //                alipayCallback(YES,nil);
    //            }
    //            else if ([resultDic[@"resultStatus"] isEqualToString:@"6001"]){
    //                alipayCallback(NO,@"您已经取消了支付");
    //            }
    //            else{
    //                alipayCallback(NO,resultDic[@"memo"]);
    //            }
    //        }];
    //
    //    } failure:^(NSError * error) {
    //        alipayCallback(NO,@"支付失败");
    //    }];
    
}

+ (void)wxpayArticleInfo:(NSDictionary *)payInfo WithFinishBlock:(WXPayFinishCallback)wxpayCallback {
    [[HYPayEngine sharePayEngine] wxPayParameter:payInfo WithFinishBlock:wxpayCallback];
}
- (void) wxPayParameter:(NSDictionary *) payInfo
        WithFinishBlock:(WXPayFinishCallback) wxPayCallback{
    
//    if (![WXApi isWXAppInstalled]) {
//        wxPayCallback(NO,10086,@"没有安装微信");
//        return;
//    }
//    
//    self.wxPayCompletionHandler = [wxPayCallback copy];
//    
//    NSMutableDictionary *mutableDic = [NSMutableDictionary dictionaryWithDictionary:payInfo];
//    
//    [mutableDic setObject:@"2" forKey:@"pay_methods"];
    
    //    [GT_CLIENT call:payApi parameters:mutableDic success:^(id response) {
    //
    //        NSDictionary *dic = response;
    //
    //        PayReq *request = [[PayReq alloc] init];
    //
    //        request.partnerId = dic[@"partnerid"];
    //        request.prepayId = dic[@"prepayid"];
    //        request.package = dic[@"package"];
    //        request.nonceStr = dic[@"noncestr"];
    //        request.timeStamp = [dic[@"timestamp"] intValue];
    //        request.sign = dic[@"sign"];
    //
    //        [WXApi sendReq:request];
    //
    //    } failure:^(NSError *error) {
    //
    //        wxPayCallback(NO,error.code,@"支付失败");
    //        
    //    }];
}

//+ (void)wxpayCallbackWithResponse:(id)resp {
//    [[HYPayEngine sharePayEngine] wxpayCallbackWithResponse:resp];
//}
//- (void) wxpayCallbackWithResponse:(BaseResp *) resp{
//    switch (resp.errCode) {
//        case WXSuccess:
//        {
//            if (self.wxPayCompletionHandler) {
//                self.wxPayCompletionHandler(YES,WXSuccess,nil);
//            }
//        }
//            break;
//        case WXErrCodeUserCancel:{
//            if (self.wxPayCompletionHandler) {
//                self.wxPayCompletionHandler(NO,resp.errCode,@"您已经取消了支付");
//            }
//        }
//            break;
//        default:
//        {
//            if (self.wxPayCompletionHandler) {
//                self.wxPayCompletionHandler(NO,resp.errCode,resp.errStr);
//            }
//        }
//            break;
//    }
//}

@end
