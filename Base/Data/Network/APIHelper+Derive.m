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

-(void)deriveComment:(NSInteger)goodId
             orderSn:(NSString *)orderSn
               score:(NSInteger)score
             comment:(NSString *)comment
              images:(NSArray *)imageUrls
            complete:(ApiRequestCompleteBlock)complete {
    
    NSMutableDictionary* param = [NSMutableDictionary dictionary];
    [param safe_setValue:@(goodId) forKey:@"goods_id"];
    [param safe_setValue:orderSn forKey:@"order_sn"];
    [param safe_setValue:@(score) forKey:@"comment_score"];
    [param safe_setValue:comment forKey:@"content"];
    [param safe_setValue:imageUrls forKey:@"show_img"];
    [APIHELPER postWithURL:@"goods_comment/comment" param:param complete:complete];
}

/**
 获取单个衍生品评论列表
 
 @param start <#start description#>
 @param limit <#limit description#>
 @param goodId <#playId description#>
 @param type 评论类型, 0:全部; 1:晒图
 @param complete <#complete description#>
 */
-(void)deriveCommentList:(NSInteger)start
                    limit:(NSInteger)limit
                   goodId:(NSInteger)goodId
                     type:(NSInteger)type
                 complete:(ApiRequestCompleteBlock)complete {
    
    NSMutableDictionary* param = [NSMutableDictionary dictionary];
    [param safe_setValue:@(goodId) forKey:@"goods_id"];
    [param safe_setValue:@(start) forKey:@"start"];
    [param safe_setValue:@(limit) forKey:@"limit"];
    [param safe_setValue:@(type) forKey:@"type"];
    [APIHELPER postWithURL:@"goods_comment/readlist" param:param complete:complete];
}
@end
