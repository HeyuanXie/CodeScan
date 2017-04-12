
//
//  PointDetailController.m
//  Base
//
//  Created by admin on 2017/3/16.
//  Copyright © 2017年 XHY. All rights reserved.
//

//积分明细
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
    [self headerViewInit];
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
    NSDictionary* model = self.dataArray[indexPath.row];
    [self configPointDetailCell:cell model:model];
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

- (void)fetchData {
    self.tableView.tableFooterView = nil;
    [self showLoadingAnimation];
    [APIHELPER scoreInfoList:0 limit:10 complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
        [self hideLoadingAnimation];
        
        if (isSuccess) {
            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray:responseObject[@"data"][@"list"]];
            [self.tableView reloadData];
            
            self.haveNext = [responseObject[@"data"][@"have_next"] boolValue];
            if (self.haveNext) {
                [self appendFooterView];
            }else{
                [self removeFooterRefresh];
            }
        }else{
            [self showMessage:error.userInfo[NSLocalizedDescriptionKey]];
        }
    }];
}

-(void)headerViewInit {
    @weakify(self);
    [self addHeaderRefresh:^{
        @strongify(self);
        [self showLoadingAnimation];
        [APIHELPER scoreInfoList:0 limit:10 complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
            [self hideLoadingAnimation];
            
            if (isSuccess) {
                [self.dataArray removeAllObjects];
                [self.dataArray addObjectsFromArray:responseObject[@"data"][@"list"]];
                [self.tableView reloadData];
                
                self.haveNext = [responseObject[@"data"][@"have_next"] boolValue];
                if (self.haveNext) {
                    [self appendFooterView];
                }else{
                    [self removeFooterRefresh];
                }
            }else{
                [self showMessage:error.userInfo[NSLocalizedDescriptionKey]];
            }
            [self endRefreshing];
        }];
    }];
}

-(void)appendFooterView {
    @weakify(self);
    [self addFooterRefresh:^{
        @strongify(self);
        [self showLoadingAnimation];
        [APIHELPER scoreInfoList:self.dataArray.count limit:10 complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
            [self hideLoadingAnimation];
            
            if (isSuccess) {
                [self.dataArray addObjectsFromArray:responseObject[@"data"][@"list"]];
                [self.tableView reloadData];
                
                self.haveNext = [responseObject[@"data"][@"have_next"] boolValue];
                if (self.haveNext) {
                    [self appendFooterView];
                }else{
                    [self removeFooterRefresh];
                }
            }else{
                [self showMessage:error.userInfo[NSLocalizedDescriptionKey]];
            }
            [self endRefreshing];
        }];
    }];
}

-(void)configPointDetailCell:(UITableViewCell*)cell model:(id)model {
    UILabel* numLbl = [cell.contentView viewWithTag:1000];
    
    NSInteger point = [model[@"change_points"] integerValue];
    numLbl.textColor = point > 0 ? RGB(242, 179, 87, 1.0) : [UIColor colorWithString:@"2cbb80"];
    NSString* text = point > 0 ? [NSString stringWithFormat:@"+%ld",point] : [NSString stringWithFormat:@"%ld",point];
    numLbl.text = text;

    cell.textLabel.text = model[@"change_des"];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.textColor = [UIColor hyBlackTextColor];
    
    cell.detailTextLabel.text = [HYTool dateStringWithString:model[@"create_time"] inputFormat:nil outputFormat:@"yyyy-MM-dd HH:mm"];
    cell.detailTextLabel.textColor = RGB(161, 161, 161, 1.0);
}

@end
