//
//  OrderRefundDetailController.m
//  Base
//
//  Created by admin on 2017/4/24.
//  Copyright © 2017年 XHY. All rights reserved.
//

//已退款状态订单详情

#import "OrderRefundDetailController.h"
#import "RefundDetailCell.h"
#import "UITableViewCell+HYCell.h"

@interface OrderRefundDetailController ()

@property(nonatomic, strong)NSString* orderId;
@property(nonatomic, assign)NSInteger contentType;
@property(nonatomic, strong)NSDictionary* data;

@end

@implementation OrderRefundDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.schemaArgu[@"orderId"]) {
        self.orderId = [self.schemaArgu objectForKey:@"orderId"];
    }
    if (self.schemaArgu[@"contentType"]) {
        self.contentType = [[self.schemaArgu objectForKey:@"contentType"] integerValue];
    }
    [self baseSetupTableView:UITableViewStylePlain InSets:UIEdgeInsetsZero];
    [self.tableView registerNib:[UINib nibWithNibName:[RefundDetailCell identify] bundle:nil] forCellReuseIdentifier:[RefundDetailCell identify]];

    [self fetchData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - tableView dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.data == nil ? 0 : 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? 1 : 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        RefundDetailCell* cell = [tableView dequeueReusableCellWithIdentifier:[RefundDetailCell identify]];
        [HYTool configTableViewCellDefault:cell];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        [cell configRefundDetailCell:self.data];
        return cell;
    }
    
    static NSString* cellId = @"refundCommonCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    NSArray* titles = @[@"退款金额: ",@"退还账户: ",@"退款时间: "];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        [HYTool configTableViewCellDefault:cell];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textColor = [UIColor hyBlackTextColor];
    }
    NSString* text = @"";
    if (indexPath.row == 0) {
        text = [NSString stringWithFormat:@"%@元",self.data[@"refund_amount"]];
    }else if (indexPath.row == 1) {
        text = self.data[@"return_account"];
    }else {
        text = self.data[@"return_time"];
    }
    cell.textLabel.text = [titles[indexPath.row] stringByAppendingString:text];
    if (indexPath.row !=2) {
        [cell addLine:NO leftOffSet:12 rightOffSet:0];
    }
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 12)];
    view.backgroundColor = [UIColor hyViewBackgroundColor];
    return view;
}

#pragma mark - tableView delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 0 ? 180 : 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? 0 : 12;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


#pragma mark - private methods
-(void)fetchData {
    //获取退款状态订单详情
    if (self.contentType == TypeTheater) {
        [APIHELPER theaterRefundInfoWithOrderId:self.orderId.integerValue complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
            if (isSuccess) {
                self.data = responseObject[@"data"];
                [self.tableView reloadData];
            }else{
                [self showMessage:error.userInfo[NSLocalizedDescriptionKey]];
            }
        }];
    }else{
        [APIHELPER cardRefundInfoWithOrderId:self.orderId.integerValue complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
            if (isSuccess) {
                self.data = responseObject[@"data"];
                [self.tableView reloadData];
            }else{
                [self showMessage:error.userInfo[NSLocalizedDescriptionKey]];
            }
        }];
    }
}

@end
