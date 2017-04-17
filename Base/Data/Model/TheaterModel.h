//
//  TheaterModel.h
//  Base
//
//  Created by admin on 2017/3/29.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "BaseModel.h"

@interface TheaterModel : BaseModel
@property (nonatomic, strong) NSNumber *playId;
@property (nonatomic, strong) NSNumber *classId;
@property (nonatomic, copy) NSString *playName;
@property (nonatomic, copy) NSString *subTitle;
@property (nonatomic, copy) NSString *pctime;
@property (nonatomic, strong) NSString *sydate;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *updateTime;
@property (nonatomic, strong) NSString *keywords;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, strong) NSNumber *num;
@property (nonatomic, strong) NSString* payableAmount;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *picurl;
@property (nonatomic, strong) NSNumber *status;
@property (nonatomic, copy) NSString *pricel;
@property (nonatomic, copy) NSString *priceh;
@property (nonatomic, strong) NSNumber *score;
@property (nonatomic, strong) NSNumber *hits;
@property (nonatomic, assign) NSInteger isFav;

@property (nonatomic, strong) NSNumber *timeId;
@property (nonatomic, strong) NSString *playTime;
@property (nonatomic, strong) NSString *playDate;
@property (nonatomic, strong) NSString *language;
@property (nonatomic, strong) NSNumber *hallId;
@property (nonatomic, strong) NSNumber *theaterId;
@property (nonatomic, strong) NSString *theaterName;
@property (nonatomic, strong) NSString *address;


@end
