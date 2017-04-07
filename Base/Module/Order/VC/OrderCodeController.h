//
//  OrderCodeController.h
//  Base
//
//  Created by admin on 2017/3/10.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "BaseTableViewController.h"

typedef enum : NSUInteger {
    TypeTheater = 0,
    TypeDerive,
    TypeCard,
    TypeLecture
} ContentType;

@interface OrderCodeController : BaseTableViewController

@property (nonatomic,assign)ContentType contentType;
@property (nonatomic,strong)NSDictionary* data;
@property (nonatomic,strong)NSDictionary* code;

@end
