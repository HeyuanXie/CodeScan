//
//  OrderFilterTableController.h
//  Base
//
//  Created by admin on 2017/3/20.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderFilterTableController : UITableViewController

@property (nonatomic, copy) void(^selectIndex)(NSInteger row);
@property (nonatomic, assign)NSInteger currentIndex;    //记录当前选择的idnex

@end
