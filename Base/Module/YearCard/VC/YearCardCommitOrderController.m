//
//  YearCardOrderController.m
//  Base
//
//  Created by admin on 2017/3/9.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "YearCardCommitOrderController.h"
#import "SelectCouponController.h"
#import "CouponModel.h"
#import "OrderTopCell.h"
#import "NSString+Extension.h"
#import "HYPayEngine.h"
#import "HYAlertView.h"

@interface YearCardCommitOrderController ()

@property (strong, nonatomic) NSMutableDictionary* data;
@property (weak, nonatomic) IBOutlet UILabel *totalLbl;

@property (strong, nonatomic) NSString* orderSn;
@property (strong, nonatomic) NSString *payId;  //付款Id,用于theaterCommitOrderSuccessController页面请求获得的积分

@property (strong, nonatomic) NSMutableArray* payMethods;

/**
 选择的支付方式, 1:微信； 2:支付宝；
 */
@property (assign, nonatomic) NSInteger selectIndex;    //记录选择的支付方式

@property (strong, nonatomic) SelectCouponController * couponController;
@property (strong, nonatomic) NSMutableArray* coupons;
@property (strong, nonatomic) CouponModel* selectCoupon;

@end

@implementation YearCardCommitOrderController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.selectIndex = 1;
    self.data = [NSMutableDictionary dictionary];
    for (NSString* key in @[@"card_name",@"total_times",@"thumb",@"price",@"card_id"]) {
        [self.data setObject:[self.schemaArgu objectForKey:key] forKey:key];
    }
    [self baseSetupTableView:UITableViewStylePlain InSets:UIEdgeInsetsMake(0, 0, 60, 0)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tableView registerNib:[UINib nibWithNibName:[OrderTopCell identify] bundle:nil] forCellReuseIdentifier:[OrderTopCell identify]];

    [self fetchData];
    [self subviewInit];
    [self registNotification];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableView dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 2;
            break;
        case 1:
            return 1;
        default:
            return self.payMethods.count;
            break;
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            if (indexPath.row == 0) {
                OrderTopCell* cell = [tableView dequeueReusableCellWithIdentifier:[OrderTopCell identify]];
                [HYTool configTableViewCellDefault:cell];
                cell.contentView.backgroundColor = [UIColor whiteColor];
                cell.rightImgV.hidden = YES;
                cell.priceLbl.hidden = YES;
                [cell configTopCell:self.data];
                return cell;
            }else{
                static NSString* cellId = @"commonCell";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
                if (cell == nil) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
                    [HYTool configTableViewCellDefault:cell];
                    cell.contentView.backgroundColor = [UIColor whiteColor];
                }
                
                cell.textLabel.text = @"数量: 1张";
                cell.textLabel.textColor = [UIColor hyBlackTextColor];
                cell.textLabel.font = [UIFont systemFontOfSize:15];
                
                cell.detailTextLabel.textColor = [UIColor hyGrayTextColor];
                cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
//                NSString* str = @"合计: ¥99";
                NSString* str = [NSString stringWithFormat:@"¥%@",self.data[@"price"]];
                NSAttributedString* attStr = [str addAttribute:@[NSForegroundColorAttributeName,NSForegroundColorAttributeName,NSFontAttributeName] values:@[[UIColor hyRedColor],[UIColor hyRedColor],[UIFont systemFontOfSize:19]] subStrings:@[@"¥",self.data[@"price"],self.data[@"price"]]];
                cell.detailTextLabel.attributedText = attStr;
                cell.accessoryType = UITableViewCellAccessoryNone;
                return cell;
            }
        case 1:
        {
            static NSString* cellId = @"commonCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
                [HYTool configTableViewCellDefault:cell];
                cell.contentView.backgroundColor = [UIColor whiteColor];
            }
            
            cell.textLabel.text = @"优惠券";
            cell.textLabel.textColor = [UIColor hyBlackTextColor];
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            cell.detailTextLabel.textColor = [UIColor hyGrayTextColor];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
            if (self.coupons.count == 0) {
                cell.detailTextLabel.text = @"无可用优惠券";
            }else{
                cell.detailTextLabel.text = self.selectCoupon == nil ? @"选择优惠券" : self.selectCoupon.couponName;
            }
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        }
        default:
        {
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
                [self.tableView reloadSections:[[NSIndexSet alloc] initWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
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
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView* footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, zoom(15))];
    footerView.backgroundColor = [UIColor hyViewBackgroundColor];
    return footerView;
}

