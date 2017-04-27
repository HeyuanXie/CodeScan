//
//  OrderHomeController.m
//  Base
//
//  Created by admin on 2017/3/10.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "OrderHomeController.h"
#import "CommentViewController.h"
#import "OrderFilterTableController.h"
#import "OrderListCell.h"
#import "CustomJumpBtns.h"
#import "HYPayEngine.h"
#import "HYAlertView.h"
#import "NSString+Extension.h"

@interface OrderHomeController ()<UITextFieldDelegate>

@property(strong,nonatomic)UIView* topView;

@property(assign,nonatomic)NSInteger typeId;    //订单类型Id, 0为演出、1为商品、2为年卡
@property(assign,nonatomic)NSInteger statuId;   //订单状态Id, 待付款、待评价等等
@property(strong,nonatomic)NSString* keyword;   //关键词
@property(strong,nonatomic)NSMutableArray* dataArray;

@property(strong,nonatomic)NSArray *types;  //订单类型数组
@property(strong,nonatomic)NSArray *status; //订单状态数组
@property(strong,nonatomic)UIButton* filterBtn;

@property(strong,nonatomic)OrderFilterTableController* filterVC;
@property(strong,nonatomic)UIView* backGrayView;

@property(strong,nonatomic)NSString* payOrderSn;    //继续支付的订单的orderSn

@property(strong,nonatomic)NSTimer* timer;  //用于订单倒计时
@property(strong,nonatomic)NSMutableArray* totalLastTime;  //存储所有订单剩余支付时间和indexPath

@end

