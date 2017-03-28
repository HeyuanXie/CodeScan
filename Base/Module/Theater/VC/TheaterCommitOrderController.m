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

@interface TheaterCommitOrderController ()

@property (weak, nonatomic) IBOutlet UILabel *totalLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;

@property (strong, nonatomic) NSMutableArray* payMethods;  //支付方法array
@property (assign, nonatomic) NSInteger selectIndex;    //选中的支付方法 1：微信，2：支付宝

@property (strong, nonatomic) SelectCouponController* couponController;
@property (strong, nonatomic) NSMutableArray* coupons;
@property (strong, nonatomic) NSMutableArray* yearCards;
@property (strong, nonatomic) id selectCoupon;  //选中的优惠券
@property (strong, nonatomic) id selectCard;    //选中的年卡

@property (strong, nonatomic) NSMutableArray* cardIndexArray;   //记录选择了哪些座位使用年卡

@end

@implementation TheaterCommitOrderController


- (IBAction)commit:(id)sender {
    //TODO:提交选座订单
    APPROUTE(([NSString stringWithFormat:@"%@?contentType=0",kTheaterCommmitOrderSuccessController]));
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.selectIndex = 1;
    
    [self baseSetupTableView:UITableViewStylePlain InSets:UIEdgeInsetsMake(30, 0, 61, 0)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tableView registerNib:[UINib nibWithNibName:[CommitOrderTopCell identify] bundle:nil] forCellReuseIdentifier:[CommitOrderTopCell identify]];
    [self.tableView registerNib:[UINib nibWithNibName:[CommitOrderSeatCell identify] bundle:nil] forCellReuseIdentifier:[CommitOrderSeatCell identify]];

    [self fetchData];
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
        {
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
                cell.detailTextLabel.text = self.selectCoupon == nil ? @"选择优惠券" : self.selectCoupon[@"title"];
            }
            return cell;
        }
        case 2:
        {
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
                cell.detailTextLabel.text = self.selectCard == nil ? @"选择年卡" : self.selectCard[@"title"];
            }
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
    }
    return [UITableViewCell new];
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
            [self showSelectCouponControllerSection:indexPath.section];
        }
    }
}

#pragma mark - cell for tableview 
-(UITableViewCell*)topCellForTableView:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath {
    CommitOrderTopCell* cell = [tableView dequeueReusableCellWithIdentifier:[CommitOrderTopCell identify]];
    //TODO:configNotVip or Vip
    
    if (self.selectCard == nil) {
        [cell configNotVipCell:nil];
    }else{
        [cell configVipCell:nil];
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
    cell.detailTextLabel.text = @"(需补差价¥0) 合计¥130";
    return cell;
}
-(UITableViewCell*)seatCellForTableView:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath {
    CommitOrderSeatCell* cell = [tableView dequeueReusableCellWithIdentifier:[CommitOrderSeatCell identify]];
    [HYTool configTableViewCellDefault:cell];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    
    //TODO:configVip or NotVip
    id model = self.selectArray[indexPath.row-1];
    if (self.selectCard == nil) {
        [cell configNotVipCell:model];
    }else{
        
        [cell configVipCell:model];
        
        for (NSNumber* row in self.cardIndexArray) {
            if ([row integerValue] == indexPath.row) {
                cell.selelctBtn.selected = YES;
                cell.originalPriceView.hidden = NO;
            }
        }
        [cell.selelctBtn bk_whenTapped:^{
            
            if (!cell.selelctBtn.selected) {
                if (([self.selectCard[@"title"] isEqualToString:@"飞象卡(1大1小)"] && self.cardIndexArray.count==2) || ([self.selectCard[@"title"] isEqualToString:@"飞象卡(2大1小)"] && self.cardIndexArray.count==3))
                {
                    [self showMessage:@"此年卡可选择座位已达上限"];
                    return ;
                }else{
                    cell.selelctBtn.selected = !cell.selelctBtn.selected;
                    [self.cardIndexArray addObject:@(indexPath.row)];
                    [self.tableView reloadData];
                }
            }else{
                cell.selelctBtn.selected = !cell.selelctBtn.selected;
                [self.cardIndexArray removeObject:@(indexPath.row)];
                [self.tableView reloadData];
            }
        }];
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

-(void)fetchData {
    
    self.coupons = [@[@{@"title":@"5元观剧代金券",@"price":@"5元"},@{@"title":@"5元观剧代金券",@"price":@"5元"}] mutableCopy];
    self.yearCards = [@[@{@"title":@"飞象卡(1大1小)",@"count":@"11",@"card_num":@"1235454657"},@{@"title":@"飞象卡(2大1小)",@"count":@"6",@"card_num":@"67834023435"}] mutableCopy];
    
    [self secondsCountDown];
}

-(SelectCouponController *)couponController {
    if (!_couponController) {
        _couponController = (SelectCouponController*)VIEWCONTROLLER(kSelectCouponController);
    }
    return _couponController;
}
-(NSMutableArray *)coupons {
    if (!_coupons) {
        _coupons = [NSMutableArray array];
    }
    return _coupons;
}
-(NSMutableArray *)yearCards {
    if (!_yearCards) {
        _yearCards = [NSMutableArray array];
    }
    return _yearCards;
}

-(void)showSelectCouponControllerSection:(NSInteger)section {
    if (section == 1) {
        self.couponController.contentType = TypeCoupon;
        self.couponController.dataArray = [NSMutableArray arrayWithArray:self.coupons];
        @weakify(self);
        [self.couponController setSelectFinish:^(NSInteger index) {
            @strongify(self);
            self.couponController.couponIndex = index;
            [self hideSelectCouponController];
            //TODO:选择优惠券、刷新table
            self.selectCoupon = self.coupons[index];
            [self.tableView reloadData];
        }];
    }else{
        self.couponController.contentType = TypeYearCard;
        self.couponController.dataArray = [NSMutableArray arrayWithArray:self.yearCards];
        @weakify(self);
        [self.couponController setSelectFinish:^(NSInteger index) {
            @strongify(self);
            self.couponController.cardIndex = index;
            [self hideSelectCouponController];
            //TODO:选择年卡、刷新table
            self.selectCard = self.yearCards[index];
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
    self.couponController.view.frame = CGRectMake(0, self.view.bounds.size.height, kScreen_Width, height);
    [self.view addSubview:self.couponController.view];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.couponController.view.frame = CGRectMake(0, self.view.bounds.size.height-height, kScreen_Width, height);
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
    
    __block int timeout = 15*60;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0*NSEC_PER_SEC, 0);//每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        
        if (timeout<=0) {
            
            dispatch_source_cancel(_timer);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSLog(@"计时结束");
                self.timeLbl.text = @"超过支付时间，无法支付";
                
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

@end
