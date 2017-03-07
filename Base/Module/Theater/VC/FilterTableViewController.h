//
//  FilterTableViewController.h
//  Base
//
//  Created by admin on 2017/3/7.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterTableViewController : UITableViewController

@property(nonatomic,copy)void (^selectIndex)(NSInteger index);
@property(nonatomic,assign)NSInteger currentIndex;

@end