@implementation OrderHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.backItemHidden = YES;
    self.haveTableFooter = YES;
    self.types = @[@"演出",@"商品",@"年卡"];
    self.status = @[@"全部",@"待付款",@"待使用",@"待评价",@"退款"];
    if (self.schemaArgu[@"typeId"]) {
        self.typeId = [[self.schemaArgu objectForKey:@"typeId"] integerValue];
    }
    self.statuId = 1;
    
    [self baseSetupTableView:UITableViewStylePlain InSets:UIEdgeInsetsMake(90, 0, 0, 0)];
    [self.tableView registerNib:[UINib nibWithNibName:[OrderListCell identify] bundle:nil] forCellReuseIdentifier:[OrderListCell identify]];

    [self subviewStyle];
    [self registNotification];
    [self headerViewInit];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    [self addTimer];
    [self fetchData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self hiddenFilterClassify];
    [self removeTimer];
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
    OrderListCell* cell = [tableView dequeueReusableCellWithIdentifier:[OrderListCell identify]];
    [HYTool configTableViewCellDefault:cell];
    
    NSDictionary* model = self.dataArray[indexPath.row];
    CommentType type;
    if (self.typeId == 0) {
        [cell configTheaterCell:model orderStatu:self.statuId];
        [cell setPayContinueBlock:^(id model) {
            if ([model[@"time_left"] integerValue]==0) {
                [self showMessage:@"支付超时, 订单已取消"];
                return ;
            }
            self.payOrderSn = model[@"order_id"];
            [APIHELPER requestTheaterContinuePayInfoWithOrderId:model[@"order_id"] complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
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
        }];
        type = CommentTypeTheater;
    }else if (self.typeId == 1) {
        [cell configDeriveCell:model orderStatu:self.statuId];
        type = CommentTypeDerive;
    }else{
        [cell configYearCardCell:model orderStatu:self.statuId];
        [cell setPayContinueBlock:^(id model) {
            if ([model[@"time_left"] integerValue]==0) {
                [self showMessage:@"支付超时, 订单已取消"];
                return ;
            }
            self.payOrderSn = model[@"order_id"];
            [APIHELPER requestCardContinuePayInfoWithOrderId:model[@"order_id"] complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
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
        }];
    }
    [cell setCommentBlock:^(id model) {
        CommentViewController* vc = (CommentViewController*)VIEWCONTROLLER(kCommentViewController);
        vc.data = model;
        vc.type = type;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [cell setNoRefundBlock:^{
        [self showMessage:@"已出票,无法退款"];
    }];
    return cell;
}

#pragma mark - tableView delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 174;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary* model = self.dataArray[indexPath.row];
    NSString* orderId = model[@"order_id"];
    //TODO:进入订单详情，传递type参数,传递订单Id、statuId参数
    if (self.statuId == 1 && self.typeId == 0) {
        //从剧场订单——>全部——>详情
        NSInteger deliveryStatuId = 0;
        NSInteger orderStatus = [model[@"order_status"] integerValue];
        NSInteger payStatus = [model[@"pay_status"] integerValue];
        if (payStatus == 0) {
            //未支付
            deliveryStatuId = 2;
        }else if (payStatus == 3) {
            //已退款
            APPROUTE(([NSString stringWithFormat:@"%@?orderId=%@&contentType=%ld",kOrderRefundDetailController,orderId,self.typeId]));
            return;
        }else{
            if (orderStatus == 0) {
                //待使用
                deliveryStatuId = 3;
            }
            if (orderStatus == 4) {
                //待评价
                deliveryStatuId = 4;
            }
        }
        APPROUTE(([NSString stringWithFormat:@"%@?contentType=%ld&orderId=%@",kOrderDetailController,self.typeId,orderId]));
        return;
    }
    if (self.statuId == 5) {    //退款状态
        APPROUTE(([NSString stringWithFormat:@"%@?orderId=%@&contentType=%ld",kOrderRefundDetailController,orderId,self.typeId]));
        return;
    }
    if (self.typeId == 2) {     //年卡订单
        if (self.statuId == 1) {
            //年卡订单——>全部——>详情
            NSInteger deliveryStatuId = 0;
            NSInteger isBind = [model[@"is_bind"] integerValue];
            NSInteger payStatus = [model[@"pay_status"] integerValue];
            if (payStatus == 0) {
                //未支付
                deliveryStatuId = 2;
            }else if (payStatus == 3) {
                //已退款
                APPROUTE(([NSString stringWithFormat:@"%@?orderId=%@&contentType=%ld",kOrderRefundDetailController,orderId,self.typeId]));
                return;
            }else{
                if (isBind == 0) {
                    //待使用
                    deliveryStatuId = 3;
                }else{
                    //已使用
                    deliveryStatuId = 4;
                }
            }
            APPROUTE(([NSString stringWithFormat:@"%@?orderId=%@",kYearCardOrderController,orderId]));
            return;
        }
        //年卡订单(非全部)——>详情
        APPROUTE(([NSString stringWithFormat:@"%@?orderId=%@",kYearCardOrderController,orderId]));
        return;
    }
    //剧场订单(非全部) + 衍生品订单 ——>详情
    APPROUTE(([NSString stringWithFormat:@"%@?contentType=%ld&orderId=%@",kOrderDetailController,self.typeId,orderId]));
}

#pragma mark - textField delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    self.keyword = textField.text;
    [self fetchData];
    return YES;
}

#pragma mark - private methods
-(NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)totalLastTime {
    if (!_totalLastTime) {
        _totalLastTime = [NSMutableArray array];
    }
    return _totalLastTime;
}

-(OrderFilterTableController *)filterVC {
    if (!_filterVC) {
        _filterVC = [[OrderFilterTableController alloc] init];
    }
    return _filterVC;
}

- (UIView *)backGrayView {
    if (_backGrayView == nil) {
        _backGrayView = [[UIView alloc] initWithFrame:self.view.bounds];
        _backGrayView.backgroundColor = [UIColor hyBlackTextColor];
        _backGrayView.alpha = 0.4;
        [_backGrayView bk_whenTapped:^{
            [self hiddenFilterClassify];
        }];
    }
    return _backGrayView;
}

- (void)fetchData {
    
    self.tableView.tableFooterView = nil;
    [self.dataArray removeAllObjects];
    [self.tableView reloadData];
    [self showLoadingAnimation];
    switch (self.typeId) {
        case 0:
        {
            //演出
            [APIHELPER orderListTheater:0 limit:4 statu:self.statuId keyword:self.keyword complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
                [self hideLoadingAnimation];
                if (isSuccess) {
                    [self.dataArray addObjectsFromArray:responseObject[@"data"][@"list"]];
                    [self.totalLastTime removeAllObjects];
                    for (int i=0; i<self.dataArray.count; i++) {
                        NSDictionary* dict = self.dataArray[i];
                        NSInteger time = [dict[@"time_left"] integerValue];
                        if (time == 0) {
                            break;
                        }
                        [self.totalLastTime addObject:@{@"indexPath":[NSString stringWithFormat:@"%d",i],@"time":[NSString stringWithFormat:@"%ld",time]}];
                    }
                    [self.tableView reloadData];
                    
                    self.haveNext = [responseObject[@"data"][@"have_next"] boolValue];
                    if (self.haveNext) {
                        [self appendFooterView];
                    }else{
                        [self removeFooterRefresh];
                    }
                }else{
                    [self showMessage:error.userInfo[NSLocalizedDescriptionKey]];
                }
            }];
            break;
        }
        case 1:
        {
            //商品
            [APIHELPER orderListDerive:0 limit:4 statu:self.statuId keyword:self.keyword complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
                [self hideLoadingAnimation];
                if (isSuccess) {
                    [self.dataArray addObjectsFromArray:responseObject[@"data"][@"list"]];
                    [self.tableView reloadData];
                    
                    self.haveNext = [responseObject[@"data"][@"have_next"] boolValue];
                    if (self.haveNext) {
                        [self appendFooterView];
                    }else{
                        [self removeFooterRefresh];
                    }
                }else{
                    [self showMessage:error.userInfo[NSLocalizedDescriptionKey]];
                }
            }];
            break;
        }
        case 2:
        {
            //年卡
            [APIHELPER orderListCard:0 limit:4 statu:self.statuId keyword:self.keyword complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
                [self hideLoadingAnimation];
                if (isSuccess) {
                    [self.dataArray addObjectsFromArray:responseObject[@"data"][@"list"]];
                    [self.totalLastTime removeAllObjects];
                    for (int i=0; i<self.dataArray.count; i++) {
                        NSDictionary* dict = self.dataArray[i];
                        NSInteger time = [dict[@"time_left"] integerValue];
                        if (time == 0) {
                            continue;
                        }
                        [self.totalLastTime addObject:@{@"indexPath":[NSString stringWithFormat:@"%d",i],@"time":[NSString stringWithFormat:@"%ld",time]}];
                    }
                    [self.tableView reloadData];
                    
                    self.haveNext = [responseObject[@"data"][@"have_next"] boolValue];
                    if (self.haveNext) {
                        [self appendFooterView];
                    }else{
                        [self removeFooterRefresh];
                    }
                }else{
                    [self showMessage:error.userInfo[NSLocalizedDescriptionKey]];
                }
            }];
            break;
        }
        default:
            break;
    }
}

