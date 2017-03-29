//
//  APIHelper+Article.h
//  Base
//
//  Created by admin on 2017/3/29.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "APIHelper.h"

@interface APIHelper (Article)

-(void)weekEndArticleAreaId:(NSInteger)areaId cateId:(NSInteger)cateId start:(NSInteger)start limit:(NSInteger)limit complete:(ApiRequestCompleteBlock)complete;

-(void)informationArticleStart:(NSInteger)start limit:(NSInteger)limit complete:(ApiRequestCompleteBlock)complete;

@end
