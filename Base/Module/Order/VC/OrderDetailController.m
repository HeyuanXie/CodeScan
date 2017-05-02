//
//  OrderDetailController.m
//  Base
//
//  Created by admin on 2017/3/20.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "OrderDetailController.h"
#import "OrderCodeController.h"
#import "CommentViewController.h"
#import "OrderDetailHeadCell.h"
#import "OrderRefundCell.h"
#import "OrderCodeCell.h"
#import "OrderDetailCell.h"
#import "UIViewController+Extension.h"
#import "UITableViewCell+HYCell.h"
#import "NSString+Extension.h"
#import "HYPayEngine.h"
#import "HYAlertView.h"
#import "ZXingWrapper.h"

@interface OrderDetailController ()

@property(strong,nonatomic)NSDictionary* data;  //订单详情数据
@property(strong,nonatomic)NSMutableArray* ticketArr;   //订单票数组
@property(assign,nonatomic)ContentType contentType;//订单类型,0:theater、1:derive、2:card
@property(assign,nonatomic)NSString* orderId;    //订单Id
@property(assign,nonatomic)NSInteger orderStatu;    //待支付、待使用、待评价、退款、支付超时、已评价等(234567)

@property(strong,nonatomic)NSArray* maps;//手机安装的地图的数组
@end

@implementation OrderDetailController

- (void)viewDidLoad {
    [super viewDidLoad];

    if (self.schemaArgu[@"contentType"]) {
        self.contentType = [[self.schemaArgu objectForKey:@"contentType"] integerValue];
    }
    if (self.schemaArgu[@"orderId"]) {
        self.orderId = [self.schemaArgu objectForKey:@"orderId"];
    }
    
    [self baseSetupTableView:UITableViewStylePlain InSets:UIEdgeInsetsMake(0, 0, 0, 0)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tableView registerNib:[UINib nibWithNibName:[OrderDetailHeadCell identify] bundle:nil] forCellReuseIdentifier:[OrderDetailHeadCell identify]];
    [self.tableView registerNib:[UINib nibWithNibName:[OrderRefundCell identify] bundle:nil] forCellReuseIdentifier:[OrderRefundCell identify]];
    [self.tableView registerNib:[UINib nibWithNibName:[OrderCodeCell identify] bundle:nil] forCellReuseIdentifier:[OrderCodeCell identify]];
    [self.tableView registerNib:[UINib nibWithNibName:[OrderDetailCell identify] bundle:nil] forCellReuseIdentifier:[OrderDetailCell identify]];

//    [self subviewStyle];
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
    
    [APIHELPER requestTheaterContinuePayInfoWithOrderId:self.orderId complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
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
    return 4;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 2) {
        switch (self.contentType) {
            case TypeTheater:
                return (self.orderStatu == 2 || self.orderStatu == 6) ? 1 : 2;
                break;
            case TypeDerive:
                return 1;
            default:
                break;
        }
    }
    return 2;   //section==0 || section==3
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row==0) {
                return [self headCellForTableView:tableView indexPath:indexPath];
            }else{
                return [self refundCellForTableView:tableView indexPath:indexPath];
            }
        }
        case 1:
        {
            if (indexPath.row==0) {
                return [self timeCellForTableView:tableView indexPath:indexPath];
            }else{
                return [self addressCellForTableView:tableView indexPath:indexPath];
            }
        }
            
        case 2:
            if (self.contentType == TypeTheater && (self.orderStatu == 2 || self.orderStatu == 6)) {
                return [self waitPayTicketsCellForTableView:tableView indexPath:indexPath];
            }else{
                if (indexPath.row == 0) {
                    return [self codeCellForTableView:tableView indexPath:indexPath];
                }else{
                    return [self ticketCellForTableView:tableView indexPath:indexPath];
                }
            }
        default:{
            if (indexPath.row==0) {
                return [self detailHeadCellForTableView:tableView indexPath:indexPath];
            }else{
                return [self detailCellForTableView:tableView indexPath:indexPath];
            }
        }
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, zoom(15))];
    view.backgroundColor = [UIColor hyViewBackgroundColor];
    return view;
}

