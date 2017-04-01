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
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *picurl;
@property (nonatomic, strong) NSNumber *status;
@property (nonatomic, copy) NSString *pricel;
@property (nonatomic, copy) NSString *priceh;
@property (nonatomic, strong) NSNumber *score;
@property (nonatomic, strong) NSNumber *hits;
@property (nonatomic, assign) BOOL isFav;



@end
