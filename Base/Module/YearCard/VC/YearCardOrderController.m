//
//  YearCardOrderController.m
//  Base
//
//  Created by admin on 2017/3/9.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "YearCardOrderController.h"
#import "NSString+Extension.h"

@interface YearCardOrderController ()

@property (weak, nonatomic) IBOutlet UILabel *totalLbl;

@property (strong, nonatomic) NSMutableArray* payMethods;
@property (assign, nonatomic) NSInteger selectIndex;    //记录选择的支付方式

@end

@implementation YearCardOrderController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self baseSetupTableView:UITableViewStylePlain InSets:UIEdgeInsetsMake(0, 0, 60, 0)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self subviewInit];
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
                static NSString* cellId = @"topCell";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
                if (cell == nil) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
                    [HYTool configTableViewCellDefault:cell];
                    cell.contentView.backgroundColor = [UIColor whiteColor];
                    
                    cell.imageView.image = ImageNamed(@"yazi");
                    cell.textLabel.text = @"飞翔卡1+1家庭年卡";
                    UILabel* lbl = [HYTool getLabelWithFrame:CGRectZero text:@"一年12次,每次限2人" fontSize:15 textColor:[UIColor hyGrayTextColor] textAlignment:NSTextAlignmentLeft];
                    [cell.contentView addSubview:lbl];
                    [lbl autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:cell.imageView];
                    [lbl autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:cell.textLabel];
                    [lbl autoPinEdgeToSuperviewEdge:ALEdgeRight];
                    [lbl autoSetDimension:ALDimensionHeight toSize:20];
                }
                return cell;
            }else{
                static NSString* cellId = @"commonCell";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
                if (cell == nil) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
                    [HYTool configTableViewCellDefault:cell];
                    cell.contentView.backgroundColor = [UIColor whiteColor];
                    
                    cell.textLabel.text = @"数量: 1张";
                    cell.textLabel.textColor = [UIColor hyBlackTextColor];
                    cell.textLabel.font = [UIFont systemFontOfSize:15];
                    NSString* str = @"合计: ¥99";
                    cell.detailTextLabel.text = @"合计: ¥99";
                    
                    cell.detailTextLabel.textColor = [UIColor hyGrayTextColor];
                    cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                }
            }
        case 1:
        {
            static NSString* cellId = @"commonCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
                [HYTool configTableViewCellDefault:cell];
                cell.contentView.backgroundColor = [UIColor whiteColor];
                
                cell.textLabel.text = @"优惠券";
                cell.textLabel.textColor = [UIColor hyBlackTextColor];
                cell.textLabel.font = [UIFont systemFontOfSize:15];
                cell.detailTextLabel.text = @"没有可用优惠券";
                cell.detailTextLabel.textColor = [UIColor hyGrayTextColor];
                cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
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
                
                UIButton* selectBtn = [HYTool getButtonWithFrame:CGRectZero title:nil titleSize:0 titleColor:nil backgroundColor:[UIColor clearColor] blockForClick:nil];
                [selectBtn setImage:ImageNamed(@"on") forState:UIControlStateSelected];
                [selectBtn setImage:ImageNamed(@"off") forState:UIControlStateNormal];
                selectBtn.tag = 1000 + indexPath.row;
                [cell.contentView addSubview:selectBtn];
                [selectBtn autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0) excludingEdge:ALEdgeLeft];
                [selectBtn autoSetDimension:ALDimensionWidth toSize:48];
            }
            UIButton* selectBtn = [cell.contentView viewWithTag:1000+indexPath.row];
            selectBtn.selected = indexPath.row == self.selectIndex;
            selectBtn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
                self.selectIndex = indexPath.row;
                [self.tableView reloadSections:[[NSIndexSet alloc] initWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
                return [RACSignal empty];
            }];
            if (indexPath.row == 0) {
                selectBtn.hidden = YES;
                cell.textLabel.text = @"支付方式";
                cell.textLabel.textColor = [UIColor blackColor];
            }else{
                selectBtn.hidden = NO;
                cell.imageView.image = ImageNamed(@"cart");
                cell.textLabel.text = self.payMethods[indexPath.row];
                cell.textLabel.textColor = [UIColor hyBlackTextColor];
            }
            return cell;
        }
    }
}

#pragma mark - tableView delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            return indexPath.row == 0 ? 128 : 50;
        case 1:
            return 50;
        default:
            return indexPath.row == 0 ? 50 : 68;
    }
}


#pragma mark - IBActions
- (IBAction)commitOrder:(id)sender {
    
}

#pragma mark - private methods
-(NSMutableArray *)payMethods {
    if (!_payMethods) {
//        _payMethods = [NSMutableArray array];
        _payMethods = [@[@"支付方式",@"微信支付",@"支付宝支付"] mutableCopy];
    }
    return _payMethods;
}

-(void)subviewInit {
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
