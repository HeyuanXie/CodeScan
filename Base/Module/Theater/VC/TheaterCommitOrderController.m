//
//  TheaterCommitOrderController.m
//  Base
//
//  Created by admin on 2017/3/24.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "TheaterCommitOrderController.h"
#import "SelectCouponController.h"

#import "CommitOrderTopCell.h"
#import "CommitOrderSeatCell.h"
#import "TheaterModel.h"
#import "HYAlertView.h"
#import "HYPayEngine.h"
#import "UIButton+HYButtons.h"

@interface TheaterCommitOrderController ()

@property (weak, nonatomic) IBOutlet UILabel *totalLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;

@property (strong, nonatomic) NSString* orderSn;
@property (strong, nonatomic) NSString *payId;  //付款Id,用于theaterCommitOrderSuccessController页面请求获得的积分

@property (strong, nonatomic) NSMutableArray* payMethods;  //支付方法array
/**
 选中的支付方法 1：微信，2：支付宝

 */
@property (assign, nonatomic) NSInteger selectIndex;
@property (strong, nonatomic) SelectCouponController* couponController;
@property (strong, nonatomic) CouponModel* selectCoupon;  //选中的优惠券
@property (strong, nonatomic) id selectCard;    //选中的年卡

@property (strong, nonatomic) NSMutableArray* cardIndexArray;   //记录选择了哪些座位使用年卡,存储的是NSNumber类型

@property (assign, nonatomic) CGFloat originalTotal;    //原始总金额
@property (assign, nonatomic) CGFloat total;    //总金额
@property (assign, nonatomic) CGFloat apply;    //补差价

@property (assign, nonatomic) BOOL isPaySuccessd;   //退出时判断是否重写backAction

@end

@implementation TheaterCommitOrderController


//MARK:提交订单
- (IBAction)commit:(id)sender {
    
    NSMutableArray* seats = [NSMutableArray array];
    NSInteger i = 0;
    for (FVSeatItem* seat in self.selectArray) {
        NSMutableDictionary* dict = [NSMutableDictionary dictionary];
        [dict safe_setValue:@(seat.seatId) forKey:@"ps_id"];
        [dict safe_setValue:seat.seatName forKey:@"seat_name"];
        NSInteger isUseCard = 0;
        for (NSNumber* index in self.cardIndexArray) {
            if (i+1 == index.integerValue) {
                isUseCard = 1;
            }
        }
        [dict setValue:@(isUseCard) forKey:@"is_usecard"];
        [seats addObject:dict];
        i++;
    }
    
    NSInteger payType = self.selectIndex == 1 ? 2 : 1;
    if (self.total == 0) {
        payType = 0;
    }
    NSString* coupon_sn = self.selectCoupon.couponSn;
    NSString* card_sn = self.selectCard[@"card_sn"];
    
    NSMutableDictionary* param = [NSMutableDictionary dictionary];
    [param safe_setValue:seats forKey:@"seats"];
    [param safe_setValue:@(payType) forKey:@"pay_type"];
    [param safe_setValue:coupon_sn forKey:@"coupon_sn"];
    [param safe_setValue:card_sn forKey:@"card_sn"];
    [param safe_setValue:@(self.timeId) forKey:@"time_id"];
    [APIHELPER requestTheaterPayInfoWithParam:param complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
        if (isSuccess) {
            self.orderSn = responseObject[@"data"][@"order_id"];
            self.payId = responseObject[@"data"][@"pay_id"];
            if (payType == 0) {
                APPROUTE(([NSString stringWithFormat:@"%@?contentType=0&order_sn=%@&payId=%@",kTheaterCommitOrderSuccessController,_orderSn,_payId]));
                return ;
            }
            if ([responseObject[@"data"][@"pay_type"] integerValue] == 1) {
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
            }else{
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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.selectIndex = 1;
    
    for (FVSeatItem* seat in self.selectArray) {
        self.total += seat.realPrice;
    }
    self.originalTotal = self.total;
    self.totalLbl.text = [NSString stringWithFormat:@"%.2f",self.total];
    self.apply = 0.00;
    [self addObserver:self forKeyPath:@"total" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:@"totalChanged"];
    
    [self baseSetupTableView:UITableViewStylePlain InSets:UIEdgeInsetsMake(30, 0, 61, 0)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tableView registerNib:[UINib nibWithNibName:[CommitOrderTopCell identify] bundle:nil] forCellReuseIdentifier:[CommitOrderTopCell identify]];
    [self.tableView registerNib:[UINib nibWithNibName:[CommitOrderSeatCell identify] bundle:nil] forCellReuseIdentifier:[CommitOrderSeatCell identify]];
    [self secondsCountDown];
    [self registNotification];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self removeObserver:self forKeyPath:@"total" context:@"totalChanged"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - talbeView dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 2+self.selectArray.count;
        case 1:
            return 1;
        case 2:
            return 1;
        default:
            return self.payMethods.count;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row == 0) {
                return [self topCellForTableView:tableView indexPath:indexPath];
            }
            if (indexPath.row == self.selectArray.count+1) {
                return [self totalCellForTableView:tableView indexPath:indexPath];
            }
            return [self seatCellForTableView:tableView indexPath:indexPath];
        }
        case 1:
            return [self couponCellForTableView:tableView indexPath:indexPath];
        case 2:
            return [self yearCardCellForTableView:tableView indexPath:indexPath];
        default:
            return [self payCellForTableView:tableView indexPath:indexPath];
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView* headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, zoom(12))];
    headView.backgroundColor = [UIColor hyViewBackgroundColor];
    return headView;
}

