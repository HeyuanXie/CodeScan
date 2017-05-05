//
//  TheaterSessionModel.h
//  Base
//
//  Created by admin on 2017/4/5.
//  Copyright © 2017年 XHY. All rights reserved.
//


//剧场场次model
#import "BaseModel.h"
#import "TheaterModel.h"

@interface TheaterSessionModel : BaseModel

@property (nonatomic, copy) NSString *theaterName;
@property (nonatomic, strong) NSNumber *theaterId;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, strong) NSNumber *timeId;
@property (nonatomic, strong) NSNumber *hallId;
@property (nonatomic, copy) NSString *playDate;
@property (nonatomic, copy) NSString *playTime;

@end
