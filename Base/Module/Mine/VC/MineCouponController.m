//
//  MineCouponController.m
//  Base
//
//  Created by admin on 2017/3/16.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "MineCouponController.h"
#import "MineCouponCell.h"

@interface MineCouponController ()

@property(nonatomic,strong)NSMutableArray* dataArray;

@end

@implementation MineCouponController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self baseSetupTableView:UITableViewStylePlain InSets:UIEdgeInsetsMake(41*kScreen_Height/667, 0, 0, 0)];
    [self.tableView registerNib:[UINib nibWithNibName:[MineCouponCell identify] bundle:nil] forCellReuseIdentifier:[MineCouponCell identify]];
    [self fetchData];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - talbeView dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MineCouponCell* cell = [tableView dequeueReusableCellWithIdentifier:[MineCouponCell identify]];
    [HYTool configTableViewCellDefault:cell];
    
    [cell configCouponCell:nil];
    return cell;
}

#pragma mark - tableView delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 112;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //TODO:使用优惠券
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

#pragma mark - IBActions
- (IBAction)useRules:(id)sender {
    //TODO:使用规则
    
}


@end