#pragma mark - tableView delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 185;
    }
    if (indexPath.section == 3 && indexPath.row != 0) {
        return 68;
    }
    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? 0 : zoom(12);
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
        case 0:
            break;
        case 3:
        {
            //选择支付方式
            self.selectIndex = indexPath.row;
            [self.tableView reloadSections:[[NSIndexSet alloc] initWithIndex:3] withRowAnimation:UITableViewRowAnimationNone];
            break;
        }
        default:
        {
            //选择优惠券或年卡
            if (self.coupons.count == 0 && indexPath.section == 1) {
                return;
            }
            if (self.yearCards.count == 0 && indexPath.section == 2) {
                return;
            }
            [self showSelectCouponControllerSection:indexPath.section];
        }
    }
}

#pragma mark - cell for tableview 
-(UITableViewCell*)topCellForTableView:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath {
    CommitOrderTopCell* cell = [tableView dequeueReusableCellWithIdentifier:[CommitOrderTopCell identify]];
    //configNotVip or Vip
    
    TheaterModel *model = [[TheaterModel alloc] init];
    model.playName = self.playName;
    model.picurl = self.playImg;
    model.playTime = [HYTool dateStringWithString:self.playTime inputFormat:nil outputFormat:@"yyyy-MM-dd HH:mm"];
    model.address = self.address;
    if (self.selectCard == nil) {
        [cell configNotVipCell:model];
    }else{
        [cell configVipCell:model];
    }
    return cell;
}
-(UITableViewCell*)totalCellForTableView:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath {
    static NSString* cellId = @"totalCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        [HYTool configTableViewCellDefault:cell];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        
        cell.textLabel.textColor = [UIColor hyBlackTextColor];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        
        cell.detailTextLabel.textColor = [UIColor hyGrayTextColor];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"数量: %ld张",self.selectArray.count];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"(需补差价¥%.2f) 合计¥%.2f",self.apply,self.total];
    return cell;
}
-(UITableViewCell*)seatCellForTableView:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath {
    CommitOrderSeatCell* cell = [tableView dequeueReusableCellWithIdentifier:[CommitOrderSeatCell identify]];
    [HYTool configTableViewCellDefault:cell];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    
    //configVip or NotVip
    id model = self.selectArray[indexPath.row-1];
    if (self.selectCard == nil) {
        [cell configNotVipCell:model];
    }else{
        
        [cell configVipCell:model row:indexPath.row cardIndexs:self.cardIndexArray];
        [cell.selelctBtn bk_whenTapped:^{
            
            if (!cell.selelctBtn.selected) {
                if ((/*[self.selectCard[@"title"] isEqualToString:@"飞象卡(1大1小)"] && */self.cardIndexArray.count==2) || ([self.selectCard[@"title"] isEqualToString:@"飞象卡(2大1小)"] && self.cardIndexArray.count==3))
                {
                    [self showMessage:@"此年卡可选择座位已达上限"];
                    return ;
                }else{
                    cell.selelctBtn.selected = !cell.selelctBtn.selected;
                    [self.cardIndexArray addObject:@(indexPath.row)];
                    if (![self canUseCoupon]) {
                        HYAlertView* alert = [HYAlertView sharedInstance];
                        [alert showAlertView:@"提示" message:@"使用年卡购票后,所选优惠券将由于不满足条件无法使用,是否继续?" subBottonTitle:@"确定" cancelButtonTitle:@"取消" handler:^(AlertViewClickBottonType bottonType) {
                            switch (bottonType) {
                                case AlertViewClickBottonTypeSubBotton:
                                {
                                    self.selectCoupon = nil;
                                    self.couponController.couponIndex = 1000;
                                    [self caculateTotal];
                                    [self.tableView reloadData];
                                    break;
                                }
                                default:
                                {
                                    [self.cardIndexArray removeObject:@(indexPath.row)];
                                    [self.tableView reloadData];
                                    break;
                                }
                            }
                        }];
                    }else{
                        [self caculateTotal];
                        [self.tableView reloadData];
                    }
                }
            }else{
                cell.selelctBtn.selected = !cell.selelctBtn.selected;
                [self.cardIndexArray removeObject:@(indexPath.row)];
                [self caculateTotal];
                [self.tableView reloadData];
            }
        }];
    }
    return cell;
}

