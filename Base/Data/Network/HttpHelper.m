//
//  HttpHelper.m
//  Base
//
//  Created by admin on 2017/1/17.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "HttpHelper.h"
#import "HYServer.h"
#import "NSError+HYError.h"
#import "NSDictionary+Safety.h"
#import "NSString+json.h"

#define SHOWNETDEBUG 0
@interface HttpHelper ()

@end

@implementation HttpHelper

+(HttpHelper *)shareInstance {
    static HttpHelper* helper = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        if (helper == nil) {
            helper = [[HttpHelper alloc] init];
            helper.responseSerializer = [AFJSONResponseSerializer serializer];
            helper.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
        }
    });
    return helper;
}

- (instancetype)init
{
    self = [super initWithBaseURL:[[HYServer defaultServer] APIEndpoint]];
    if (self) {
        
        self.requestSerializer.timeoutInterval = 10.0f;
        
        [self.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            switch (status) {
                case AFNetworkReachabilityStatusNotReachable:
                    break;
                case AFNetworkReachabilityStatusUnknown:
                {
                    NSLog(@"网络有问题了");
                    [kNotificationCenter postNotificationName:kNetNotReachabilityNotification object:nil];
                }
                    break;
                case AFNetworkReachabilityStatusReachableViaWiFi:
                {
                    NSLog(@"wifi");
                }
                    break;
                case AFNetworkReachabilityStatusReachableViaWWAN:
                {
                    NSLog(@"2G 3G");
                }
                    break;
                default:
                    break;
            }
        }];
        [self.reachabilityManager startMonitoring];
    }
    return self;
}

