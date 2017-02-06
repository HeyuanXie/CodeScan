//
//  APIHelper.h
//  Base
//
//  Created by admin on 2017/1/17.
//  Copyright © 2017年 XHY. All rights reserved.
//

//AFNetworking的第二层封装

#import <Foundation/Foundation.h>
#import "NSDictionary+Safety.h"
#import "HttpHelper.h"

#define APIHELPER ([APIHelper shareInstance])

@interface APIHelper : NSObject

@property(nonatomic, copy)NSDictionary* config;

+(instancetype)shareInstance;


- (NSURLSessionDataTask*)getWithURL:(NSString*)relativeurl
                              param:(NSDictionary*)parameters
                           complete:(ApiRequestCompleteBlock)complete;


- (NSURLSessionDataTask*)postWithURL:(NSString*)relativeurl
                                     param:(NSDictionary*)parameters
                                  complete:(ApiRequestCompleteBlock)complete;


- (NSURLSessionDataTask*)uploadFileToServerByURL:(NSString*)relativeurl
                                           param:(NSDictionary*)parameters
                                            file:(NSData*)filedata
                                         fileURL:(NSURL*)fileURL
                                        filename:(NSString*)filename
                                        mimeType:(NSString*)mimeType
                                        progress:(void (^)(NSProgress *))uploadProgress
                                        complete:(ApiRequestCompleteBlock)complete;

@end