#pragma mark - tableView delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray* height = @[@[@(128),@(40)],@[@(48),@(48)],@[@(116)],@[@(48),@(142)]];
    
    if (indexPath.section == 2) {
        if (self.contentType == TypeTheater && (self.orderStatu == 2 || self.orderStatu == 6)) {
            return 48;
        }else{
            if (indexPath.row == 0) {
                return 212;
            }else{
                return self.ticketArr.count == 0 ? 0 : 18 + self.ticketArr.count * 30;
            }
        }
    }else{
        return [height[indexPath.section][indexPath.row] floatValue];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return section == 3 ? 0 : zoom(15);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1 && indexPath.row == 1) {
        //打开地图
        NSString* address = @"";
        switch (self.contentType) {
            case 0:
                address = self.data[@"theatre_name"];
                break;
            case 1:
                address = self.data[@"exchange_place"];
                break;
            default:
                break;
        }
        if ([address isEqualToString:@"线上兑换"]) {
            return;
        }
        [self geocoderClick:address];
        return;
    }
}
#pragma mark - private methods
-(UITableViewCell*)headCellForTableView:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath {
    OrderDetailHeadCell* cell = [tableView dequeueReusableCellWithIdentifier:[OrderDetailHeadCell identify]];
    [HYTool configTableViewCellDefault:cell];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    
    switch (self.contentType) {
        case TypeTheater:
            [cell configTheaterHeadCell:self.data];
            break;
        case TypeDerive:
            [cell configDeriveHeadCell:self.data];
            break;
        case TypeCard:
            [cell configYearCardHeadCell:self.data];
            break;
        default:
            [cell configLectureHeadCell:self.data];
            break;
    }
    return cell;
}
-(UITableViewCell*)refundCellForTableView:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath {
    OrderRefundCell* cell = [tableView dequeueReusableCellWithIdentifier:[OrderRefundCell identify]];
    if (self.contentType == TypeDerive) {
        [cell configDeriveRefundCell];
    }
    return cell;
}
-(UITableViewCell*)timeCellForTableView:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath {
    
    static NSString* cellId = @"timeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        [HYTool configTableViewCellDefault:cell];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        
        UIButton* btn = [HYTool getButtonWithFrame:CGRectMake(kScreen_Width-12-60, 9, 60, 30) title:@"退款" titleSize:15 titleColor:[UIColor hyBarTintColor] backgroundColor:[UIColor clearColor] blockForClick:nil];
        [HYTool configViewLayer:btn withColor:[UIColor hyBarTintColor]];
        btn.tag = 1000;
        [cell.contentView addSubview:btn];
        
        UILabel* lbl = [[UILabel alloc] initWithFrame:CGRectZero];
        lbl.textColor = RGB(78, 78, 78, 1.0);
        lbl.font = [UIFont systemFontOfSize:15];
        [cell.contentView addSubview:lbl];
        [lbl autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 10, 0, 0) excludingEdge:ALEdgeRight];
        [lbl autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:btn];
        lbl.tag = 1001;
    }
    UIButton* btn = [cell.contentView viewWithTag:1000];
    UILabel* lbl = [cell.contentView  viewWithTag:1001];
    
    NSString* deadLine = [HYTool dateStringWithString:self.data[@"expire_time"] inputFormat:nil outputFormat:@"yyyy-MM-dd"];
    if (self.contentType == TypeTheater) {
        switch (self.orderStatu) {
            case 1:{    //全部
//                lbl.text = @"订单状态: 待支付";
//                lbl.attributedText = [lbl.text attributedStringWithString:@"待支付" andWithColor:[UIColor hyRedColor]];
//                break;
            }
            case 2:{
                lbl.text = @"订单状态: 待支付";
                lbl.attributedText = [lbl.text attributedStringWithString:@"待支付" andWithColor:[UIColor hyRedColor]];
                break;
            }
            case 3:{
                lbl.text = [NSString stringWithFormat:@"有效期至: %@",deadLine];
                lbl.textColor = [UIColor hyBlackTextColor];
                break;
            }
            case 4:{
                lbl.text = @"订单状态: 待评价";
                lbl.attributedText = [lbl.text attributedStringWithString:@"待评价" andWithColor:[UIColor hyRedColor]];
                break;
            }
            case 5:{
                lbl.text = @"订单状态: 已退款";
                lbl.attributedText = [lbl.text attributedStringWithString:@"已退款" andWithColor:[UIColor hyRedColor]];
                break;
            }
            case 6:{
                lbl.text = @"订单状态: 支付超时";
                lbl.attributedText = [lbl.text attributedStringWithString:@"支付超时" andWithColor:[UIColor hyRedColor]];
                break;
            }
            case 7:{
                lbl.text = @"订单状态: 已评价";
                lbl.attributedText = [lbl.text attributedStringWithString:@"已评价" andWithColor:[UIColor hyRedColor]];
                break;
            }
            default:
                break;
        }
    }else if (self.contentType == TypeDerive) {
        switch (self.orderStatu) {
            case 1:{
                lbl.text = [NSString stringWithFormat:@"有效期至: %@",deadLine];
                lbl.textColor = [UIColor hyBlackTextColor];
                break;
            }
            case 2:{
                lbl.text = @"订单状态: 待评价";
                lbl.attributedText = [lbl.text attributedStringWithString:@"待评价" andWithColor:[UIColor hyRedColor]];
                break;
            }
            case 3:{
                lbl.text = @"订单状态: 已完成";
                lbl.attributedText = [lbl.text attributedStringWithString:@"已完成" andWithColor:[UIColor hyRedColor]];
                break;
            }
            default:
                break;
        }
    }
    
    if (self.contentType == TypeDerive) {
        if ([self.data[@"order_status"] integerValue] == 2) {
            [btn setTitle:@"去评价" forState:UIControlStateNormal];
            [btn bk_whenTapped:^{
                //评价
                CommentViewController* vc = (CommentViewController*)VIEWCONTROLLER(kCommentViewController);
                vc.data = self.data;
                vc.type = CommentTypeDerive;
                [self.navigationController pushViewController:vc animated:YES];
            }];
        }else{
            btn.hidden = YES;
        }
    }else{
        [btn bk_whenTapped:^{
            //退款
            APPROUTE(kOrderRefundController);
        }];
    }
    btn.hidden = YES;
    return cell;
    
}

