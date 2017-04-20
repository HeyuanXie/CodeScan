//
//  APIHelper+Article.h
//  Base
//
//  Created by admin on 2017/3/29.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "APIHelper.h"

@interface APIHelper (Article)

//小飞象资讯
-(void)informationArticleStart:(NSInteger)start
                         limit:(NSInteger)limit
                      complete:(ApiRequestCompleteBlock)complete;

-(void)informationComment:(NSInteger)seekId
                  content:(NSString*)content
               becommenId:(NSInteger)becommentId
                 complete:(ApiRequestCompleteBlock)complete;


//周末去哪儿
-(void)weekEndArticleAreaId:(NSInteger)areaId cateId:(NSInteger)cateId start:(NSInteger)start limit:(NSInteger)limit complete:(ApiRequestCompleteBlock)complete;

-(void)weekEndComment:(NSInteger)articleId
              content:(NSString*)content
           becommenId:(NSInteger)becommentId
             complete:(ApiRequestCompleteBlock)complete;

@end
