//
//  SelectCouponController.m
//  Base
//
//  Created by admin on 2017/3/27.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "SelectCouponController.h"
#import "SelectCouponCell.h"

@interface SelectCouponController ()

@end

@implementation SelectCouponController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.couponIndex = 1000;
    self.cardIndex = 1000;
    
    [self baseSetupTableView:UITableViewStylePlain InSets:UIEdgeInsetsMake(0, 0, 0, 0)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tableView registerNib:[UINib nibWithNibName:[SelectCouponCell identify] bundle:nil] forCellReuseIdentifier:[SelectCouponCell identify]];

    [self subviewStyle];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    [self.tableView reloadData];
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
    
    SelectCouponCell* cell = [tableView dequeueReusableCellWithIdentifier:[SelectCouponCell identify]];
    [HYTool configTableViewCellDefault:cell];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    
    if (self.contentType == TypeCoupon) {
        [cell configCouponCell:self.dataArray[indexPath.row]];
        cell.selectImgV.hidden = !(self.couponIndex == indexPath.row);
    }else{
        [cell configYearCardCell:self.dataArray[indexPath.row]];
        cell.selectImgV.hidden = !(self.cardIndex == indexPath.row);
    }
    
    return cell;
}

#pragma mark - tableView delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.selectFinish) {
        self.selectFinish(indexPath.row);
    }
}

#pragma mark - private methods
-(void)subviewStyle {
    UIView* headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 48)];
    headView.backgroundColor = [UIColor whiteColor];
    UILabel* lbl = [HYTool getLabelWithFrame:CGRectMake(12, 0, kScreen_Width-24, 48) text:self.contentType == TypeCoupon ? @"可用优惠券" : @"可用年卡" fontSize:15 textColor:[UIColor hyBlackTextColor] textAlignment:NSTextAlignmentLeft];
    [headView addSubview:lbl];
    [headView addSubview:[HYTool getLineWithFrame:CGRectMake(0, 47.5, kScreen_Width, 0.5) lineColor:[UIColor hySeparatorColor]]];
    self.tableView.tableHeaderView = headView;
}


@end