-(void)headerViewInit {
    @weakify(self);
    [self addHeaderRefresh:^{
        @strongify(self);
        [self showLoadingAnimation];
        switch (self.typeId) {
            case 0:
            {
                //演出
                [APIHELPER orderListTheater:0 limit:4 statu:self.statuId keyword:self.keyword complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
                    [self hideLoadingAnimation];
                    if (isSuccess) {
                        [self.dataArray removeAllObjects];
                        [self.dataArray addObjectsFromArray:responseObject[@"data"][@"list"]];
                        [self.totalLastTime removeAllObjects];
                        for (int i=0; i<self.dataArray.count; i++) {
                            NSDictionary* dict = self.dataArray[i];
                            NSInteger time = [dict[@"time_left"] integerValue];
                        if (time == 0) {
                            continue;
                        }
                            [self.totalLastTime addObject:@{@"indexPath":[NSString stringWithFormat:@"%d",i],@"time":[NSString stringWithFormat:@"%ld",time]}];
                        }
                        [self.tableView reloadData];
                        
                        self.haveNext = [responseObject[@"data"][@"have_next"] boolValue];
                        if (self.haveNext) {
                            [self appendFooterView];
                        }else{
                            [self removeFooterRefresh];
                        }
                    }else{
                        [self showMessage:error.userInfo[NSLocalizedDescriptionKey]];
                    }
                    [self endRefreshing];
                }];
                break;
            }
            case 1:
            {
                //商品
                [APIHELPER orderListDerive:0 limit:4 statu:self.statuId keyword:self.keyword complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
                    [self hideLoadingAnimation];
                    if (isSuccess) {
                        [self.dataArray removeAllObjects];
                        [self.dataArray addObjectsFromArray:responseObject[@"data"][@"list"]];
                        [self.tableView reloadData];
                        
                        self.haveNext = [responseObject[@"data"][@"have_next"] boolValue];
                        if (self.haveNext) {
                            [self appendFooterView];
                        }else{
                            [self removeFooterRefresh];
                        }
                    }else{
                        [self showMessage:error.userInfo[NSLocalizedDescriptionKey]];
                    }
                    [self endRefreshing];
                }];
                break;
            }
            case 2:
            {
                //年卡
                [APIHELPER orderListCard:0 limit:4 statu:self.statuId keyword:self.keyword complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
                    [self hideLoadingAnimation];
                    if (isSuccess) {
                        [self.dataArray removeAllObjects];
                        [self.dataArray addObjectsFromArray:responseObject[@"data"][@"list"]];
                        [self.totalLastTime removeAllObjects];
                        for (int i=0; i<self.dataArray.count; i++) {
                            NSDictionary* dict = self.dataArray[i];
                            NSInteger time = [dict[@"time_left"] integerValue];
                        if (time == 0) {
                            continue;
                        }
                            [self.totalLastTime addObject:@{@"indexPath":[NSString stringWithFormat:@"%d",i],@"time":[NSString stringWithFormat:@"%ld",time]}];
                        }
                        [self.tableView reloadData];
                        
                        self.haveNext = [responseObject[@"data"][@"have_next"] boolValue];
                        if (self.haveNext) {
                            [self appendFooterView];
                        }else{
                            [self removeFooterRefresh];
                        }
                    }else{
                        [self showMessage:error.userInfo[NSLocalizedDescriptionKey]];
                    }
                    [self endRefreshing];
                }];
                break;
            }
            default:
                break;
        }
    }];
}

