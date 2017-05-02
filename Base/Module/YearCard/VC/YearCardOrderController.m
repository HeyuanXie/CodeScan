//
//  YearCardOrderController.m
//  Base
//
//  Created by admin on 2017/3/21.
//  Copyright © 2017年 XHY. All rights reserved.
//

//年卡的订单详情

#import "YearCardOrderController.h"
#import "OrderTopCell.h"
#import "OrderRefundCell.h"
#import "YearCardOrderCommonCell.h"
#import "OrderDetailCell.h"
#import "YearCardDescCell.h"
#import "HYPayEngine.h"
#import "HYAlertView.h"

@interface YearCardOrderController ()

@property(nonatomic,strong)NSArray* infos;
@property(nonatomic,assign)BOOL canSee;

@property(nonatomic,strong)NSString* orderId;
@property(nonatomic,assign)NSInteger orderStatu;    //2、3、4、5
@property(nonatomic,strong)NSDictionary* data;

@end

@implementation YearCardOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.schemaArgu[@"orderId"]) {
        self.orderId = [self.schemaArgu objectForKey:@"orderId"];
    }
    
    [self baseSetupTableView:UITableViewStylePlain InSets:UIEdgeInsetsMake(0, 0, 0, 0)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tableView registerNib:[UINib nibWithNibName:[OrderTopCell identify] bundle:nil] forCellReuseIdentifier:[OrderTopCell identify]];
    [self.tableView registerNib:[UINib nibWithNibName:[OrderRefundCell identify] bundle:nil] forCellReuseIdentifier:[OrderRefundCell identify]];
    [self.tableView registerNib:[UINib nibWithNibName:[YearCardOrderCommonCell identify] bundle:nil] forCellReuseIdentifier:[YearCardOrderCommonCell identify]];
    [self.tableView registerNib:[UINib nibWithNibName:[OrderDetailCell identify] bundle:nil] forCellReuseIdentifier:[OrderDetailCell identify]];
    [self.tableView registerNib:[UINib nibWithNibName:[YearCardDescCell identify] bundle:nil] forCellReuseIdentifier:[YearCardDescCell identify]];

    [self subviewStyle];
    [self fetchData];
    [self registNotification];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions
- (IBAction)payNow:(id)sender {
    //年卡继续支付
    [APIHELPER requestCardContinuePayInfoWithOrderId:self.orderId complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
        if (isSuccess) {
            NSInteger payType = [responseObject[@"data"][@"pay_type"] integerValue];
            if (payType==1) {//支付宝
                [HYPayEngine alipayWithOrderStr:responseObject[@"data"][@"pay_data"] withFinishBlock:^(BOOL success, NSString *payMessage) {
                    //这里的支付结果回调只有网页支付会掉，支付宝app支付会在appDelegate中回调
                    if (!success) {
                        [self showMessage:payMessage];
                    }else{
                        HYAlertView* alert = [HYAlertView sharedInstance];
                        [alert showAlertView:nil message:@"支付成功" subBottonTitle:@"确定" handler:^(AlertViewClickBottonType bottonType) {
                            [[NSNotificationCenter defaultCenter] postNotificationName:kPaySuccessNotification object:nil];
                        }];
                    }
                }];
            }else if (payType==2){//微信
                [HYPayEngine wxpayWithPayInfo:responseObject[@"data"][@"pay_data"] WithFinishBlock:^(BOOL success, NSInteger code, NSString *payMessage) {
                    if (!success) {
                        [self showMessage:payMessage];
                    }else{
                        HYAlertView* alert = [HYAlertView sharedInstance];
                        [alert showAlertView:nil message:@"支付成功" subBottonTitle:@"确定" handler:^(AlertViewClickBottonType bottonType) {
                            [[NSNotificationCenter defaultCenter] postNotificationName:kPaySuccessNotification object:nil];
                        }];
                    }
                }];
            }
        }else{
            [self showMessage:error.userInfo[NSLocalizedDescriptionKey]];
        }
    }];
}

