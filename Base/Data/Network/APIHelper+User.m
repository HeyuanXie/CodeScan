//
//  APIHelper+User.m
//  Base
//
//  Created by admin on 2017/1/17.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "APIHelper+User.h"
#import "NSString+HYUtilities.h"

@implementation APIHelper (User)

- (void)regist:(NSString *)account
      password:(NSString *)pw
          code:(NSString *)code
      complete:(ApiRequestCompleteBlock)complete{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param safe_setValue:account forKey:@"phone"];
    [param safe_setValue:pw forKey:@"password"];
    [param safe_setValue:code forKey:@"code"];
    
    [APIHELPER postWithURL:@"auth/signup" param:param complete:complete];
}

- (void)login:(NSString *)account
     password:(NSString *)pw
     complete:(ApiRequestCompleteBlock)complete{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSString* salt = @"12345";
    NSString* sha1Str = [[[pw sha1String] lowercaseString] stringByAppendingString:salt];
    NSString* sha1PS = [[sha1Str sha1String] lowercaseString];
    [param safe_setValue:account forKey:@"account"];
    [param safe_setValue:sha1PS forKey:@"password"];
    [param safe_setValue:@"12345" forKey:@"salt"];
    
    [APIHELPER postWithURL:@"auth/login" param:param complete:complete];
}

- (void)resetPW:(NSString *)phone
           code:(NSString *)code
       password:(NSString *)pw
       complete:(ApiRequestCompleteBlock)complete{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param safe_setValue:phone forKey:@"phone"];
    [param safe_setValue:pw forKey:@"password"];
    [param safe_setValue:code forKey:@"code"];
    
    [APIHELPER postWithURL:@"auth/resetPassword" param:param complete:complete];
}

- (void)modifyPW:(NSString *)old
             the:(NSString *)theNew
        complete:(ApiRequestCompleteBlock)complete{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param safe_setValue:old forKey:@"old_password"];
    [param safe_setValue:theNew forKey:@"new_password"];
    
    [APIHELPER postWithURL:@"user/resetPassword" param:param complete:complete];
}

- (void)updateUserInfo:(NSString *)nickname
                  face:(NSString *)face
                   sex:(NSInteger)sex
              birthday:(NSString *)birthday
                  area:(NSString *)areaID
              complete:(ApiRequestCompleteBlock)complete{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param safe_setValue:nickname forKey:@"nickname"];
    [param safe_setValue:face forKey:@"header_img"];
    [param safe_setValue:@(sex) forKey:@"gender"];
    [param safe_setValue:birthday forKey:@"birthday"];
    [param safe_setValue:areaID forKey:@"city_id"];
    
    [APIHELPER postWithURL:@"user/update" param:param complete:complete];
}

- (void)fetchUserInfo:(ApiRequestCompleteBlock)complete{
    [APIHELPER postWithURL:@"user/my" param:nil complete:complete];
}

- (void)fetchResetPWCode:(NSString *)phone
                complete:(ApiRequestCompleteBlock)complete{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param safe_setValue:phone forKey:@"phone"];
    
    [APIHELPER postWithURL:@"auth/resetCode" param:param complete:complete];
}

- (void)fetchRegistCode:(NSString *)phone
               complete:(ApiRequestCompleteBlock)complete{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param safe_setValue:phone forKey:@"phone"];
    
    [APIHELPER postWithURL:@"auth/regCode" param:param complete:complete];
}

- (void)logout{
    //退出登陆，清空UserAuth和userInfo
    [Global setUserAuth:nil];
    self.userInfo = nil;
    kCleanPassword;
}

- (void)collect:(NSInteger)collectionId
           type:(NSInteger)type
       complete:(ApiRequestCompleteBlock)complete {
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param safe_setValue:@(collectionId) forKey:@"collection_id"];
    [param safe_setValue:@(type) forKey:@"type"];
    [APIHELPER getWithURL:@"collect/collect" param:param complete:complete];
}

- (void)cancelCollect:(NSInteger)collectionId
                 type:(NSInteger)type
             complete:(ApiRequestCompleteBlock)complete {
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param safe_setValue:@(collectionId) forKey:@"collection_id"];
    [param safe_setValue:@(type) forKey:@"type"];
    [APIHELPER getWithURL:@"collect/cancelColl" param:param complete:complete];
}

- (void)fetchCollectList:(NSInteger)start limit:(NSInteger)limit type:(NSInteger)type complete:(ApiRequestCompleteBlock)complete {
    
    NSMutableDictionary* param = [NSMutableDictionary dictionary];
    [param safe_setValue:@(start) forKey:@"start"];
    [param safe_setValue:@(limit) forKey:@"limit"];
    [param safe_setValue:@(type) forKey:@"type"];
    [APIHELPER getWithURL:@"collect/collectlist" param:param complete:complete];
}

/**
 积分管理

 @param complete <#complete description#>
 */
- (void)scoreManageComplete:(ApiRequestCompleteBlock)complete {
    
    [APIHELPER getWithURL:@"user/scoremanage" param:nil complete:complete];
}

/**
 积分明细

 @param start start
 @param limit limit
 @param complte complte
 */
- (void)scoreInfoList:(NSInteger)start limit:(NSInteger)limit complete:(ApiRequestCompleteBlock)complte {
    
    NSMutableDictionary* param = [NSMutableDictionary dictionary];
    [param safe_setValue:@(start) forKey:@"start"];
    [param safe_setValue:@(limit) forKey:@"limit"];
    [APIHELPER getWithURL:@"user/scoreinfo" param:param complete:complte];
}

/**
 积分每日签到

 @param complete complete 
 */
- (void)scoreSignComplete:(ApiRequestCompleteBlock)complete {
    
    [APIHELPER getWithURL:@"user/sign" param:nil complete:complete];
}


/**
 获取我的年卡列表

 @param start <#start description#>
 @param limit <#limit description#>
 @param complete <#complete description#>
 */
- (void)mineYearCardList:(NSInteger)start limit:(NSInteger)limit complete:(ApiRequestCompleteBlock)complete {
    
    NSMutableDictionary* param = [NSMutableDictionary dictionary];
    [param safe_setValue:@(start) forKey:@"start"];
    [param safe_setValue:@(limit) forKey:@"limit"];
    [APIHELPER getWithURL:@"card/myCardList" param:param complete:complete];
}

@end