-(UITableViewCell*)couponCellForTableView:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath {
    static NSString* cellId = @"couponCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        [HYTool configTableViewCellDefault:cell];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.contentView.backgroundColor = [UIColor whiteColor];
        
        cell.textLabel.textColor = [UIColor hyBlackTextColor];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        
        cell.detailTextLabel.textColor = [UIColor hyGrayTextColor];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
        
        cell.textLabel.text = @"优惠券";
    }
    if (self.coupons.count == 0) {
        cell.detailTextLabel.text = @"无可用优惠券";
    }else{
        cell.detailTextLabel.text = self.selectCoupon == nil ? @"选择优惠券" : [NSString stringWithFormat:@"%@元代金券",[[self.selectCoupon.couponAmount componentsSeparatedByString:@"."] firstObject]];
    }
    return cell;
}

-(UITableViewCell*)yearCardCellForTableView:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath {
    
    static NSString* cellId = @"yearCardCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        [HYTool configTableViewCellDefault:cell];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.contentView.backgroundColor = [UIColor whiteColor];
        
        cell.textLabel.textColor = [UIColor hyBlackTextColor];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        
        cell.detailTextLabel.textColor = [UIColor hyGrayTextColor];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
        
        cell.textLabel.text = @"飞象卡会员";
        cell.imageView.image = ImageNamed(@"支付方式_年卡");
    }
    if (self.yearCards.count == 0) {
        cell.detailTextLabel.text = @"无可用年卡";
    }else{
        cell.detailTextLabel.text = self.selectCard == nil ? @"选择年卡" : self.selectCard[@"card_name"];
    }
    return cell;
}

-(UITableViewCell*)payCellForTableView:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath {
    
    static NSString* cellId = @"payCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        [HYTool configTableViewCellDefault:cell];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        
        UIButton* selectBtn = [HYTool getButtonWithFrame:CGRectZero title:nil titleSize:0 titleColor:nil backgroundColor:[UIColor clearColor] blockForClick:nil];
        [selectBtn setImage:ImageNamed(@"已选择") forState:UIControlStateSelected];
        [selectBtn setImage:ImageNamed(@"未选择") forState:UIControlStateNormal];
        selectBtn.tag = 1000;// + indexPath.row;
        [cell.contentView addSubview:selectBtn];
        [selectBtn autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0) excludingEdge:ALEdgeLeft];
        [selectBtn autoSetDimension:ALDimensionWidth toSize:48];
    }
    UIButton* selectBtn = [cell.contentView viewWithTag:1000];//+indexPath.row];
    selectBtn.selected = indexPath.row == self.selectIndex;
    selectBtn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        self.selectIndex = indexPath.row;
        [self.tableView reloadSections:[[NSIndexSet alloc] initWithIndex:3] withRowAnimation:UITableViewRowAnimationNone];
        return [RACSignal empty];
    }];
    if (indexPath.row == 0) {
        selectBtn.hidden = YES;
        cell.imageView.hidden = YES;
        cell.imageView.image = nil;
        cell.textLabel.text = @"支付方式";
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.textLabel.textColor = [UIColor blackColor];
    }else{
        selectBtn.hidden = NO;
        cell.imageView.hidden = NO;
        cell.imageView.image = ImageNamed(self.payMethods[indexPath.row][@"image"]);
        cell.textLabel.text = self.payMethods[indexPath.row][@"title"];
        cell.textLabel.textColor = [UIColor hyBlackTextColor];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
    }
    return cell;
}

