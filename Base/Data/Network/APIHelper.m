//
//  APIHelper.m
//  Base
//
//  Created by admin on 2017/1/17.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "APIHelper.h"

@implementation APIHelper

+ (APIHelper*)shareInstance{
    static APIHelper* content = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (content == nil) {
            content = [[APIHelper alloc] init];
        }
    });
    return content;
}


- (NSURLSessionDataTask*)getWithURL:(NSString*)relativeurl
                              param:(NSDictionary*)parameters
                           complete:(ApiRequestCompleteBlock)complete{
    return [[HttpHelper shareInstance] getWithURL:relativeurl param:parameters complete:complete];
}


- (NSURLSessionDataTask*)postWithURL:(NSString*)relativeurl
                                     param:(NSDictionary*)parameters
                                  complete:(ApiRequestCompleteBlock)complete{
    return [[HttpHelper shareInstance] postWithURL:relativeurl param:parameters complete:complete];
}


- (NSURLSessionDataTask*)uploadFileToServerByURL:(NSString*)relativeurl
                                           param:(NSDictionary*)parameters
                                            file:(NSData*)filedata
                                         fileURL:(NSURL*)fileURL
                                        filename:(NSString*)filename
                                        mimeType:(NSString*)mimeType
                                        progress:(void (^)(NSProgress *))uploadProgress
                                        complete:(ApiRequestCompleteBlock)complete
{
    if (mimeType==nil) mimeType = @"image/jpeg";
    if (filename==nil) filename = @"file.jpg";
    return [[HttpHelper shareInstance] uploadFileToServerByURL:relativeurl param:parameters file:filedata fileURL:fileURL filename:filename mimeType:mimeType progress:uploadProgress complete:complete];
}


@end
