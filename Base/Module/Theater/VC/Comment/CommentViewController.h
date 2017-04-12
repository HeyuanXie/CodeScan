//
//  CommentViewController.h
//  Base
//
//  Created by admin on 2017/3/22.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "BaseTableViewController.h"

typedef NS_ENUM(NSInteger, CommentType) {
    CommentTypeTheater=0,
    CommentTypeLecture,
    CommentTypeDerive,
    CommentTypeSkill
};

@interface CommentViewController : BaseTableViewController

@property(strong,nonatomic)NSDictionary* data;
@property(assign,nonatomic)CommentType type;

@end
