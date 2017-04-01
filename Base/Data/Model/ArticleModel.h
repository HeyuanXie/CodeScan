//
//  ArticleModel.h
//  Base
//
//  Created by admin on 2017/3/29.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "BaseModel.h"

@interface ArticleModel : BaseModel

@property (nonatomic, copy) NSString *summary;
@property (nonatomic, copy) NSString *img;
@property (nonatomic, copy) NSString *addtime;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *sourceUrl;
@property (nonatomic, strong) NSNumber *commentNum;
@property (nonatomic, strong) NSNumber *articleId;
@property (nonatomic, strong) NSNumber *seekId;
@property (nonatomic, strong) NSNumber *cateId;
@property (nonatomic, strong) NSNumber *views;
@property (nonatomic, strong) NSNumber *light;
@property (nonatomic, strong) NSNumber *isFav;
@property (nonatomic, strong) NSNumber *articleType;

@end
