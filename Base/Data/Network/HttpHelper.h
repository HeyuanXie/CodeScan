//
//  HttpHelper.h
//  Base
//
//  Created by admin on 2017/1/17.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

typedef void(^ApiRequestCompleteBlock)(BOOL isSuccess,NSDictionary* responseObject, NSError* error);

@interface HttpHelper : AFHTTPSessionManager

+ (HttpHelper*)shareInstance;

-(NSURLSessionDataTask*)getWithURL:(NSString*)relativeurl param:(NSDictionary*)parameters complete:(ApiRequestCompleteBlock)complete;

- (NSURLSessionDataTask*)postWithURL:(NSString*)relativeurl param:(NSDictionary*)parameters complete:(ApiRequestCompleteBlock)complete;

-(NSURLSessionDataTask*)uploadFileToServerByURL:(NSString*)relativeurl
                                          param:(NSDictionary*)parameters
                                           file:(NSData*)filedata
                                        fileURL:(NSURL*)fileURL
                                       filename:(NSString*)filename
                                       mimeType:(NSString*)mimeType
                                       progress:(void (^)(NSProgress *))uploadProgress
                                       complete:(ApiRequestCompleteBlock)complete;


@end
