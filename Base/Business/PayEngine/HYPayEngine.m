//
//  HYPayEngine.m
//  Base
//
//  Created by admin on 2017/1/17.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "HYPayEngine.h"
#import "NSString+HYUtilities.h"
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
    
    PayReq *request = [[PayReq alloc] init];
    
    request.partnerId = payInfo[@"partnerid"];
    request.prepayId = payInfo[@"prepayid"];
    request.package = payInfo[@"package_value"];
    request.nonceStr = payInfo[@"noncestr"];
    request.timeStamp = [payInfo[@"timestamp"] intValue];
    request.sign = payInfo[@"sign"];
    
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

- (void)onResp:(BaseResp *)resp {
        
    NSString * strTitle = [NSString stringWithFormat:@"支付结果"];
    NSString *strMsg;
//    if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]) {
//        
//        strMsg = @"恭喜您，支付成功!";
//        
//    }else if([resultDic[@"resultStatus"] isEqualToString:@"6001"])
//    {
//        strMsg = @"已取消支付!";
//        
//    }else{
//        strMsg = @"支付失败!";
//    }
//    HYAlertView* alert = [HYAlertView sharedInstance];
//    [alert showAlertView:strTitle message:strMsg subBottonTitle:@"确定" handler:^(AlertViewClickBottonType bottonType) {
//        if ([strMsg isEqualToString:@"恭喜您，支付成功!"]) {
//            [[NSNotificationCenter defaultCenter] postNotificationName:kPaySuccessNotification object:nil];
//        }
//        if ([strMsg isEqualToString:@"已取消支付!"]) {
//            [[NSNotificationCenter defaultCenter] postNotificationName:kPayCancelNotification object:nil];
//        }
//    }];

    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        strTitle = [NSString stringWithFormat:@"支付结果"];
        
        switch (resp.errCode) {
            case WXSuccess:{
                strMsg = @"恭喜您，支付成功!";
                
                [[NSNotificationCenter defaultCenter] postNotificationName:kPaySuccessNotification object:nil userInfo:@{@"status":@"success"}];
                
                break;
            }
            case WXErrCodeUserCancel:{
                strMsg = @"已取消支付!";
                [[NSNotificationCenter defaultCenter] postNotificationName:kPayCancelNotification object:nil userInfo:@{@"status":@"cancle"}];
                break;
            }
            default:{
                
                strMsg = [NSString stringWithFormat:@"支付失败 !"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"payFailed" object:nil userInfo:@{@"status":@"cancle"}];
                break;
            }
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        [alert show];
    }
}

@end
