//
//  APIHelper+Policy.m
//  Base
//
//  Created by admin on 2017/1/21.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "APIHelper+Policy.h"

@implementation APIHelper (Policy)

-(void)fetchNewsListWithCateId:(NSInteger)cateId word:(NSString*)word start:(NSInteger)start limit:(NSInteger)limit completeBlock:(ApiRequestCompleteBlock)complete {
    NSMutableDictionary* mDic = [NSMutableDictionary dictionary];
    [mDic safe_setValue:@(cateId) forKey:@"cate_id"];
    [mDic safe_setValue:word forKey:@"word"];
    [mDic safe_setValue:@(start) forKey:@"start"];
    [mDic safe_setValue:@(limit) forKey:@"limit"];
    [APIHELPER getWithURL:@"/api/article/news" param:mDic complete:complete];
}

-(void)fetchPolicyCateWithCompleteBlock:(ApiRequestCompleteBlock)complete {
    [APIHELPER getWithURL:@"/api/article/policyCate" param:nil complete:complete];
}
-(void)fetchPolicyListWithCateId:(NSInteger)cateId start:(NSInteger)start limit:(NSInteger)limit completeBlock:(ApiRequestCompleteBlock)complete {
    NSMutableDictionary* mDic = [NSMutableDictionary dictionary];
    [mDic safe_setValue:@(cateId) forKey:@"cate_id"];
    [mDic safe_setValue:@(start) forKey:@"start"];
    [mDic safe_setValue:@(limit) forKey:@"limit"];
    [APIHELPER getWithURL:@"/api/article/policy" param:mDic complete:complete];
}

-(void)fetchDemandListWithStart:(NSInteger)start limit:(NSInteger)limit completeBlock:(ApiRequestCompleteBlock)complete {
    NSMutableDictionary* mDic = [NSMutableDictionary dictionary];
    [mDic safe_setValue:@(start) forKey:@"start"];
    [mDic safe_setValue:@(limit) forKey:@"limit"];
    [APIHELPER getWithURL:@"/api/job/index" param:mDic complete:complete];
}
@end
