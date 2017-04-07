//
//  APIHelper+User.h
//  Base
//
//  Created by admin on 2017/1/17.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "APIHelper.h"

@interface APIHelper (User)

- (void)regist:(NSString *)account
      password:(NSString *)pw
          code:(NSString *)code
      complete:(ApiRequestCompleteBlock)complete;

- (void)login:(NSString *)account
     password:(NSString *)pw
     complete:(ApiRequestCompleteBlock)complete;

- (void)resetPW:(NSString *)phone
           code:(NSString *)code
       password:(NSString *)pw
       complete:(ApiRequestCompleteBlock)complete;

- (void)updateUserInfo:(NSString *)nickname
                  face:(NSString *)face
                   sex:(NSInteger)sex
              birthday:(NSString *)birthday
                  area:(NSString *)areaID
              complete:(ApiRequestCompleteBlock)complete;

- (void)modifyPW:(NSString *)old
             the:(NSString *)theNew
        complete:(ApiRequestCompleteBlock)complete;

- (void)fetchUserInfo:(ApiRequestCompleteBlock)complete;

- (void)fetchResetPWCode:(NSString *)phone
                complete:(ApiRequestCompleteBlock)complete;

- (void)fetchRegistCode:(NSString *)phone
               complete:(ApiRequestCompleteBlock)complete;

- (void)logout;

//收藏
- (void)collect:(NSInteger)collectionId
           type:(NSInteger)type
       complete:(ApiRequestCompleteBlock)complete;

- (void)cancelCollect:(NSInteger)collectionId
                 type:(NSInteger)type
             complete:(ApiRequestCompleteBlock)complete;

- (void)fetchCollectList:(NSInteger)start
                   limit:(NSInteger)limit
                    type:(NSInteger)type
                complete:(ApiRequestCompleteBlock)complete;

//积分
- (void)scoreManageComplete:(ApiRequestCompleteBlock)complete;

- (void)scoreInfoList:(NSInteger)start
                limit:(NSInteger)limit
             complete:(ApiRequestCompleteBlock)complte;

- (void)scoreSignComplete:(ApiRequestCompleteBlock)complete;

//年卡
- (void)mineYearCardList:(NSInteger)start limit:(NSInteger)limit complete:(ApiRequestCompleteBlock)complete;

@end
