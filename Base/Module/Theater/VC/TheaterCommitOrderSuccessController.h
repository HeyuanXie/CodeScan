//
//  TheaterCommitOrderSuccessController.h
//  Base
//
//  Created by admin on 2017/3/28.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "BaseTableViewController.h"

typedef enum : NSUInteger {
    TypeTheater = 0,
    TypeDerive,
} ContentType;

@interface TheaterCommitOrderSuccessController : BaseTableViewController

@property(nonatomic,assign)ContentType contentType;

@end
