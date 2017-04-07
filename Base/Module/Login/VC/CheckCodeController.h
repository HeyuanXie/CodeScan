//
//  CheckCodeController.h
//  Base
//
//  Created by admin on 2017/4/7.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "BaseViewController.h"

typedef enum : NSUInteger {
    TypePassword,
    TypePhone,
} ContentType;

@interface CheckCodeController : BaseViewController

@property(nonatomic,assign)ContentType contentType;

@end
