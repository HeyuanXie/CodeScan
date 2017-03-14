//
//  VideoListViewController.m
//  Base
//
//  Created by admin on 2017/3/14.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "VideoListViewController.h"
#import "VideoListCell.h"
#import <UITableView+FDTemplateLayoutCell.h>

@interface VideoListViewController ()

@property(nonatomic,strong)NSMutableArray *dataArray;

@end

@implementation VideoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self baseSetupTableView:UITableViewStylePlain InSets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.tableView registerNib:[UINib nibWithNibName:[VideoListCell identify] bundle:nil] forCellReuseIdentifier:[VideoListCell identify]];

    [self fetchData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - talbeView dataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VideoListCell* cell = [tableView dequeueReusableCellWithIdentifier:[VideoListCell identify]];
    [HYTool configTableViewCellDefault:cell];
    
    [cell configListCell:nil];
    return cell;
}

#pragma mark - tableView delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView fd_heightForCellWithIdentifier:[VideoListCell identify] cacheByIndexPath:indexPath configuration:^(VideoListCell* cell) {
        
        [cell configListCell:nil];
    }];
}

#pragma mark - private methods
-(NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

-(void)fetchData {
    self.dataArray = [@[@"",@""] mutableCopy];
    [self.tableView reloadData];
}


@end