-(UITableViewCell*)addressCellForTableView:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath {
    static NSString* cellId = @"addressCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        [HYTool configTableViewCellDefault:cell];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 16, 16, 16)];
        imageView.image = ImageNamed(@"定位");
        UILabel* lbl = [HYTool getLabelWithFrame:CGRectMake(35, 0, kScreen_Width, 48) text:@"" fontSize:15 textColor:[UIColor hyBlueTextColor] textAlignment:NSTextAlignmentLeft];
        lbl.tag = 1000;
        [cell.contentView addSubview:imageView];
        [cell.contentView addSubview:lbl];
    }
    UILabel* lbl = [cell.contentView viewWithTag:1000];
    NSString* address = @"";
    switch (self.contentType) {
        case 0:
            address = self.data[@"theatre_name"];
            break;
        case TypeDerive:
            address = self.data[@"exchange_place"];
            break;
        case TypeCard:
            address = self.data[@"theatre_name"];
            break;
        default:
            break;
    }
    lbl.text = [NSString stringWithFormat:@"地点: %@",address];
    return cell;
}
-(UITableViewCell*)codeCellForTableView:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath {
    OrderCodeCell*cell = [tableView dequeueReusableCellWithIdentifier:[OrderCodeCell identify]];
    
    [cell configCodeCell:self.data isDerive:self.contentType == TypeDerive ? YES : NO];
    [cell addLine:NO leftOffSet:0 rightOffSet:0];
    return cell;
}
-(UITableViewCell*)ticketCellForTableView:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath {
    static NSString* cellId = @"ticketCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        [HYTool configTableViewCellDefault:cell];
        cell.contentView.backgroundColor = [UIColor whiteColor];
    }
    for (UIView* subview in cell.contentView.subviews) {
        [subview removeFromSuperview];
    }
    for (int i=0; i<self.ticketArr.count; i++) {
        NSDictionary* ticket = self.ticketArr[i];
        UIView* ticketView = LOADNIB(@"OrderUseView", 1);
        ticketView.frame = CGRectMake(0, 9+i*30, kScreen_Width, 30);
        UILabel* seatLbl = [ticketView viewWithTag:1000];
        UILabel* statuLbl = [ticketView viewWithTag:1001];
        
        seatLbl.text = ticket[@"seat_name"];
        switch ([ticket[@"status"] integerValue]) {
            case -1:
                statuLbl.text = @"已退款";
                break;
            case 0:{
                seatLbl.textColor = [UIColor hyBlackTextColor];
                statuLbl.textColor = [UIColor hyBlackTextColor];
                statuLbl.text = @"未出票";
            }break;
            default:{
                statuLbl.text = @"已出票";
            }break;
        }
        [cell.contentView addSubview:ticketView];
    }
    return cell;
}
-(UITableViewCell*)waitPayTicketsCellForTableView:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath {
    
    static NSString* cellId = @"waitPayTicketsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        [HYTool configTableViewCellDefault:cell];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        
        UIScrollView* scrollV = [[UIScrollView alloc] initWithFrame:cell.bounds];
        scrollV.tag = 1000;
        [cell.contentView addSubview:scrollV];
    }
    UIScrollView* scroll = [cell.contentView viewWithTag:1000];
    for (int i=0; i<self.ticketArr.count; i++) {
        NSDictionary* ticket = self.ticketArr[i];
        UILabel* lbl = [HYTool getLabelWithFrame:CGRectMake(i*115, 0, 115, 48) text:ticket[@"seat_name"] fontSize:15 textColor:[UIColor hyBlackTextColor] textAlignment:NSTextAlignmentCenter];
        [scroll addSubview:lbl];
    }
    return cell;
}

