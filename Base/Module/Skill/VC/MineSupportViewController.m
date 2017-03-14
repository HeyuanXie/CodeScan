//
//  MineSupportViewController.m
//  Base
//
//  Created by admin on 2017/3/14.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "MineSupportViewController.h"
#import "MineSupportCell.h"
#import "UITableViewCell+HYCell.h"

@interface MineSupportViewController ()

@property(nonatomic,strong)NSMutableArray* dataArray;

@end

@implementation MineSupportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self baseSetupTableView:UITableViewStylePlain InSets:UIEdgeInsetsMake(103, 0, 0, 0)];
    [self.tableView registerNib:[UINib nibWithNibName:[MineSupportCell identify] bundle:nil] forCellReuseIdentifier:[MineSupportCell identify]];
    
    [self fetchData];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - talbeView dataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MineSupportCell * cell = [tableView dequeueReusableCellWithIdentifier:[MineSupportCell identify]];
    //TODO:
    [cell addLine:(indexPath.row == self.dataArray.count-1) leftOffSet:12 rightOffSet:0];
    return cell;
}

#pragma mark - tableView delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 48;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
}

@end