#pragma mark - private methods
-(NSMutableArray *)payMethods {
    if (!_payMethods) {
        //        _payMethods = [NSMutableArray array];
        _payMethods = [@[@{@"title":@"支付方式",@"image":@""},@{@"title":@"微信支付",@"image":@"支付方式_微信"},@{@"title":@"支付宝支付",@"image":@"支付方式_支付宝"}] mutableCopy];
    }
    return _payMethods;
}

-(NSMutableArray *)cardIndexArray {
    if (!_cardIndexArray) {
        _cardIndexArray = [NSMutableArray array];
//        for (int i=0; i<self.selectArray.count; i++) {
//            [_cardIndexArray addObject:@(100)];
//        }
    }
    return _cardIndexArray;
}

-(SelectCouponController *)couponController {
    if (!_couponController) {
        _couponController = (SelectCouponController*)VIEWCONTROLLER(kSelectCouponController);
    }
    return _couponController;
}

-(void)showSelectCouponControllerSection:(NSInteger)section {
    
    /*选择优惠券后，要做:
     1:记录self.selectCoupon(如果反选,赋值nil)
     2:改变self.couponController.couponIndex(如果反选,赋值1000)
     3:刷新tableView
     4:改变self.total(KVO自动改变self.totalLbl.text)
     */
    if (section == 1) {
        self.couponController.contentType = TypeCoupon;
        self.couponController.dataArray = [NSMutableArray arrayWithArray:self.coupons];
        @weakify(self);
        [self.couponController setSelectFinish:^(NSInteger index) {
            @strongify(self);
            //选择优惠券、刷新table、重新计算金额
            if (self.selectCoupon == self.coupons[index]) {
                self.selectCoupon = nil;
                self.couponController.couponIndex = 1000;
            }else{
                //如果不满足年卡使用条件
                CouponModel* coupon = self.coupons[index];
                if ([coupon.usedAmount floatValue] > self.total) {
                    [self showMessage:@"消费金额不足,无法使用"];
                    return ;
                }
                self.selectCoupon = self.coupons[index];
                self.couponController.couponIndex = index;
            }
            [self hideSelectCouponController];
            [self caculateTotal];   //重新计算金额
            [self.tableView reloadData];
        }];
    }else{
        self.couponController.contentType = TypeYearCard;
        self.couponController.dataArray = [NSMutableArray arrayWithArray:self.yearCards];
        @weakify(self);
        [self.couponController setSelectFinish:^(NSInteger index) {
            @strongify(self);
            //选择年卡、刷新table
            if (self.selectCard == self.yearCards[index]) {
                self.selectCard = nil;
                [self.cardIndexArray removeAllObjects];
                self.couponController.cardIndex = 1000;
            }else{
                self.selectCard = self.yearCards[index];
                self.couponController.cardIndex = index;
            }
            [self hideSelectCouponController];
            [self caculateTotal];   //重新计算金额
            [self.tableView reloadData];
        }];
    }
    
    UIView* backGrayView = [[UIView alloc] initWithFrame:self.view.bounds];
    backGrayView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    backGrayView.tag = 10000;
    [backGrayView bk_whenTapped:^{
        [self hideSelectCouponController];
    }];
    [self.view addSubview:backGrayView];
    
    [self addChildViewController:self.couponController];
    CGFloat height = section == 1 ? 48+120*self.coupons.count : 48+120*self.yearCards.count;
    CGFloat reactHeight = MIN(height, kScreen_Height*2/3);
    self.couponController.view.frame = CGRectMake(0, self.view.bounds.size.height, kScreen_Width, height);
    [self.view addSubview:self.couponController.view];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.couponController.view.frame = CGRectMake(0, self.view.bounds.size.height-reactHeight, kScreen_Width, reactHeight);
    }];
}