-(void)appendFooterView {
    @weakify(self);
    [self addFooterRefresh:^{
        @strongify(self);
        [self showLoadingAnimation];
        switch (self.typeId) {
            case 0:
            {
                //演出
                [APIHELPER orderListTheater:self.dataArray.count limit:4 statu:self.statuId keyword:self.keyword complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
                    [self hideLoadingAnimation];
                    if (isSuccess) {
                        [self.dataArray addObjectsFromArray:responseObject[@"data"][@"list"]];
                        [self.totalLastTime removeAllObjects];
                        for (int i=0; i<self.dataArray.count; i++) {
                            NSDictionary* dict = self.dataArray[i];
                            NSInteger time = [dict[@"time_left"] integerValue];
                            if (time == 0) {
                                continue;
                            }
                            [self.totalLastTime addObject:@{@"indexPath":[NSString stringWithFormat:@"%d",i],@"time":[NSString stringWithFormat:@"%ld",time]}];
                        }
                        [self.tableView reloadData];
                        
                        self.haveNext = [responseObject[@"data"][@"have_next"] boolValue];
                        if (self.haveNext) {
                            [self appendFooterView];
                        }else{
                            [self removeFooterRefresh];
                        }
                    }else{
                        [self showMessage:error.userInfo[NSLocalizedDescriptionKey]];
                    }
                    [self endRefreshing];
                }];
                break;
            }
            case 1:
            {
                //商品
                [APIHELPER orderListDerive:self.dataArray.count limit:4 statu:self.statuId keyword:self.keyword complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
                    [self hideLoadingAnimation];
                    if (isSuccess) {
                        [self.dataArray addObjectsFromArray:responseObject[@"data"][@"list"]];
                        [self.tableView reloadData];
                        
                        self.haveNext = [responseObject[@"data"][@"have_next"] boolValue];
                        if (self.haveNext) {
                            [self appendFooterView];
                        }else{
                            [self removeFooterRefresh];
                        }
                    }else{
                        [self showMessage:error.userInfo[NSLocalizedDescriptionKey]];
                    }
                    [self endRefreshing];
                }];
                break;
            }
            case 2:
            {
                //年卡
                [APIHELPER orderListCard:self.dataArray.count limit:4 statu:self.statuId keyword:self.keyword complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
                    [self hideLoadingAnimation];
                    if (isSuccess) {
                        [self.dataArray addObjectsFromArray:responseObject[@"data"][@"list"]];
                        [self.totalLastTime removeAllObjects];
                        for (int i=0; i<self.dataArray.count; i++) {
                            NSDictionary* dict = self.dataArray[i];
                            NSInteger time = [dict[@"time_left"] integerValue];
                        if (time == 0) {
                            continue;
                        }
                            [self.totalLastTime addObject:@{@"indexPath":[NSString stringWithFormat:@"%d",i],@"time":[NSString stringWithFormat:@"%ld",time]}];
                        }
                        [self.tableView reloadData];
                        
                        self.haveNext = [responseObject[@"data"][@"have_next"] boolValue];
                        if (self.haveNext) {
                            [self appendFooterView];
                        }else{
                            [self removeFooterRefresh];
                        }
                    }else{
                        [self showMessage:error.userInfo[NSLocalizedDescriptionKey]];
                    }
                    [self endRefreshing];
                }];
                break;
            }
            default:
                break;
        }
    }];
}

