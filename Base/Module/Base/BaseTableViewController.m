//
//  BaseTableViewController.m
//  Base
//
//  Created by admin on 17/1/16.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "BaseTableViewController.h"

@interface BaseTableViewController ()

@end

@implementation BaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)baseSetupTableView:(UITableViewStyle)style InSets:(UIEdgeInsets)edge {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:style];
    [self.view addSubview:self.tableView];
    [self.tableView autoPinEdgesToSuperviewEdgesWithInsets:edge];
    self.tableView.backgroundColor = [UIColor hySeparatorColor];
    self.tableView.backgroundView = nil;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
}

-(void)addHeaderRefresh:(void(^)())block {
    MJRefreshNormalHeader* header = [MJRefreshNormalHeader headerWithRefreshingBlock:block];
    header.lastUpdatedTimeLabel.hidden = YES;
    [header setTitle:@"继续下拉刷新" forState:MJRefreshStateIdle];
    [header setTitle:@"松手加载" forState:MJRefreshStatePulling];
    [header setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
    
    self.tableView.mj_header = header;
}

-(void)addFooterRefresh:(void(^)())block {
    if (self.tableView.mj_footer) {
        return;
    }
    MJRefreshAutoNormalFooter* footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:block];
    [footer setTitle:@"继续上拉加载" forState:MJRefreshStateIdle];
    [footer setTitle:@"松手加载" forState:MJRefreshStatePulling];
    [footer setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
    
    self.tableView.mj_footer = footer;
}

-(void)removeFooterRefresh {
    self.tableView.mj_footer = nil;
}

-(BOOL)hasFooterRefresh {
    return (self.tableView.mj_footer != nil);
}

-(void)endRefreshing {
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

#pragma mark - tableView dataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

@end
