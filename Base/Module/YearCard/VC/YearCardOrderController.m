//
//  YearCardOrderController.m
//  Base
//
//  Created by admin on 2017/3/21.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "YearCardOrderController.h"
#import "OrderTopCell.h"
#import "OrderRefundCell.h"
#import "YearCardOrderCommonCell.h"
#import "OrderDetailCell.h"
#import "YearCardDescCell.h"

@interface YearCardOrderController ()

@property(nonatomic,strong)NSArray* infos;
@property(nonatomic,assign)BOOL canSee;

@end

@implementation YearCardOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self baseSetupTableView:UITableViewStylePlain InSets:UIEdgeInsetsMake(0, 0, 0, 0)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tableView registerNib:[UINib nibWithNibName:[OrderTopCell identify] bundle:nil] forCellReuseIdentifier:[OrderTopCell identify]];
    [self.tableView registerNib:[UINib nibWithNibName:[OrderRefundCell identify] bundle:nil] forCellReuseIdentifier:[OrderRefundCell identify]];
    [self.tableView registerNib:[UINib nibWithNibName:[YearCardOrderCommonCell identify] bundle:nil] forCellReuseIdentifier:[YearCardOrderCommonCell identify]];
    [self.tableView registerNib:[UINib nibWithNibName:[OrderDetailCell identify] bundle:nil] forCellReuseIdentifier:[OrderDetailCell identify]];
    [self.tableView registerNib:[UINib nibWithNibName:[YearCardDescCell identify] bundle:nil] forCellReuseIdentifier:[YearCardDescCell identify]];

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
    return section == 1 ? 4 : 2;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            if (indexPath.row == 0) {
                OrderTopCell* cell = [tableView dequeueReusableCellWithIdentifier:[OrderTopCell identify]];
                //TODO:configCell
                
                [cell configTopCell:nil];
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
                        //TODO:退款
                        
                    }];
                    btn.tag = 1000;
                    [HYTool configViewLayer:btn withColor:[UIColor hyBlueTextColor]];
                    [cell.contentView addSubview:btn];
                    
                    UILabel* label = [HYTool getLabelWithFrame:CGRectMake(12, 0, 60, 48) text:@"未使用" fontSize:15 textColor:[UIColor hyRedColor] textAlignment:NSTextAlignmentLeft];
                    label.tag = 1001;
                    [cell.contentView addSubview:label];
                }
                UIButton* btn = [cell.contentView viewWithTag:1000];
                UILabel* lbl = [cell.contentView viewWithTag:10001];
                //TODO:根据订单状态设置是否隐藏btn，和lbl的文字
                
                return cell;
            }else if (indexPath.row == 1) {
                YearCardOrderCommonCell* cell = [tableView dequeueReusableCellWithIdentifier:[YearCardOrderCommonCell identify]];
                
                [cell configYearCardOrderCommonCell:nil];
                return cell;
            }else if (indexPath.row == 2) {
                YearCardOrderCommonCell* cell = [tableView dequeueReusableCellWithIdentifier:[YearCardOrderCommonCell identify]];
                [cell configYearCardOrderCommonEyeCell:nil];
                cell.textField.secureTextEntry = !self.canSee;
                NSString* imageName = self.canSee ? @"密码可见" : @"密码不可见";
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
                            if (i == 0) {
                                //TODO:转增
                                NSLog(@"转增");
                            }else{
                                NSLog(@"立即绑定");
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
                label.text = @"年卡说明";
                return cell;
            }else{
                
                OrderDetailCell* cell = [tableView dequeueReusableCellWithIdentifier:[OrderDetailCell identify]];
                [HYTool configTableViewCellDefault:cell];
                cell.contentView.backgroundColor = [UIColor whiteColor];
                [cell configDetailCell:nil type:@"card"];
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
    
    NSArray* height = @[@[@(128),@(40)],@[@(48),@(48),@(48),@(50)],@[@(48),@(124)],@[@(48),@(142)]];
    return [height[indexPath.section][indexPath.row] floatValue];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return zoom(15);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark - private methods
-(void)fetchData {
    
    [self.tableView reloadData];
}

@end
