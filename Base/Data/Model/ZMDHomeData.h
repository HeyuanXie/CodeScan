//
//  ZMDHomeData.h
//  Base
//
//  Created by admin on 2017/2/6.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "BaseModel.h"
#import "ZMDArticle.h"

@interface ZMDHomeData : BaseModel

@property(nonatomic,strong)NSMutableArray* slide;
@property(nonatomic,strong)NSMutableArray* policy;
@property(nonatomic,strong)NSMutableArray* news;

@end
