//
//  MineYearCardController.m
//  Base
//
//  Created by admin on 2017/3/16.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "MineYearCardController.h"
#import "MineYearCardCell.h"

@interface MineYearCardController ()

@property(nonatomic,strong)NSMutableArray* dataArray;

@end

@implementation MineYearCardController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self baseSetupTableView:UITableViewStylePlain InSets:UIEdgeInsetsZero];
    [self.tableView registerNib:[UINib nibWithNibName:[MineYearCardCell identify] bundle:nil] forCellReuseIdentifier:[MineYearCardCell identify]];
    
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
    [cell configYearCardCell:nil];
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

-(void)fetchData {
    self.dataArray = [@[@"",@""] mutableCopy];
}

@end
