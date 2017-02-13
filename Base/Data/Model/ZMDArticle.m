//
//  ZMDArticle.m
//  Base
//
//  Created by admin on 2017/1/21.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "ZMDArticle.h"

@implementation ZMDArticle
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    
    return @{@"articleId":@"article_id",@"publishDate":@"publish_date",@"detailUrl":@"detail_url",@"canShare":@"can_share"};
}

@end
