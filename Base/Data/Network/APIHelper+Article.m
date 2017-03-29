//
//  APIHelper+Article.m
//  Base
//
//  Created by admin on 2017/3/29.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "APIHelper+Article.h"

@implementation APIHelper (Article)

-(void)weekEndArticleAreaId:(NSInteger)areaId cateId:(NSInteger)cateId start:(NSInteger)start limit:(NSInteger)limit complete:(ApiRequestCompleteBlock)complete {
    
    NSMutableDictionary* param = [NSMutableDictionary dictionary];
    [param safe_setValue:@(areaId) forKey:@"area_id"];
    [param safe_setValue:@(cateId) forKey:@"cate_id"];
    [param safe_setValue:@(start) forKey:@"start"];
    [param safe_setValue:@(limit) forKey:@"limit"];
    
    [APIHELPER getWithURL:@"article/getArticleList" param:param complete:complete];
}

-(void)informationArticleStart:(NSInteger)start limit:(NSInteger)limit complete:(ApiRequestCompleteBlock)complete {
    
    NSMutableDictionary* param = [NSMutableDictionary dictionary];
    [param safe_setValue:@(start) forKey:@"start"];
    [param safe_setValue:@(limit) forKey:@"limit"];
    
    [APIHELPER getWithURL:@"seek/getSeek" param:param complete:complete];
}

@end