-(void)subviewStyle {
    
    [self configNavigation];
    
    if (!self.topView) {
        self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 90)];
    }
    [self.view addSubview:_topView];
    for (UIView* subview in self.topView.subviews) {
        [subview removeFromSuperview];
    }
    _topView.backgroundColor = [UIColor whiteColor];
    
    CustomJumpBtns* btns = [CustomJumpBtns customBtnsWithFrame:CGRectMake(0, 0, kScreen_Width, 42) menuTitles:_status textColorForNormal:[UIColor hyBlackTextColor] textColorForSelect:[UIColor hyBarTintColor] isLineAdaptText:YES];
    [btns setFinished:^(NSInteger index) {
        self.statuId = index+1;
        [self fetchData];
    }];
    [_topView addSubview:btns];
 
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 42, kScreen_Width, 48)];
    view.backgroundColor = [UIColor hyViewBackgroundColor];
    [_topView addSubview:view];
    UITextField* textField = [HYTool getTextFieldWithFrame:CGRectMake(12, 12, kScreen_Width-24, 36) placeHolder:@"输入订单号/名称" fontSize:16 textColor:[UIColor hyBlackTextColor]];
    textField.backgroundColor = [UIColor whiteColor];
    textField.returnKeyType = UIReturnKeySearch;
    textField.delegate = self;
    [HYTool configViewLayer:textField];
    UIView* leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 36, 36)];
    UIImageView* imgV = [[UIImageView alloc] initWithFrame:CGRectMake(8, 8, 20, 20)];
    imgV.image = ImageNamed(@"home_search");
    [leftView addSubview:imgV];
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.leftView = leftView;
    [view addSubview:textField];
}

-(void)configNavigation {
    self.filterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.filterBtn.frame = CGRectMake(0, 0, 80, 44);
    [self.filterBtn setTitle:_types[self.typeId] forState:UIControlStateNormal];
    [self.filterBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.filterBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [self.filterBtn setImage:ImageNamed(@"三角形_白色下") forState:UIControlStateNormal];
    self.filterBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 40, 0, -40);
    self.filterBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 10);

    [self.filterBtn addTarget:self action:@selector(filterClassify) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = self.filterBtn;
}

