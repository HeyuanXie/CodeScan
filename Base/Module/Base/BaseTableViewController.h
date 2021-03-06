//
//  BaseTableViewController.h
//  Base
//
//  Created by admin on 17/1/16.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseTableViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UITableView* tableView;
@property(nonatomic,assign) BOOL haveNext;

/**
是否有“已经到底了”底部视图
 */
@property(nonatomic,assign) BOOL haveTableFooter;   

-(void)baseSetupTableView:(UITableViewStyle)style InSets:(UIEdgeInsets)edge;

-(void)addHeaderRefresh:(void(^)())block;

-(void)addFooterRefresh:(void(^)())block;

-(void)removeFooterRefresh;

-(BOOL)hasFooterRefresh;

-(void)endRefreshing;

@end