-(UITableViewCell*)detailHeadCellForTableView:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath {
    
    static NSString* cellId = @"detailHeadCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        [HYTool configTableViewCellDefault:cell];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        
        UILabel* label = [HYTool getLabelWithFrame:CGRectMake(10, 0, kScreen_Width-20, 48) text:@"订单信息" fontSize:15 textColor:[UIColor hyBlackTextColor] textAlignment:NSTextAlignmentLeft];
        [cell.contentView addSubview:label];
    }
    return cell;
}
-(UITableViewCell*)detailCellForTableView:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath {
    
    OrderDetailCell* cell = [tableView dequeueReusableCellWithIdentifier:[OrderDetailCell identify]];
    [HYTool configTableViewCellDefault:cell];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    [cell configDetailCell:self.data type:self.contentType];
    return cell;
}

- (NSMutableArray *)ticketArr {
    if (!_ticketArr) {
        _ticketArr = [NSMutableArray array];
    }
    return _ticketArr;
}

-(void)fetchData {
    
    if (self.contentType == TypeTheater) {
        [APIHELPER orderDetailTheater:self.orderId complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
            if (isSuccess) {
                self.data = responseObject[@"data"];
                [self.ticketArr addObjectsFromArray:responseObject[@"data"][@"detail"]];
                [self judgeOrderStatu];
                [self subviewStyle];
                [self.tableView reloadData];
            }else{
                [self showMessage:error.userInfo[NSLocalizedDescriptionKey]];
            }
        }];
    }else if (self.contentType == TypeDerive) {
        [APIHELPER orderDetailDerive:self.orderId complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
            if (isSuccess) {
                self.data = responseObject[@"data"];
                [self judgeOrderStatu];
                [self.tableView reloadData];
            }else{
                [self showMessage:error.userInfo[NSLocalizedDescriptionKey]];
            }
        }];
    } else if (self.contentType == TypeCard) {
        [APIHELPER orderDetailCard:self.orderId complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
            if (isSuccess) {
                self.data = responseObject[@"data"];
                [self.tableView reloadData];
            }else{
                [self showMessage:error.userInfo[NSLocalizedDescriptionKey]];
            }
        }];
    }
}

-(void)judgeOrderStatu {
    
    if (self.contentType == TypeTheater) {
        NSInteger payStatu = [self.data[@"pay_status"] integerValue];
        NSInteger statu = [self.data[@"order_status"] integerValue];
        NSInteger timeLeft = [self.data[@"time_left"] integerValue];
        if (payStatu == 0) {
            self.orderStatu = timeLeft == 0 ? 6 : 2;
            return;
        }
        if (payStatu == 3) {
            self.orderStatu = 5;
            return;
        }
        if (payStatu == 1) {
            if (statu == 0) {
                self.orderStatu = 3;
                return;
            }
            if (statu == 1) {
                self.orderStatu = 4;
                return;
            }
            if (statu == 4) {
                self.orderStatu = 7;
                return;
            }
        }
    } else {
        self.orderStatu = [self.data[@"order_status"] integerValue];
    }

}


-(void)subviewStyle {
    if (self.orderStatu == 2/* || self.orderStatu == 6*/) {
        [self.tableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(30, 0, 72, 0)];
    }
}


#pragma mark - registNotification
//支付成功收到回调
- (void)registNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySuccess) name:kPaySuccessNotification object:nil];
}
- (void)paySuccess {
    APPROUTE(([NSString stringWithFormat:@"%@?contentType=%d&order_sn=%@",kTheaterCommitOrderSuccessController,0,self.orderId]));
}


@end
