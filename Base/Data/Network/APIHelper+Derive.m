//
//  APIHelper+Derive.m
//  Base
//
//  Created by admin on 2017/3/29.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "APIHelper+Derive.h"

@implementation APIHelper (Derive)

-(void)deriveListStart:(NSInteger)start limit:(NSInteger)limit categoryId:(NSInteger)categoryId complete:(ApiRequestCompleteBlock)complete {
    
    NSMutableDictionary* param = [NSMutableDictionary dictionary];
    [param safe_setValue:@(start) forKey:@"start"];
    [param safe_setValue:@(limit) forKey:@"limit"];
    [param safe_setValue:@(categoryId) forKey:@"category_id"];
    [APIHELPER getWithURL:@"goods/lists" param:param complete:complete];
}

-(void)deriveDetail:(NSInteger)goodId complete:(ApiRequestCompleteBlock)complete {
    [APIHELPER getWithURL:@"goods/read" param:@{@"goods_id":@(goodId)} complete:complete];
}

-(void)deriveExchange:(NSInteger)goodId buyNum:(NSInteger)buyNum complete:(ApiRequestCompleteBlock)complete {
    
    NSMutableDictionary* param = [NSMutableDictionary dictionary];
    [param safe_setValue:@(goodId) forKey:@"goods_id"];
    [param safe_setValue:@(buyNum) forKey:@"buy_num"];
    [APIHELPER getWithURL:@"/goods/exchange" param:param complete:complete];
}


@end
