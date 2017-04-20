//
//  APIHelper+Article.m
//  Base
//
//  Created by admin on 2017/3/29.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "APIHelper+Article.h"

@implementation APIHelper (Article)

//小飞象资讯
-(void)informationArticleStart:(NSInteger)start
                         limit:(NSInteger)limit
                      complete:(ApiRequestCompleteBlock)complete {
    
    NSMutableDictionary* param = [NSMutableDictionary dictionary];
    [param safe_setValue:@(start) forKey:@"start"];
    [param safe_setValue:@(limit) forKey:@"limit"];
    
    [APIHELPER getWithURL:@"seek/getSeek" param:param complete:complete];
}

-(void)informationComment:(NSInteger)seekId
                  content:(NSString*)content
               becommenId:(NSInteger)becommentId
                 complete:(ApiRequestCompleteBlock)complete {
    
    NSMutableDictionary* param = [NSMutableDictionary dictionary];
    [param safe_setValue:@(seekId) forKey:@"seek_id"];
    [param safe_setValue:content forKey:@"comment"];
    [param safe_setValue:@(becommentId) forKey:@"becomment_id"];
    
    [APIHELPER getWithURL:@"seek/seekCom" param:param complete:complete];
}



//周末去哪儿
-(void)weekEndArticleAreaId:(NSInteger)areaId cateId:(NSInteger)cateId start:(NSInteger)start limit:(NSInteger)limit complete:(ApiRequestCompleteBlock)complete {
    
    NSMutableDictionary* param = [NSMutableDictionary dictionary];
    [param safe_setValue:@(areaId) forKey:@"area_id"];
    [param safe_setValue:@(cateId) forKey:@"cate_id"];
    [param safe_setValue:@(start) forKey:@"start"];
    [param safe_setValue:@(limit) forKey:@"limit"];
    
    [APIHELPER getWithURL:@"article/getArticleList" param:param complete:complete];
}

-(void)weekEndComment:(NSInteger)articleId
              content:(NSString*)content
           becommenId:(NSInteger)becommentId
             complete:(ApiRequestCompleteBlock)complete {
    
    NSMutableDictionary* param = [NSMutableDictionary dictionary];
    [param safe_setValue:@(articleId) forKey:@"article_id"];
    [param safe_setValue:content forKey:@"comment"];
    [param safe_setValue:@(becommentId) forKey:@"becomment_id"];
    
    [APIHELPER getWithURL:@"article/articleCom" param:param complete:complete];
}
@end