#pragma mark - talbeView dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.orderStatu == 2 ? 3 : 4;    //代付款没有卡号、密码
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.orderStatu == 2) {
        return 2;
    }
    return section == 1 ? 4 : 2;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.orderStatu == 2) {
        //待付款、已退款(只有3个section)
        switch (indexPath.section) {
            case 0:
                if (indexPath.row == 0) {
                    OrderTopCell* cell = [tableView dequeueReusableCellWithIdentifier:[OrderTopCell identify]];
                    [cell configTopCell:self.data];
                    return cell;
                }else{
                    OrderRefundCell* cell = [tableView dequeueReusableCellWithIdentifier:[OrderRefundCell identify]];
                    return cell;
                }
                break;
            case 1:
                if (indexPath.row == 0) {
                    
                    static NSString* cellId = @"detailHeadCell";
                    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
                    if (cell == nil) {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
                        [HYTool configTableViewCellDefault:cell];
                        cell.contentView.backgroundColor = [UIColor whiteColor];
                        
                        UILabel* label = [HYTool getLabelWithFrame:CGRectMake(10, 0, kScreen_Width-20, 48) text:@"" fontSize:15 textColor:[UIColor hyBlackTextColor] textAlignment:NSTextAlignmentLeft];
                        label.tag = 1000;
                        [cell.contentView addSubview:label];
                    }
                    UILabel* label = [cell.contentView viewWithTag:1000];
                    label.text = @"年卡说明";
                    return cell;
                }else{
                    YearCardDescCell* cell = [tableView dequeueReusableCellWithIdentifier:[YearCardDescCell identify]];
                    return cell;
                }
                break;
            case 2:
                if (indexPath.row == 0) {
                    
                    static NSString* cellId = @"detailHeadCell";
                    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
                    if (cell == nil) {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
                        [HYTool configTableViewCellDefault:cell];
                        cell.contentView.backgroundColor = [UIColor whiteColor];
                        
                        UILabel* label = [HYTool getLabelWithFrame:CGRectMake(10, 0, kScreen_Width-20, 48) text:@"" fontSize:15 textColor:[UIColor hyBlackTextColor] textAlignment:NSTextAlignmentLeft];
                        label.tag = 1000;
                        [cell.contentView addSubview:label];
                    }
                    UILabel* label = [cell.contentView viewWithTag:1000];
                    label.text = @"订单详情";
                    return cell;
                }else{
                    
                    OrderDetailCell* cell = [tableView dequeueReusableCellWithIdentifier:[OrderDetailCell identify]];
                    [HYTool configTableViewCellDefault:cell];
                    cell.contentView.backgroundColor = [UIColor whiteColor];
                    [cell configDetailCell:self.data type:2];
                    return cell;
                }
                break;
            default:
                break;
        }
    }else{
        //已付款、已使用(有4个section)
        switch (indexPath.section) {
            case 0:
                if (indexPath.row == 0) {
                    OrderTopCell* cell = [tableView dequeueReusableCellWithIdentifier:[OrderTopCell identify]];
                    [cell configTopCell:self.data];
                    return cell;
                }else{
                    OrderRefundCell* cell = [tableView dequeueReusableCellWithIdentifier:[OrderRefundCell identify]];
                    return cell;
                }
            case 1:
                if (indexPath.row == 0) {
                    static NSString* cellId = @"statuCell";
                    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
                    if (cell == nil) {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
                        [HYTool configTableViewCellDefault:cell];
                        cell.contentView.backgroundColor = [UIColor whiteColor];
                        
                        UIButton* btn = [HYTool getButtonWithFrame:CGRectMake(kScreen_Width-12-60, 9, 60, 30) title:@"退款" titleSize:15 titleColor:[UIColor hyBlueTextColor] backgroundColor:nil blockForClick:^(id sender) {
                            //退款
                            APPROUTE(([NSString stringWithFormat:@"%@?orderId=%ld&contentType=%d",kOrderRefundController,[self.data[@"order_id"] integerValue],1]));
                        }];
                        btn.tag = 1000;
                        [HYTool configViewLayer:btn withColor:[UIColor hyBlueTextColor]];
                        [cell.contentView addSubview:btn];
                        
                        UILabel* label = [HYTool getLabelWithFrame:CGRectMake(12, 0, 60, 48) text:@"待使用" fontSize:15 textColor:[UIColor hyRedColor] textAlignment:NSTextAlignmentLeft];
                        label.tag = 1001;
                        [cell.contentView addSubview:label];
                    }
                    UIButton* btn = [cell.contentView viewWithTag:1000];
                    UILabel* lbl = [cell.contentView viewWithTag:1001];
                    //根据订单状态设置是否隐藏btn，和lbl的文字
                    if (self.orderStatu == 1) { //从全部订单跳转过来的，另外判断
      
                    }else if (self.orderStatu == 2) {
                        lbl.text = @"待支付";
                        btn.hidden = YES;
                    }else if (self.orderStatu == 3) {
                        lbl.text = @"待使用";
                        btn.hidden = NO;
                    }else if (self.orderStatu == 4) {
                        lbl.text = @"已使用";
                        btn.hidden = YES;
                    }else{
                        lbl.text = @"已退款";
                        btn.hidden = YES;
                    }
                    return cell;
                }else if (indexPath.row == 1) {
                    YearCardOrderCommonCell* cell = [tableView dequeueReusableCellWithIdentifier:[YearCardOrderCommonCell identify]];
                    
                    [cell configYearCardOrderCommonCell:self.data];
                    return cell;
                }else if (indexPath.row == 2) {
                    YearCardOrderCommonCell* cell = [tableView dequeueReusableCellWithIdentifier:[YearCardOrderCommonCell identify]];
                    [cell configYearCardOrderCommonEyeCell:self.data];
                    cell.textField.secureTextEntry = !self.canSee;
                    NSString* imageName = self.canSee ? @"密码可见_灰" : @"密码不可见_灰";
                    [cell.eyeBtn setImage:ImageNamed(imageName) forState:(UIControlStateNormal)];
                    @weakify(self);
                    [cell setEyeClick:^{
                        @strongify(self);
                        self.canSee = !self.canSee;
                        [self.tableView reloadData];
                    }];
                    return cell;
                }else{
                    
                    static NSString* cellId = @"functionCell";
                    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
                    if (cell == nil) {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
                        [HYTool configTableViewCellDefault:cell];
                        cell.contentView.backgroundColor = [UIColor whiteColor];
                        
                        CGFloat width = (kScreen_Width-0.5)/2.0;
                        int i = 0;
                        for (NSString* title in @[@"转增",@"立即绑定"]) {
                            UIButton* btn = [HYTool getButtonWithFrame:CGRectMake(i*(width+0.5), 0, width, 48) title:title titleSize:15 titleColor:[UIColor hyBlueTextColor] backgroundColor:nil blockForClick:^(id sender) {
                                if (self.orderStatu == 4) {
                                    [self showMessage:@"此卡已使用,无法转增或再次绑定!"];
                                    return ;
                                }
                                if (i == 0) {
                                    //转增
                                    DLog(@"转增");
                                }else{
                                    APPROUTE(([NSString stringWithFormat:@"%@?cardNum=%@&cardPassword=%@",kYearCardBindController,self.data[@"card_sn"],self.data[@"card_password"]]));
                                }
                            }];
                            [cell.contentView addSubview:btn];
                            btn.tag = 1000 + i;
                            i++;
                        }
                    }
                    
                    UIView* line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0.5, 48)];
                    line.backgroundColor = [UIColor hySeparatorColor];
                    line.center = CGPointMake(kScreen_Width/2, 24);
                    [cell.contentView addSubview:line];
                    return cell;
                }
            case 2:
                if (indexPath.row == 0) {
                    
                    static NSString* cellId = @"detailHeadCell";
                    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
                    if (cell == nil) {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
                        [HYTool configTableViewCellDefault:cell];
                        cell.contentView.backgroundColor = [UIColor whiteColor];
                        
                        UILabel* label = [HYTool getLabelWithFrame:CGRectMake(10, 0, kScreen_Width-20, 48) text:@"" fontSize:15 textColor:[UIColor hyBlackTextColor] textAlignment:NSTextAlignmentLeft];
                        label.tag = 1000;
                        [cell.contentView addSubview:label];
                    }
                    UILabel* label = [cell.contentView viewWithTag:1000];
                    label.text = @"年卡说明";
                    return cell;
                }else{
                    YearCardDescCell* cell = [tableView dequeueReusableCellWithIdentifier:[YearCardDescCell identify]];
                    return cell;
                }
            default:
                if (indexPath.row == 0) {
                    
                    static NSString* cellId = @"detailHeadCell";
                    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
                    if (cell == nil) {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
                        [HYTool configTableViewCellDefault:cell];
                        cell.contentView.backgroundColor = [UIColor whiteColor];
                        
                        UILabel* label = [HYTool getLabelWithFrame:CGRectMake(10, 0, kScreen_Width-20, 48) text:@"" fontSize:15 textColor:[UIColor hyBlackTextColor] textAlignment:NSTextAlignmentLeft];
                        label.tag = 1000;
                        [cell.contentView addSubview:label];
                    }
                    UILabel* label = [cell.contentView viewWithTag:1000];
                    label.text = @"订单详情";
                    return cell;
                }else{
                    
                    OrderDetailCell* cell = [tableView dequeueReusableCellWithIdentifier:[OrderDetailCell identify]];
                    [HYTool configTableViewCellDefault:cell];
                    cell.contentView.backgroundColor = [UIColor whiteColor];
                    [cell configDetailCell:self.data type:2];
                    return cell;
                }
        }
    }
    return [UITableViewCell new];
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView* footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, zoom(15))];
    footerView.backgroundColor = [UIColor hyViewBackgroundColor];
    return footerView;
}

