//
//  APIHelper+Common.h
//  Template
//
//  Created by hitao on 16/10/5.
//  Copyright © 2016年 hitao. All rights reserved.
//

#import "APIHelper.h"

@interface APIHelper (Common)

- (NSURLSessionDataTask*)uploadFileByType:(NSString *)type
                                     file:(NSData*)file
                                 progress:(void (^)(NSProgress *))uploadProgress
                                 complete:(ApiRequestCompleteBlock)complete;

- (void)feedback:(NSString *)content
            type:(NSString *)typeID
             pic:(NSArray *)picName
         contact:(NSString *)contact
        complete:(ApiRequestCompleteBlock)complete;

- (void)fetchConfiguration:(ApiRequestCompleteBlock)complete;

/**
 更新DeviceToken

 @param deviceToken deviceToken
 @param complete complete description
 */
- (void)updateDeviceToken:(NSString *)deviceToken
                 complete:(ApiRequestCompleteBlock)complete;


/**
 检查版本更新

 @param complete complete description
 */
- (void)checkVersionComplete:(ApiRequestCompleteBlock)complete;



/**
 获取消息列表

 @param start <#start description#>
 @param limit <#limit description#>
 @param type 消息类型, 0:系统消息, 1:订单消息
 @param complete <#complete description#>
 */
- (void)fetchMessage:(NSInteger)start
               limit:(NSInteger)limit
                type:(NSInteger)type
            complete:(ApiRequestCompleteBlock)complete;
@end