- (void)filterClassify{
    [self.view endEditing:YES];
    if (self.filterVC.view.superview) {//分类
        [self hiddenFilterClassify];
        return;
    }
    [self.view addSubview:self.backGrayView];
    [self.filterBtn setImage:ImageNamed(@"三角形_白色上") forState:UIControlStateNormal];
    self.filterBtn.enabled = NO;
    [self.view addSubview:self.filterVC.view];
    [self addChildViewController:self.filterVC];
    [self.view bringSubviewToFront:self.filterVC.view];
    self.filterVC.view.frame = CGRectMake(0, -(kScreen_Height-64), kScreen_Width, kScreen_Height-64);
    self.filterVC.view.hidden = YES;
    self.filterVC.currentIndex = self.typeId;
    [UIView animateWithDuration:0.3 animations:^{
        self.filterVC.view.hidden = NO;
        self.filterVC.view.frame = CGRectMake(0, 0, kScreen_Width, kScreen_Height-64);
        self.filterVC.tableView.frame = CGRectMake(0, 0, kScreen_Width, 182*3/4);
        
    } completion:^(BOOL finished) {
        self.filterBtn.enabled = YES;
    }];
    
    @weakify(self)
    [self.filterVC setSelectIndex:^(NSInteger row) {
        @strongify(self);
        self.typeId = row;
        self.keyword = @"";
        [self selectClass:row];
        [self hiddenFilterClassify];
        
        if (row == 0) {
            self.status = @[@"全部",@"待付款",@"待使用",@"待评价",@"退款"];
        }else if (row == 1) {
            self.status = @[@"待领取",@"待评价",@"已完成"];
            [self.totalLastTime removeAllObjects];
        }else{
            self.status = @[@"全部",@"待付款",@"待使用",@"已使用",@"退款"];
        }
        [self subviewStyle];
    }];
    
}
- (void)hiddenFilterClassify{
    [self.filterVC removeFromParentViewController];
    [self.filterVC.view removeFromSuperview];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.filterVC.view.frame = CGRectMake(0, -(kScreen_Height-64), kScreen_Width, kScreen_Height-64);
        self.filterVC.view.hidden = YES;
    }];
    [self.backGrayView removeFromSuperview];
    [self.filterBtn setImage:ImageNamed(@"三角形_白色下") forState:UIControlStateNormal];
    self.filterBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 40, 0, -40);
    self.filterBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 10);
}
- (void)selectClass:(NSInteger)row{
    [self.filterBtn setTitle:_types[row] forState:UIControlStateNormal];
    //选择订单类型，设置默认订单状态
    self.statuId = 1;
    [self fetchData];
}


//MARK:- 支付成功收到回调
- (void)registNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySuccess) name:kPaySuccessNotification object:nil];
}
- (void)paySuccess {
    APPROUTE(([NSString stringWithFormat:@"%@?contentType=%ld&order_sn=%@",kTheaterCommitOrderSuccessController,self.typeId,self.payOrderSn]));
}

//MAKR:- 倒计时相关
-(void)addTimer {
    if (self.timer == nil) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(refreshLessTime) userInfo:@"" repeats:YES];
        //如果不添加下面这条语句，在UITableView拖动的时候，会阻塞定时器的调用
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:UITrackingRunLoopMode];
    }
}

-(void)refreshLessTime {
    NSUInteger time;
    for (int i = 0; i < self.totalLastTime.count; i++) {
        time = [[[self.totalLastTime objectAtIndex:i] objectForKey:@"time"]integerValue];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[[[self.totalLastTime objectAtIndex:i] objectForKey:@"indexPath"] integerValue] inSection:0];
        OrderListCell* cell = (OrderListCell*)[self.tableView cellForRowAtIndexPath:indexPath];
        if (time==0) {
            cell.statuLbl.text = @"支付超时";
            NSDictionary* model = self.dataArray[indexPath.row];
            cell.orderNumLbl.text = [NSString stringWithFormat:@"订单号: %@",model[@"order_sn"]];
            cell.leftBtn.hidden = YES;
            cell.rightBtn.hidden = NO;
            [cell.rightBtn setTitle:@"已取消" forState:UIControlStateNormal];
            [cell.rightBtn setGrayStyle];
            [cell setPayContinueBlock:^(id model) {
                [self showMessage:@"支付超时, 订单已取消"];
                return ;
            }];
            break;
        }
        NSString* str = [NSString stringWithFormat:@" 剩余支付时间：%@",[self lessSecondToDay:--time]];
        cell.orderNumLbl.attributedText = [str attributeStringWithAttachment:CGRectMake(0, -3, 15, 15) fontSize:12 textColor:[UIColor colorWithString:@"7F7F7F"] index:0 imageName:@"支付倒计时"];
//        cell.orderNumLbl.text = [NSString stringWithFormat:@"剩余支付时间：%@",[self lessSecondToDay:--time]];
        NSDictionary *dic = @{@"indexPath": [NSString stringWithFormat:@"%ld",indexPath.row],@"time": [NSString stringWithFormat:@"%ld",time]};
        [self.totalLastTime replaceObjectAtIndex:i withObject:dic];
    }
}

- (NSString *)lessSecondToDay:(NSInteger)seconds
{
    NSInteger min  = seconds/60;
    NSInteger second = seconds%60;
    
    NSString *time = [NSString stringWithFormat:@"%lu分%lu秒",(unsigned long)min,(unsigned long)second];
    return time;
}

-(void)removeTimer {
    
    [self.timer invalidate];
    self.timer = nil;
}
@end
