
//
//  PointDetailController.m
//  Base
//
//  Created by admin on 2017/3/16.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "PointDetailController.h"
#import "UITableViewCell+HYCell.h"

@interface PointDetailController ()

@property(nonatomic,strong)NSMutableArray* dataArray;

@end

@implementation PointDetailController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self baseSetupTableView:UITableViewStylePlain InSets:UIEdgeInsetsZero];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
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
    static NSString* cellId = @"pointDetailCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
        [HYTool configTableViewCellDefault:cell];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        
        UILabel* numLbl = [HYTool getLabelWithFrame:CGRectMake(kScreen_Width-12-100, 0, 100, zoom(67)) text:@"+200" fontSize:18 textColor:RGB(242, 179, 87, 1.0) textAlignment:NSTextAlignmentRight];
        numLbl.tag = 1000;
        [cell.contentView addSubview:numLbl];
    }
    [self configPointDetailCell:cell model:nil];
    return cell;
}

#pragma mark - tableView delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return zoom(67);
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
    self.dataArray = [@[@"",@"",@""] mutableCopy];
    [self.tableView reloadData];
}

-(void)configPointDetailCell:(UITableViewCell*)cell model:(id)model {
    if ([self.tableView indexPathForCell:cell].row == self.dataArray.count-1) {
        UILabel* numLbl = [cell.contentView viewWithTag:1000];
        numLbl.textColor = [UIColor colorWithString:@"2cbb80"];
        numLbl.text = @"-1000";
        
    }
    cell.textLabel.text = @"选座购票";
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.textColor = [UIColor hyBlackTextColor];
    
    cell.detailTextLabel.text = @"2017-03-02 9:40";
    cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
    cell.detailTextLabel.textColor = [UIColor hyGrayTextColor];
}

@end