-(NSURLSessionDataTask *)getWithURL:(NSString *)relativeurl param:(NSDictionary *)parameters complete:(ApiRequestCompleteBlock)complete {
    [self.requestSerializer setValue:@"1" forHTTPHeaderField:@"App-id"];
    [self.requestSerializer setValue:API_VERSION forHTTPHeaderField:@"Version"];
    [self.requestSerializer setValue:[Global IDFV] forHTTPHeaderField:@"Client-id"];
    if ([Global userAuth]) {
        [self.requestSerializer setValue:[Global userAuth] forHTTPHeaderField:@"auth"];
    }else{
        [self.requestSerializer setValue:nil forHTTPHeaderField:@"auth"];
    }
    //    [self.requestSerializer setQueryStringSerializationWithBlock:^NSString * _Nonnull(NSURLRequest * _Nonnull request, id  _Nonnull parameters, NSError * _Nullable __autoreleasing * _Nullable error) {
    //        return parameters;
    //    }];
    
    return [self GET:relativeurl parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
#ifdef SHOWNETDEBUG
#if 1
        NSString *queryLog = [[NSString alloc] initWithData:task.originalRequest.HTTPBody encoding:NSUTF8StringEncoding];
        NSString *urlLog = [task.originalRequest.URL.absoluteString stringByAppendingString: [NSString stringWithFormat:task.originalRequest.URL.query ? @"&%@" : @"?%@", queryLog]];
        NSLog(@"http request success ---  GET---:\n%@\n", urlLog);
#endif
#endif
        
        NSDictionary *responseDict = responseObject;
        NSInteger code = [[responseDict objectForKey:@"code"] integerValue];
        if (code == 0) {
            if (complete) {
                //NSDictionary *dataDict = [responseDict objectForKey:@"data"];
                complete(YES, responseObject, nil);
            }
        } else {
            if (complete) {
                NSString *msg = [responseDict objectForKey:@"msg"];
                complete(NO, nil, [NSError errorWithServerErrorCode:code message:msg]);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
#ifdef SHOWNETDEBUG
#if 1
        NSString *queryLog = [[NSString alloc] initWithData:task.originalRequest.HTTPBody encoding:NSUTF8StringEncoding];
        NSString *urlLog = [task.originalRequest.URL.absoluteString stringByAppendingString: [NSString stringWithFormat:task.originalRequest.URL.query ? @"&%@" : @"?%@", queryLog]];
        NSLog(@"http request failure ---  GET---:\n%@\n", urlLog);
#endif
#endif
        if(complete){
            complete(NO, nil, error);}
    }];
}


-(NSURLSessionDataTask *)postWithURL:(NSString *)relativeurl param:(NSDictionary *)parameters complete:(ApiRequestCompleteBlock)complete {
    [self.requestSerializer setValue:@"1" forHTTPHeaderField:@"App-id"];
    [self.requestSerializer setValue:API_VERSION forHTTPHeaderField:@"Version"];
    [self.requestSerializer setValue:[Global IDFV] forHTTPHeaderField:@"Client-id"];
    if ([Global userAuth]) {
        [self.requestSerializer setValue:[Global userAuth] forHTTPHeaderField:@"auth"];
    }else{
        [self.requestSerializer setValue:nil forHTTPHeaderField:@"auth"];
    }
    
    //打印POST的JSON数据
    NSString* jsonStr = [NSString jsonStringWithDictionary:parameters];
    NSLog(@"%@",jsonStr);
    
    return [self POST:relativeurl parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
#ifdef SHOWNETDEBUG
#if 1
        NSString *queryLog = [[NSString alloc] initWithData:task.originalRequest.HTTPBody encoding:NSUTF8StringEncoding];
        NSString *urlLog = [task.originalRequest.URL.absoluteString stringByAppendingString: [NSString stringWithFormat:task.originalRequest.URL.query ? @"&%@" : @"?%@", queryLog]];
        NSLog(@"http request success ---  POST---:\n%@\n", urlLog);
#endif
#endif
        NSDictionary *responseDict = responseObject;
        NSInteger code = [[responseDict objectForKey:@"code"] integerValue];
        if (code == 0) {
            if (complete) {
                //NSDictionary *dataDict = [responseDict objectForKey:@"data"];
                complete(YES, responseObject, nil);
            }
        } else {
            if (complete) {
                NSString *msg = [responseDict objectForKey:@"msg"];
                complete(NO, nil, [NSError errorWithServerErrorCode:code message:msg]);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
#ifdef SHOWNETDEBUG
#if 1
        NSString *queryLog = [[NSString alloc] initWithData:task.originalRequest.HTTPBody encoding:NSUTF8StringEncoding];
        NSString *urlLog = [task.originalRequest.URL.absoluteString stringByAppendingString: [NSString stringWithFormat:task.originalRequest.URL.query ? @"&%@" : @"?%@", queryLog]];
        NSLog(@"http request failure ---  POST---:\n%@\n", urlLog);
#endif
#endif
        if (complete) {
            complete(NO, nil, error);
        }
    }];
}


-(NSURLSessionDataTask *)uploadFileToServerByURL:(NSString *)relativeurl param:(NSDictionary *)parameters file:(NSData *)filedata fileURL:(NSURL *)fileURL filename:(NSString *)filename mimeType:(NSString *)mimeType progress:(void (^)(NSProgress *))uploadProgress complete:(ApiRequestCompleteBlock)complete {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [dict safe_setValue:@"" forKey:@""];

    return [self POST:relativeurl parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (filedata) {
            [formData appendPartWithFileData:filedata name:@"file" fileName:filename mimeType:mimeType];
        }else if(fileURL){
            [formData appendPartWithFileURL:fileURL name:@"file" fileName:filename mimeType:mimeType error:nil];
        }
    } progress:uploadProgress
              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                  NSDictionary *responseDict = responseObject;
                  NSInteger code = [[responseDict objectForKey:@"code"] integerValue];
                  if (code == 0) {
                      if (complete) {
                          //NSDictionary *dataDict = [responseDict objectForKey:@"data"];
                          complete(YES, responseObject, nil);
                      }
                  } else {
                      if (complete) {
                          NSString *msg = [responseDict objectForKey:@"msg"];
                          complete(NO, nil, [NSError errorWithServerErrorCode:code message:msg]);
                      }
                  }
              } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
#ifdef SHOWNETDEBUG
#if 1
                  NSString *queryLog = [[NSString alloc] initWithData:task.originalRequest.HTTPBody encoding:NSUTF8StringEncoding];
                  NSString *urlLog = [task.originalRequest.URL.absoluteString stringByAppendingString: [NSString stringWithFormat:task.originalRequest.URL.query ? @"&%@" : @"?%@", queryLog]];
                  NSLog(@"http request failure ---  UPLOAD---:\n%@\n", urlLog);
#endif
#endif
                  
                  if(complete){
                      complete(NO, nil, error);}
              }];
}

@end
