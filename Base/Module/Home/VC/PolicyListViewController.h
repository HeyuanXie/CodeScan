//
//  PolicyListViewController.h
//  Base
//
//  Created by admin on 2017/2/6.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "BaseTableViewController.h"

typedef NS_ENUM(NSInteger,TYPE) {
    TYPEPolicy = 0,
    TYPEGuide,
    TYPEDemand
};

@interface PolicyListViewController : BaseTableViewController

@property(nonatomic,assign)TYPE type;

@end