#pragma mark - tableView delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            return indexPath.row == 0 ? zoom(128) : 50;
        case 1:
            return 50;
        default:
            return indexPath.row == 0 ? 50 : 68;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return zoom(15);
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        //进入优惠券列表
        if (self.coupons.count == 0) {
            return;
        }
        [self showSelectCouponController];
        return;
    }
    if (indexPath.section == 2) {
        self.selectIndex = indexPath.row;
        [self.tableView reloadSections:[[NSIndexSet alloc] initWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
        return;
    }
}


#pragma mark - IBActions
- (IBAction)commitOrder:(id)sender {
    NSMutableDictionary* param = [NSMutableDictionary dictionary];
    NSInteger payType = self.selectIndex == 1 ? 2 : 1;
    [param safe_setValue:@([self.data[@"card_id"] integerValue]) forKey:@"card_id"];
    [param safe_setValue:@(payType) forKey:@"pay_type"];
    if (self.selectCoupon) {
        [param safe_setValue:self.selectCoupon.couponSn forKey:@"coupon_sn"];
    }

    [APIHELPER requestCardPayInfoWithParam:param complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
        if (isSuccess) {
            self.orderSn = responseObject[@"data"][@"order_id"];
            self.payId = responseObject[@"data"][@"pay_id"];
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

#pragma mark - private methods
-(NSMutableArray *)payMethods {
    if (!_payMethods) {
//        _payMethods = [NSMutableArray array];
        _payMethods = [@[@{@"title":@"支付方式",@"image":@""},@{@"title":@"微信支付",@"image":@"支付方式_微信"},@{@"title":@"支付宝支付",@"image":@"支付方式_支付宝"}] mutableCopy];
    }
    return _payMethods;
}

-(void)subviewInit {
    
    self.totalLbl.text = [NSString stringWithFormat:@"%.2f",[self.data[@"price"] floatValue]];
}

-(void)fetchData {
    [self showLoadingAnimation];
    [APIHELPER mineCouponList:0 limit:100 orderType:2 complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
        [self hideLoadingAnimation];
        if (isSuccess) {
            [self.coupons removeAllObjects];
            [self.coupons addObjectsFromArray:[NSArray yy_modelArrayWithClass:[CouponModel class] array:responseObject[@"data"][@"list"]]];
            [self.tableView  reloadData];
        }
    }];
}

-(SelectCouponController *)couponController {
    if (!_couponController) {
        _couponController = (SelectCouponController*)VIEWCONTROLLER(kSelectCouponController);
        _couponController.contentType = TypeYearCard;
    }
    return _couponController;
}

-(NSMutableArray *)coupons {
    if (!_coupons) {
        _coupons = [NSMutableArray array];
    }
    return _coupons;
}

-(void)showSelectCouponController {
    
    /*选择优惠券后，要做:
     1:记录self.selectCoupon(如果反选,赋值nil)
     2:改变self.couponController.couponIndex(如果反选,赋值1000)
     3:刷新tableView
     4:改变self.totalLbl.text
     */
    self.couponController.contentType = TypeCoupon;
    self.couponController.dataArray = [NSMutableArray arrayWithArray:self.coupons];
    @weakify(self);
    [self.couponController setSelectFinish:^(NSInteger index) {
        @strongify(self);
        if (self.selectCoupon == self.coupons[index]) {
            self.totalLbl.text = [NSString stringWithFormat:@"%.2f",[self.data[@"price"] floatValue]];
            self.selectCoupon = nil;
            self.couponController.couponIndex = 1000;
        }else{
            //如果不满足年卡使用条件
            CouponModel* coupon = self.coupons[index];
            if ([coupon.usedAmount floatValue] > [self.data[@"price"] floatValue]) {
                [self showMessage:@"消费金额不足,无法使用"];
                return ;
            }
            self.selectCoupon = self.coupons[index];
            self.couponController.couponIndex = index;
            self.totalLbl.text = [NSString stringWithFormat:@"%.2f",[self.data[@"price"] floatValue] - [coupon.couponAmount floatValue]];
        }
        [self hideSelectCouponController];
        [self.tableView reloadData];
    }];
    
    UIView* backGrayView = [[UIView alloc] initWithFrame:self.view.bounds];
    backGrayView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    backGrayView.tag = 10000;
    [backGrayView bk_whenTapped:^{
        [self hideSelectCouponController];
    }];
    [self.view addSubview:backGrayView];
    
    [self addChildViewController:self.couponController];
    CGFloat height = 48+120*self.coupons.count;
    CGFloat reactHeight = MIN(height, kScreen_Height*2/3);
    self.couponController.view.frame = CGRectMake(0, self.view.bounds.size.height, kScreen_Width, height);
    [self.view addSubview:self.couponController.view];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.couponController.view.frame = CGRectMake(0, self.view.bounds.size.height-reactHeight, kScreen_Width, height);
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


-(void)registNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySuccess) name:kPaySuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelPay) name:kPayCancelNotification object:nil];
}
-(void)paySuccess {
    
    APPROUTE(([NSString stringWithFormat:@"%@?contentType=2&order_sn=%@&payId=%@&payType=%ld",kTheaterCommitOrderSuccessController,self.orderSn,self.payId,self.selectIndex]));
}
-(void)cancelPay {
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
