//
//  MineYearCardController.m
//  Base
//
//  Created by admin on 2017/3/16.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "MineYearCardController.h"
#import "MineYearCardCell.h"
#import "APIHelper+User.h"

@interface MineYearCardController ()

@property(nonatomic,strong)NSMutableArray* dataArray;

@end

@implementation MineYearCardController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self baseSetupTableView:UITableViewStylePlain InSets:UIEdgeInsetsZero];
    [self.tableView registerNib:[UINib nibWithNibName:[MineYearCardCell identify] bundle:nil] forCellReuseIdentifier:[MineYearCardCell identify]];
    
    [self headerViewInit];
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
    MineYearCardCell* cell = [tableView dequeueReusableCellWithIdentifier:[MineYearCardCell identify]];
    [HYTool configTableViewCellDefault:cell];
    //TODO:
    NSDictionary* model = self.dataArray[indexPath.row];
    [cell configYearCardCell:model];
    return cell;
}

#pragma mark - tableView delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return zoom(134);
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    APPROUTE(([NSString stringWithFormat:@"%@?Id=%@",kYearCardDetailController,@"1"]));
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
    [APIHELPER mineYearCardList:self.dataArray.count limit:6 complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
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
    }];
}

-(void)headerViewInit {
    @weakify(self);
    [self addHeaderRefresh:^{
        @strongify(self);
        [self showLoadingAnimation];
        [self.dataArray removeAllObjects];
        [APIHELPER mineYearCardList:self.dataArray.count limit:6 complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
            [self hideLoadingAnimation];
            
            [self.dataArray removeAllObjects];
            [self.tableView reloadData];
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

-(void)appendFooterView {
    @weakify(self);
    [self addFooterRefresh:^{
        @strongify(self);
        [self showLoadingAnimation];
        [APIHELPER mineYearCardList:self.dataArray.count limit:6 complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
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

@end
