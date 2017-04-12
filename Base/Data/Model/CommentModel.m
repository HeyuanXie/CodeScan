//
//  CommentModel.m
//  Base
//
//  Created by admin on 2017/4/12.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "CommentModel.h"

@implementation CommentModel

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    return @{
             @"commentId":@"comment_id",
             @"userId":@"user_id",
             @"orderId":@"order_id",
             @"playId":@"play_id",
             @"score":@"score",
             @"createTime":@"create_time",
             @"updateTime":@"update_time",
             @"userName":@"user_name",
             @"headerImg":@"header_img",
             @"showImg":@"show_img"
             };
}



@end
