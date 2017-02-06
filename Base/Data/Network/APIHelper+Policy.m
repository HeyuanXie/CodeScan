//
//  APIHelper+Policy.m
//  Base
//
//  Created by admin on 2017/1/21.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "APIHelper+Policy.h"

@implementation APIHelper (Policy)

-(void)fetchPolicyListWithCateId:(NSInteger)cateId word:(NSString*)word start:(NSInteger)start limit:(NSInteger)limit completeBlock:(ApiRequestCompleteBlock)complete {
    NSMutableDictionary* mDic = [NSMutableDictionary dictionary];
    [mDic safe_setValue:@(cateId) forKey:@"cate_id"];
    [mDic safe_setValue:word forKey:@"word"];
    [mDic safe_setValue:@(start) forKey:@"start"];
    [mDic safe_setValue:@(limit) forKey:@"limit"];
    [APIHELPER getWithURL:@"/api/article/news" param:mDic complete:complete];
}
@end
