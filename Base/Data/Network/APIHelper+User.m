//
//  APIHelper+User.m
//  Base
//
//  Created by admin on 2017/1/17.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "APIHelper+User.h"

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
    [param safe_setValue:account forKey:@"account"];
    [param safe_setValue:pw forKey:@"password"];
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
                   sex:(NSString *)sex
              birthday:(NSString *)birthday
                  area:(NSString *)areaID
              complete:(ApiRequestCompleteBlock)complete{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param safe_setValue:nickname forKey:@"nickname"];
    [param safe_setValue:face forKey:@"face"];
    [param safe_setValue:sex forKey:@"sex"];
    [param safe_setValue:birthday forKey:@"birthday"];
    [param safe_setValue:areaID forKey:@"area_id"];
    
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
}


@end
