//
//  OrderFilterTableController.m
//  Base
//
//  Created by admin on 2017/3/20.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "OrderFilterTableController.h"

@interface OrderFilterTableController ()

@property(strong,nonatomic)NSArray* titles;

@end

@implementation OrderFilterTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    self.view.backgroundColor = [[UIColor hyBlackTextColor] colorWithAlphaComponent:0.4];
    self.tableView.scrollEnabled = NO;
    self.tableView.backgroundView = nil;
    self.tableView.tableFooterView = nil;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self.tableView reloadData];
}

-(NSArray *)titles {
    if (_titles == nil) {
        _titles = @[@"全部订单",@"演出",@"商品",@"年卡"];
    }
    return _titles;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titles.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* cellId = @"filterCell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        UILabel* lbl = [[UILabel alloc] initWithFrame:CGRectZero];
        lbl.tag = 101;
        lbl.textColor = [UIColor hyBlackTextColor];
        lbl.font = [UIFont systemFontOfSize:15];
        [cell.contentView addSubview:lbl];
        
        [lbl autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [lbl autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:17];
        [lbl autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10];
        [lbl autoSetDimension:ALDimensionHeight toSize:25];
    }
    
    UILabel* lbl = [cell.contentView viewWithTag:101];
    lbl.text = self.titles[indexPath.row];
    if (self.currentIndex == indexPath.row) {
        lbl.textColor = [UIColor hyBarTintColor];
    }else{
        lbl.textColor = [UIColor hyBlackTextColor];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 182/4;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.selectIndex) {
        self.selectIndex(indexPath.row);
    }
}

@end
