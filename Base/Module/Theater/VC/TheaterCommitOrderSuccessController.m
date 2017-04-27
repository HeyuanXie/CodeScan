//
//  TheaterCommitOrderSuccessController.m
//  Base
//
//  Created by admin on 2017/3/28.
//  Copyright © 2017年 XHY. All rights reserved.
//


//下单成功

#import "TheaterCommitOrderSuccessController.h"
typedef enum : NSUInteger {
    TypeTheater = 0,
    TypeDerive,
    TypeCard
} ContentType;

@interface TheaterCommitOrderSuccessController ()

@property(nonatomic,assign)ContentType contentType;
@property(nonatomic,strong)NSString* orderSn; //订单Id
@property(nonatomic,strong)NSString* payId;     //用于请求获得的积分
@property(nonatomic,strong)NSString* point; //获得的积分
@property(nonatomic,assign)NSInteger payType;   //支付方式 1:微信支付, 2:支付宝支付

@property(nonatomic,strong)UIView* tableHeadView;

@end

@implementation TheaterCommitOrderSuccessController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.schemaArgu[@"contentType"]) {
        self.contentType = [[self.schemaArgu objectForKey:@"contentType"] integerValue];
    }
    if (self.schemaArgu[@"order_sn"]) {
        self.orderSn = [self.schemaArgu objectForKey:@"order_sn"];
    }
    if (self.schemaArgu[@"payId"]) {
        self.payId = [self.schemaArgu objectForKey:@"payId"];
    }
    if (self.schemaArgu[@"payType"]) {
        self.payType = [[self.schemaArgu objectForKey:@"payType"] integerValue];
    }
    [self baseSetupTableView:UITableViewStylePlain InSets:UIEdgeInsetsZero];
    
    [self subviewStyle];
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
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString* cellId = @"botCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        [HYTool configTableViewCellDefault:cell];
        
        UIButton* btn = [HYTool getButtonWithFrame:CGRectMake(0, 1, zoom(108), 30) title:@"查看订单详情" titleSize:15 titleColor:RGB(63,165,243,1.0) backgroundColor:nil blockForClick:^(id sender) {
            
            if (self.contentType == TypeCard) {
                APPROUTE(([NSString stringWithFormat:@"%@?orderId=%@",kYearCardOrderController,self.orderSn]));
            }else{
                APPROUTE(([NSString stringWithFormat:@"%@?contentType=%ld&orderId=%@",kOrderDetailController,self.contentType,self.orderSn]));
            }
        }];
        btn.center = CGPointMake(kScreen_Width/2, 16);
        [HYTool configViewLayer:btn withColor:RGB(63,165,243,1.0)];
        [cell.contentView addSubview:btn];
    }
    return cell;
}

#pragma mark - tableView delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 32;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - private methods

-(void)subviewStyle {
    
    NSInteger index = 100;
    switch (self.contentType) {
        case TypeTheater:
            index = 4;
            self.title = @"下单成功";
            break;
        case TypeDerive:
            index = 5;
            self.title = @"兑换成功";
            break;
            
        case TypeCard:
            index = 4;
            self.title = @"下单成功";
            break;
        default:
            break;
    }
    self.tableHeadView = LOADNIB(@"TheaterUseView", index);
    self.tableView.tableHeaderView = self.tableHeadView;
}

-(void)fetchData {
    if (self.contentType == TypeDerive) {
        return;
    }
    [APIHELPER getPointWithPayId:self.payId payType:self.payType complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
        if (isSuccess) {
            self.point = responseObject[@"data"][@"score"];
            if ([self.tableHeadView viewWithTag:1000]) {
                UILabel* pointLbl = [self.tableHeadView viewWithTag:1000];
                pointLbl.text = [NSString stringWithFormat:@"获得积分: %@",self.point];
            }
        }else{
            [self showMessage:error.userInfo[NSLocalizedDescriptionKey]];
        }
    }];
}

-(void)backAction {
    NSInteger count = self.navigationController.viewControllers.count;
    UIViewController *vc = self.navigationController.viewControllers[count-3];
    [self.navigationController popToViewController:vc animated:YES];
}

@end
