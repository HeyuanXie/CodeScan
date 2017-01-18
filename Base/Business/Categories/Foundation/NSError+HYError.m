//
//  NSError+HYError.m
//  Base
//
//  Created by admin on 17/1/16.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "NSError+HYError.h"

NSString *const HYClientErrorDomain = @"HYClientErrorDomain";
NSString *const HYClientErrorDataKey = @"HYClientErrorDataKey";
const NSInteger HYClientErrorAuthenticationFailed = 666;
const NSInteger HYClientErrorServiceRequestFailed = 667;
const NSInteger HYClientErrorConnectionFailed = 668;
const NSInteger HYClientErrorJSONParsingFailed = 669;
const NSInteger HYClientErrorBadRequest = 670;
const NSInteger HYClientErrorServiceDataError = 671;
const NSInteger HYClientErrorOperationCancelled = 672;


NSString * const HYClientErrorRequestURLKey     = @"HYClientErrorRequestURLKey";
NSString * const HYClientErrorHYTPStatusCodeKey = @"HYClientErrorHTTPStatusCodeKey";
NSString * const HYClientErrorDescriptionKey    = @"HYClientErrorDescriptionKey";
NSString * const HYClientErrorMessagesKey       = @"HYClientErrorMessagesKey";

@implementation NSError (HYError)

+(instancetype)errorWithAFNetworkingError:(NSError *)error {
    if (error.code == -999) {
        return [NSError errorWithDomain:HYClientErrorDomain code:HYClientErrorOperationCancelled userInfo:@{NSLocalizedDescriptionKey:@"取消网络操作!"}];
    }else{
        return [NSError errorWithDomain:HYClientErrorDomain code:HYClientErrorConnectionFailed userInfo:@{NSLocalizedDescriptionKey:@"网络连接失败!"}];
    }
}

+(instancetype)errorWithJsonParseError:(NSError *)error {
    return [NSError errorWithDomain:HYClientErrorDomain code:HYClientErrorJSONParsingFailed userInfo:@{NSLocalizedDescriptionKey:@"数据解析失败!"}];
}

+(instancetype)errorWithServerErrorCode:(NSInteger)code message:(NSString *)message {
    return [NSError errorWithDomain:HYClientErrorDomain code:code userInfo:@{NSLocalizedDescriptionKey:message ? message : @"未知错误01"}];
}

+(instancetype)errorWithServerErrorCode:(NSInteger)code message:(NSString *)message data:(NSDictionary *)data {
    NSDictionary *info = [NSMutableDictionary dictionary];
    [info setValue:data forKey:HYClientErrorDataKey];
    [info setValue:(message ? message : @"未知错误02！") forKey:NSLocalizedDescriptionKey];
    return [NSError errorWithDomain:HYClientErrorDomain
                               code:code
                           userInfo:info];
}

-(NSString *)HYErrorUserMessage {
    return self.localizedDescription;
}

-(BOOL)isNetworkError {
    if (self.code == HYClientErrorConnectionFailed) {
        return YES;
    }else{
        return NO;
    }
}



@end
