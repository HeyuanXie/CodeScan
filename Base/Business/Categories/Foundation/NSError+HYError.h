//
//  NSError+HYError.h
//  Base
//
//  Created by admin on 17/1/16.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const HYClientErrorDomain;

extern NSString *const HYClientErrorDataKey;

// 认证失败
extern const NSInteger HYClientErrorAuthenticationFailed;

// 服务器无法处理请求
extern const NSInteger HYClientErrorServiceRequestFailed;

// 连接失败（Cancel或者网络错误）
extern const NSInteger HYClientErrorConnectionFailed;

// JSON解析失败
extern const NSInteger HYClientErrorJSONParsingFailed;

// 参数错误
extern const NSInteger HYClientErrorBadRequest;

// 服务器内部错误
extern const NSInteger HYClientErrorServiceDataError;

// 取消网络请求
extern const NSInteger HYClientErrorOperationCancelled;

//Request URL Key in userinfo dictionary
extern NSString * const HYClientErrorRequestURLKey;

//HYTP Status Code Key in userinfo dictionary
extern NSString * const HYClientErrorHYTPStatusCodeKey;

//Error description Key in userinfo dictionary
extern NSString * const HYClientErrorDescriptionKey;

//Error message Key in userinfo dictionary
extern NSString * const HYClientErrorMessagesKey;

@interface NSError (HYError)

// Map AFNetworking error to customized error
+ (instancetype)errorWithAFNetworkingError:(NSError *)error;

// Map json parse error to customized error
+ (instancetype)errorWithJsonParseError:(NSError *)error;

// Map Server error to customized error
+ (instancetype)errorWithServerErrorCode:(NSInteger)code message:(NSString *)message;

+ (instancetype)errorWithServerErrorCode:(NSInteger)code message:(NSString *)message data:(NSDictionary *)data;

// Get user message from error
- (NSString *)HYErrorUserMessage;

- (BOOL)isNetworkError;

@end
