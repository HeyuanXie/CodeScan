//
//  APIHelper+Common.m
//  Template
//
//  Created by hitao on 16/10/5.
//  Copyright © 2016年 hitao. All rights reserved.
//

#import "APIHelper+Common.h"

@implementation APIHelper (Common)


-(NSURLSessionDataTask*)uploadFileByType:(NSString *)type
                                    file:(NSData*)file
                                progress:(void (^)(NSProgress *))uploadProgress
                                complete:(ApiRequestCompleteBlock)complete{
    NSString* relativeurl = @"upload/image";
    
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param safe_setValue:type forKey:@"type"];
    
    return [[APIHelper shareInstance] uploadFileToServerByURL:relativeurl param:param file:file fileURL:nil filename:nil mimeType:nil progress:uploadProgress complete:complete];
}


- (void)feedback:(NSString *)content
            type:(NSString *)typeID
             pic:(NSArray *)picName
         contact:(NSString *)contact
        complete:(ApiRequestCompleteBlock)complete{
    
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param safe_setValue:content forKey:@"content"];
    [param safe_setValue:typeID forKey:@"type_id"];
    [param safe_setValue:picName forKey:@"pic"];
    [param safe_setValue:contact forKey:@"contact"];
    
    [APIHELPER postWithURL:@"feedback/save" param:param complete:complete];
}

- (void)fetchConfiguration:(ApiRequestCompleteBlock)complete{
    
    [APIHELPER postWithURL:@"config/index" param:nil complete:complete];
}

- (void)updateDeviceToken:(NSString *)deviceToken
                 complete:(ApiRequestCompleteBlock)complete{
    
    NSString *path = @"upload/token";
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param safe_setValue:deviceToken forKey:@"deviceToken"];
    [APIHELPER postWithURL:path param:param complete:complete];
}

- (void)checkVersionComplete:(ApiRequestCompleteBlock)complete{
    [APIHELPER getWithURL:@"config/checkVersion" param:nil complete:complete];
}

- (void)fetchMessage:(NSInteger)start
               limit:(NSInteger)limit
                type:(NSInteger)type
            complete:(ApiRequestCompleteBlock)complete {
    
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param safe_setValue:@(start) forKey:@"start"];
    [param safe_setValue:@(limit) forKey:@"limit"];
    [param safe_setValue:@(type) forKey:@"type"];
    [APIHELPER postWithURL:@"notify/index" param:param complete:complete];
}
@end

