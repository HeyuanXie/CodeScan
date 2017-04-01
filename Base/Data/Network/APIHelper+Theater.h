//
//  APIHelper+Theater.h
//  Base
//
//  Created by admin on 2017/3/29.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "APIHelper.h"

@interface APIHelper (Theater)

-(void)theaterHotCitysComplete:(ApiRequestCompleteBlock)complete;

-(void)theaterListStart:(NSInteger)start
                  limit:(NSInteger)limit
                classId:(NSInteger)classId
                orderBy:(NSString*)orderBy
              orderType:(NSString*)orderType
                   city:(NSString*)city
               complete:(ApiRequestCompleteBlock)complete;

-(void)theaterDetail:(NSInteger)playId complete:(ApiRequestCompleteBlock)complete;


@end
