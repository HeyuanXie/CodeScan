//
//  WeekEndDetailController.h
//  Base
//
//  Created by admin on 2017/3/21.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "WebViewController.h"
#import "ArticleModel.h"

@interface WeekEndDetailController : WebViewController

//@property (nonatomic,assign)NSInteger type; //0：资讯，1：周末去哪儿
@property (nonatomic,strong)ArticleModel* data;

@end
