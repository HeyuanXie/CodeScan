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


/**
 忘记密码重置密码

 @param phone <#phone description#>
 @param code <#code description#>
 @param pw <#pw description#>
 @param complete <#complete description#>
 */
- (void)resetPW:(NSString *)phone
           code:(NSString *)code
       password:(NSString *)pw
       complete:(ApiRequestCompleteBlock)complete{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param safe_setValue:phone forKey:@"phone"];
    [param safe_setValue:pw forKey:@"new_password"];
    [param safe_setValue:code forKey:@"captcha"];
    
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



/**
 获取手机验证码

 @param phone <#phone description#>
 @param type 验证码类型,safe:安全验证; bind:绑定手机
 @param complete <#complete description#>
 */
- (void)fetchCode:(NSString*)phone
             type:(NSString*)type
         complete:(ApiRequestCompleteBlock)complete {
    
    NSMutableDictionary* param = [NSMutableDictionary dictionary];
    [param safe_setValue:phone forKey:@"phone"];
    [param safe_setValue:type forKey:@"type"];

    [APIHELPER postWithURL:@"auth/sendCode" param:param complete:complete];
}

//
/**
 检验手机验证码

 @param phone <#phone description#>
 @param code <#code description#>
 @param type 验证码类型,safe:安全验证; bind:绑定手机
 @param complete <#complete description#>
 */
- (void)checkCode:(NSString*)phone
             code:(NSString*)code
             type:(NSString*)type
         complete:(ApiRequestCompleteBlock)complete {
    
    NSMutableDictionary* param = [NSMutableDictionary dictionary];
    [param safe_setValue:phone forKey:@"phone"];
    [param safe_setValue:code forKey:@"code"];
    [param safe_setValue:type forKey:@"type"];
    
    [APIHELPER postWithURL:@"auth/checkCode" param:param complete:complete];
}

//绑定手机
- (void)bindPhone:(NSString*)phone
             code:(NSString*)code
         complete:(ApiRequestCompleteBlock)complete {
    
    NSMutableDictionary* param = [NSMutableDictionary dictionary];
    [param safe_setValue:phone forKey:@"phone"];
    [param safe_setValue:code forKey:@"code"];
    
    [APIHELPER postWithURL:@"auth/bindPhone" param:param complete:complete];
}

//修改密码
- (void)changePassword:(NSString*)newPassword
               captcha:(NSString*)captcha
              complete:(ApiRequestCompleteBlock)complete {
    
    NSMutableDictionary* param = [NSMutableDictionary dictionary];
    [param safe_setValue:newPassword forKey:@"new_password"];
    [param safe_setValue:captcha forKey:@"captcha"];
    
    [APIHELPER postWithURL:@"auth/changePassword" param:param complete:complete];
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



/**
 获取我的优惠券列表

 @param start <#start description#>
 @param limit <#limit description#>
 @param orderType 优惠券使用类型,0:全部，1:购票使用，2:年卡使用
 @param complete <#complete description#>
 */
- (void)mineCouponList:(NSInteger)start
                 limit:(NSInteger)limit
             orderType:(NSInteger)orderType
              complete:(ApiRequestCompleteBlock)complete {
    
    NSMutableDictionary* param = [NSMutableDictionary dictionary];
    [param safe_setValue:@(start) forKey:@"start"];
    [param safe_setValue:@(limit) forKey:@"limit"];
    [param safe_setValue:@(orderType) forKey:@"order_type"];
    [APIHELPER getWithURL:@"coupon/my" param:param complete:complete];
}


/**
 获取我的评价列表

 @param start <#start description#>
 @param limit <#limit description#>
 @param type 评价类型,1:剧评; 2:商品评价
 @param complete <#complete description#>
 */
- (void)mineCommentList:(NSInteger)start
                  limit:(NSInteger)limit
                   type:(NSInteger)type
               complete:(ApiRequestCompleteBlock)complete {
    
    NSMutableDictionary* param = [NSMutableDictionary dictionary];
    [param safe_setValue:@(start) forKey:@"start"];
    [param safe_setValue:@(limit) forKey:@"limit"];
    [param safe_setValue:@(type) forKey:@"type"];
    [APIHELPER getWithURL:@"user/comments" param:param complete:complete];
}

@end
