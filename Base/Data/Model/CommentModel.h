//
//  CommentModel.h
//  Base
//
//  Created by admin on 2017/4/12.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "BaseModel.h"


/**
 单个剧场（衍生品）评论列表model
 */
@interface CommentModel : BaseModel

@property (nonatomic, strong) NSNumber *commentId;
@property (nonatomic, strong) NSNumber *userId;
@property (nonatomic, strong) NSNumber *orderId;
@property (nonatomic, strong) NSNumber *playId;
@property (nonatomic, strong) NSNumber *score;
@property (nonatomic, strong) NSNumber *commentScore;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, strong) NSNumber *updateTime;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *headerImg;
@property (nonatomic, strong) NSArray *showImg;

@end
