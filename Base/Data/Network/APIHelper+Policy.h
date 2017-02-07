//
//  APIHelper+Policy.h
//  Base
//
//  Created by admin on 2017/1/21.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "APIHelper.h"

@interface APIHelper (Policy)

-(void)fetchNewsListWithCateId:(NSInteger)cateId word:(NSString*)word start:(NSInteger)start limit:(NSInteger)limit completeBlock:(ApiRequestCompleteBlock)complete;

-(void)fetchPolicyCateWithCompleteBlock:(ApiRequestCompleteBlock)complete;
-(void)fetchPolicyListWithCateId:(NSInteger)cateId start:(NSInteger)start limit:(NSInteger)limit completeBlock:(ApiRequestCompleteBlock)complete;

-(void)fetchDemandListWithStart:(NSInteger)start limit:(NSInteger)limit completeBlock:(ApiRequestCompleteBlock)complete;

@end
