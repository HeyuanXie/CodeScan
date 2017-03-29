//
//  ArticleModel.m
//  Base
//
//  Created by admin on 2017/3/29.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "ArticleModel.h"

@implementation ArticleModel

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    return @{
             @"articleId":@"article_id",
             @"seekId":@"seek_id",
             @"cateId":@"cate_id",
             @"sourceUrl":@"source_url",
             @"commentNum":@"comment_num",
             };
}

@end
