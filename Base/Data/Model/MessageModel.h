//
//  MessageModel.h
//  Base
//
//  Created by admin on 2017/4/17.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "BaseModel.h"

@interface MessageModel : BaseModel

@property(nonatomic,assign)NSInteger noticeId;
@property(nonatomic,assign)NSInteger noticeCode;
@property(nonatomic,assign)NSInteger orderId;
@property(nonatomic,assign)NSInteger userId;
@property(nonatomic,assign)NSInteger status;
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *content;
@property(nonatomic,strong)NSString *createTime;
@property(nonatomic,strong)NSString *updateTime;

@end