-(void)hideSelectCouponController {
    
    [UIView animateWithDuration:0.3 animations:^{
        self.couponController.view.frame = CGRectMake(0, self.view.bounds.size.height, kScreen_Width, 48+120*2);
    } completion:^(BOOL finished) {
        [self.couponController.view removeFromSuperview];
        [self.couponController removeFromParentViewController];
        if ([self.view viewWithTag:10000]) {
            [[self.view viewWithTag:10000] removeFromSuperview];
        }
    }];
}


- (void)secondsCountDown {
    
    __block int timeout = self.timeLeft;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0*NSEC_PER_SEC, 0);//每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        
        if (timeout<=0) {
            
            dispatch_source_cancel(_timer);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                DLog(@"计时结束");
                self.timeLbl.text = @"超过支付时间，无法支付";
                [self.payBtn setGrayStyle];
            });
            
        }else {
            
            int minutes = timeout/60;
            
            int seconds = timeout%60;
            
            NSString *strTime = [NSString stringWithFormat:@"剩余支付时间 : %d分%d秒", minutes, seconds];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.timeLbl.text = strTime;
            });
            
            timeout--;
        }
        
    });
    
    dispatch_resume(_timer);
}

//MARK:先选择优惠券，选择年卡后，判断已经选择的优惠券是否满足使用条件
-(BOOL)canUseCoupon {
    if (self.selectCoupon == nil) {
        return YES;
    }
    CGFloat total = 0.00;
    CGFloat apply = 0.00;
    for (int i=0; i<self.selectArray.count; i++) {
        FVSeatItem* seat = self.selectArray[i];
        if ([self.cardIndexArray containsObject:@(i+1)]) {
            total += seat.cardPrice;
            apply += seat.cardPrice;
        }else{
            total += seat.realPrice;
        }
    }
    total = total+apply;
    return total > [self.selectCoupon.usedAmount floatValue];
}

-(void)caculateTotal {
    CGFloat total = 0.00;
    CGFloat apply = 0.00;
    for (int i=0; i<self.selectArray.count; i++) {
        FVSeatItem* seat = self.selectArray[i];
        if ([self.cardIndexArray containsObject:@(i+1)]) {
            total += seat.cardPrice;
            apply += seat.cardPrice;
        }else{
            total += seat.realPrice;
        }
    }
    self.total = total-[self.selectCoupon.couponAmount floatValue];
    self.apply = apply;
}

#pragma mark - override methods
-(void)backAction {
    if (self.isPaySuccessd) {
        [super backAction];
        return;
    }
    HYAlertView* alert = [HYAlertView sharedInstance];
    [alert showAlertViewWithMessage:@"您将放弃选座,选中的座位也将解锁,是否继续?" subBottonTitle:@"取消" cancelButtonTitle:@"确定" handler:^(AlertViewClickBottonType bottonType) {
        switch (bottonType) {
            case AlertViewClickBottonTypeSubBotton:
                
                break;
                
            default:{
                [super backAction];
                NSMutableArray* seats = [NSMutableArray array];
                NSInteger i = 0;
                for (FVSeatItem* seat in self.selectArray) {
                    [seats addObject:@(seat.seatId)];
                    i++;
                }
                [APIHELPER theaterSeatUnLockSeats:seats complete:^(BOOL isSuccess, NSDictionary *responseObject,     NSError *error) {
                    //TODO:如果解锁失败，怎么处理
                    
                }];
            }break;
        }
    }];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (context == @"totalChanged") {
        CGFloat total = [change[@"new"] floatValue];
        self.totalLbl.text = [NSString stringWithFormat:@"%.2f",total];
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}


#pragma mark - regist notification
-(void)registNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySuccess) name:kPaySuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelPay) name:kPayCancelNotification object:nil];
}
-(void)paySuccess {
    
    self.isPaySuccessd = YES;
    //跳到下单成功页面，order_sn、content_type、payId和pay_type
    APPROUTE(([NSString stringWithFormat:@"%@?contentType=0&order_sn=%@&payId=%@&payType=%ld",kTheaterCommitOrderSuccessController,self.orderSn,self.payId,self.selectIndex]));
}

-(void)cancelPay {
    //没安装支付宝，不会走appDelegate中的支付回调，不发发出支付取消的通知
    NSInteger count = self.navigationController.viewControllers.count;
    UIViewController *vc = self.navigationController.viewControllers[count-4];
    [self.navigationController popToViewController:vc animated:YES];
}

@end
