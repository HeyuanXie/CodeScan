//
//  OrderRefundController.m
//  Base
//
//  Created by admin on 2017/3/28.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "OrderRefundController.h"
#import "RefundHeadCell.h"
#import "NSString+Extension.h"


typedef enum : NSUInteger {
    TypeTheater = 0,
    TypeCard,
} ContentType;

@interface OrderRefundController ()

@property(nonatomic, strong)NSArray* infos;

@property(nonatomic,weak)IBOutlet UIButton *commitBtn;

@property(nonatomic,assign)NSInteger orderId;
@property(nonatomic,assign)ContentType contentType;
@property(nonatomic,strong)NSDictionary* data;

@end

@implementation OrderRefundController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.schemaArgu[@"orderId"]) {
        self.orderId = [[self.schemaArgu objectForKey:@"orderId"] integerValue];
    }
    if (self.schemaArgu[@"contentType"]) {
        self.contentType = [[self.schemaArgu objectForKey:@"contentType"] integerValue];
    }
    self.infos = @[@[@{@"title":@"退款项"}],
                   @[@{@"title":@"退款金额:",@"detail":@"80元(已扣减手续费:20.0元)"},
                     @{@"title":@"退还账户:",@"detail":@"微信账户"},
                     @{@"title":@"到账时间:",@"detail":@"7个工作日内"}
                     ]
                   ];
    
    [self baseSetupTableView:UITableViewStylePlain InSets:UIEdgeInsetsMake(0, 0, 60, 0)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tableView registerNib:[UINib nibWithNibName:[RefundHeadCell identify] bundle:nil] forCellReuseIdentifier:[RefundHeadCell identify]];
    
    [self fetchData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - talbeView dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.data == nil ? 0 : self.infos.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ((NSArray*)self.infos[section]).count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
        {
            RefundHeadCell* cell = [tableView dequeueReusableCellWithIdentifier:[RefundHeadCell identify]];
            [HYTool configTableViewCellDefault:cell];
            cell.contentView.backgroundColor = [UIColor whiteColor];
            [cell configHeadCell:self.data];
            return cell;
        }
            
        default:
        {
            static NSString* cellId = @"commonCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
                [HYTool configTableViewCellDefault:cell];
                cell.contentView.backgroundColor = [UIColor whiteColor];
                
                UILabel* leftLbl = [HYTool getLabelWithFrame:CGRectMake(12, 0, 70, 50) text:@"" fontSize:15 textColor:[UIColor hyBlackTextColor] textAlignment:NSTextAlignmentLeft];
                UILabel* rightLbl = [HYTool getLabelWithFrame:CGRectMake(12+70+2, 0, kScreen_Width-12-70-2-12, 50) text:@"" fontSize:15 textColor:[UIColor hyBlackTextColor] textAlignment:NSTextAlignmentLeft];
                [cell.contentView addSubview:leftLbl];
                [cell.contentView addSubview:rightLbl];
                leftLbl.tag = 1000;
                rightLbl.tag = 1001;
            }
            UILabel* leftLbl = (UILabel*)[cell.contentView viewWithTag:1000];
            UILabel* rightLbl = (UILabel*)[cell.contentView  viewWithTag:1001];
            leftLbl.text = self.infos[indexPath.section][indexPath.row][@"title"];
            rightLbl.text = self.infos[indexPath.section][indexPath.row][@"detail"];
            NSString* rightStr = [NSString stringWithFormat:@"%.2f元 (已扣减手续费: %.2f元)",[self.data[@"refund_amount"] floatValue],[self.data[@"handle_fee"] floatValue]];
            if (indexPath.row == 0) {
                rightLbl.attributedText = [rightStr addAttribute:@[NSFontAttributeName,NSForegroundColorAttributeName,NSFontAttributeName] values:@[[UIFont systemFontOfSize:12],[UIColor hyRedColor],[UIFont systemFontOfSize:17]] subStrings:@[rightLbl.text,rightLbl.text,[NSString stringWithFormat:@"%.2f",[self.data[@"refund_amount"] floatValue]]]];
            } else if (indexPath.row == 1) {
                rightLbl.text = self.data[@"return_account"];
            } else {
                rightLbl.text = self.data[@"return_time"];
            }
            return cell;
        }
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView* headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, zoom(15))];
    headView.backgroundColor = [UIColor hyViewBackgroundColor];
    return section == 0 ? nil : headView;
}

#pragma mark - tableView delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 0 ? 124 : 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? 0 : zoom(15);
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
#pragma mark - private methods
-(void)subviewStyle {
    
    UIView* footView = LOADNIB(@"OrderUseView", 0);
    footView.frame = CGRectMake(0, 0, kScreen_Width, 50);
    footView.backgroundColor = [UIColor hyViewBackgroundColor];
    UILabel* lbl = [footView viewWithTag:1000];
    lbl.text = self.data[@"note"];
    self.tableView.tableFooterView = footView;
    
    [self.commitBtn bk_whenTapped:^{
        //提交退款申请
        if (self.contentType == TypeTheater) {
            [APIHELPER theaterRefundWithOrderId:self.orderId complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
                if (isSuccess) {
                    APPROUTE(kOrderRefundSuccessController);
                }else{
                    [self showMessage:error.userInfo[NSLocalizedDescriptionKey]];
                }
            }];
        }else{
            [APIHELPER cardRefundWithOrderId:self.orderId complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
                if (isSuccess) {
                    APPROUTE(kOrderRefundSuccessController);
                }else{
                    [self showMessage:error.userInfo[NSLocalizedDescriptionKey]];
                }
            }];
        }
    }];
}

-(void)fetchData {
    
    if (self.contentType == TypeTheater) {
        [APIHELPER theaterRefundInfoWithOrderId:self.orderId complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
            if (isSuccess) {
                self.data = responseObject[@"data"];
                [self subviewStyle];
                [self.tableView reloadData];
            }else{
                [self showMessage:error.userInfo[NSLocalizedDescriptionKey]];
            }
        }];
    }else{
        [APIHELPER cardRefundInfoWithOrderId:self.orderId complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
            if (isSuccess) {
                self.data = responseObject[@"data"];
                [self subviewStyle];
                [self.tableView reloadData];
            }else{
                [self showMessage:error.userInfo[NSLocalizedDescriptionKey]];
            }
        }];
    }
}

@end