#pragma mark - tableView delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray* height1 = @[@[@(128),@(40)],@[@(48),@(48),@(48),@(50)],@[@(48),@(124)],@[@(48),@(142)]];
    NSArray* height2 = @[@[@(128),@(40)],@[@(48),@(124)],@[@(48),@(142)]];

    if (self.orderStatu == 2) {
        return [height2[indexPath.section][indexPath.row] floatValue];
    }
    return [height1[indexPath.section][indexPath.row] floatValue];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return zoom(15);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark - private methods
-(void)fetchData {
    
    [APIHELPER orderDetailCard:self.orderId complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
        if (isSuccess) {
            self.data = responseObject[@"data"];
            [self judgeOrderStatu];
            [self.tableView reloadData];
        }else{
            [self showMessage:error.userInfo[NSLocalizedDescriptionKey]];
        }
    }];
}

-(void)judgeOrderStatu {
    
    NSInteger payStatu = [self.data[@"pay_status"] integerValue];
    NSInteger isBind = [self.data[@"is_bind"] integerValue];
    if (payStatu == 0) {
        self.orderStatu = 2;
        return;
    }
    if (payStatu == 3) {
        self.orderStatu = 5;
        return;
    }
    if (payStatu == 1) {
        if (isBind == 0) {
            self.orderStatu = 3;
            return;
        }
        if (isBind == 1) {
            self.orderStatu = 4;
            return;
        }
    }
}


-(void)subviewStyle {
    if (self.orderStatu == 2) {
        [self.tableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(30, 0, 60, 0)];
    }else{
        [self.tableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    }
}

//MARK:- 支付成功收到回调
- (void)registNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySuccess) name:kPaySuccessNotification object:nil];
}
- (void)paySuccess {
    APPROUTE(([NSString stringWithFormat:@"%@?contentType=%d&order_sn=%@",kTheaterCommitOrderSuccessController,2,self.orderId]));
}

@end
