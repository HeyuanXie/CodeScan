//
//  ScanResultContoller.m
//  Base
//
//  Created by admin on 2017/5/9.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "ScanResultContoller.h"
#import "ResultTopCell.h"
#import "ResultTicketCell.h"
#import "ResultBotCell.h"
#import "HYAlertView.h"

#import "UITableViewCell+HYCell.h"

@interface ScanResultContoller ()

/**
 选择要打印的票
 */
@property(nonatomic,strong)NSMutableArray* selectTickets;
//是否全选
@property(nonatomic,assign)BOOL isAllSelect;

@property(nonatomic,assign)NSInteger avilableCount; //未打印的票数

@end

@implementation ScanResultContoller

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self baseSetupTableView:UITableViewStylePlain InSets:UIEdgeInsetsZero];
    [self.tableView registerNib:[UINib nibWithNibName:[ResultTopCell identify] bundle:nil] forCellReuseIdentifier:[ResultTopCell identify]];
    [self.tableView registerNib:[UINib nibWithNibName:[ResultTicketCell identify] bundle:nil] forCellReuseIdentifier:[ResultTicketCell identify]];
    [self.tableView registerNib:[UINib nibWithNibName:[ResultBotCell identify] bundle:nil] forCellReuseIdentifier:[ResultBotCell identify]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: YES];
    
    [self caculateAvilableCount];
    [self.tableView reloadData];
}

#pragma mark - tableView dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tickets.count+2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==0) {
        //topCell
        ResultTopCell* cell = [tableView dequeueReusableCellWithIdentifier:[ResultTopCell identify]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.allBtn.hidden = !self.haveTicketAvilable;
        if (self.orderType == 1) {
            [cell configTheaterCell:self.data];
            [cell setAllBtnClick:^{
                //TODO:全选
                self.isAllSelect = !self.isAllSelect;
                [self.selectTickets removeAllObjects];
                if (self.isAllSelect) {
                    for (NSDictionary* dict in self.tickets) {
                        if ([dict[@"status"] integerValue] == 0) {
                            [self.selectTickets addObject:dict[@"rec_id"]];
                        }
                    }
                    [self.tableView reloadData];
                }else{
                    [self.tableView reloadData];
                }
                
            }];
        }else{
            [cell configDeriveCell:self.data];
        }
        [cell addLine:NO leftOffSet:12 rightOffSet:0];
        return cell;
    }else if (indexPath.row == self.tickets.count+1) {
        //botCell
        ResultBotCell* cell = [tableView dequeueReusableCellWithIdentifier:[ResultBotCell identify]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.orderType == 1) {
            [cell.btn setTitle:@"验票" forState:UIControlStateNormal];
            cell.btn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
                if (!self.haveTicketAvilable) {
                    [self showMessage:@"没有可使用的票"];
                    return [RACSignal empty];
                }
                [APIHELPER printTicket:[self.data[@"order_id"] integerValue] seatIds:self.selectTickets complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
                    if (isSuccess) {
                        [self.delegate actionSucceedAfterScan];
                    }else{
                        [self showMessage:error.userInfo[NSLocalizedDescriptionKey]];
                    }
                }];
                return [RACSignal empty];
            }];
        }else{
            [cell.btn setTitle:@"确认领取" forState:UIControlStateNormal];
            cell.btn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
                if ([self.data[@"status"] integerValue] == 1) {
                    [self showMessage:@"商品无法重复兑换"];
                    return [RACSignal empty];
                }
                [APIHELPER deriveExchange:[self.data[@"order_id"] integerValue] complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
                    if (isSuccess) {
                        [self.delegate actionSucceedAfterScan];
                    }else{
                        [self showMessage:error.userInfo[NSLocalizedDescriptionKey]];
                    }
                }];
                return [RACSignal empty];
            }];
        }
        return cell;
    }else{
        //ticketCell
        ResultTicketCell* cell = [tableView dequeueReusableCellWithIdentifier:[ResultTicketCell identify]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSDictionary* data = self.tickets[indexPath.row-1];
        [cell configTicketCell:data];
        for (NSNumber* seatId in self.selectTickets) {
            if ([data[@"rec_id"] integerValue] == seatId.integerValue) {
                cell.selectBtn.selected = YES;
                [cell.selectBtn setImage:ImageNamed(@"已选择") forState:UIControlStateNormal];
            }
        }
        @weakify(cell);
        [cell setSelectBtnClick:^{
            @strongify(cell);
            cell.selectBtn.selected = !cell.selectBtn.selected;
            if (cell.selectBtn.selected) {
                [self.selectTickets addObject:data[@"rec_id"]];
            }else{
                [self.selectTickets removeObject:data[@"rec_id"]];
            }
            self.isAllSelect = self.avilableCount == self.selectTickets.count;
            [self.tableView reloadData];
        }];
        [cell addLine:NO leftOffSet:indexPath.row == self.tickets.count ? 0 : 12 rightOffSet:0];
        return cell;
    }
}

#pragma mark - tableView delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==0) {
        //topCell
        if (self.orderType == 3) {
            return 100;
        }else{
            return self.haveTicketAvilable == YES ? 122 : 100;
        }
    }else if (indexPath.row == self.tickets.count+1) {
        //botCell
        return 60;
    }else{
        //ticketCell
        return 48;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.orderType != 1) {
        return;
    }
    if (indexPath.row==0) {
        return;
    }else if (indexPath.row == self.tickets.count+1) {
        return;
    }else{
        NSDictionary* data = self.tickets[indexPath.row-1];
        if ([data[@"status"] integerValue] == 1) {
            return;
        }
        ResultTicketCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.selectBtn.selected = !cell.selectBtn.selected;
        if (cell.selectBtn.selected) {
            [self.selectTickets addObject:data[@"rec_id"]];
        }else{
            [self.selectTickets removeObject:data[@"rec_id"]];
        }
        self.isAllSelect = self.avilableCount == self.selectTickets.count;
        [self.tableView reloadData];
    }

}


#pragma mark - private methods
- (NSMutableArray *)selectTickets {
    if (!_selectTickets) {
        _selectTickets = [NSMutableArray array];
    }
    return _selectTickets;
}

- (void)caculateAvilableCount {
    self.avilableCount = 0;
    for (NSDictionary* dict in self.tickets) {
        if ([dict[@"status"] integerValue] == 0) {
            self.avilableCount ++;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
