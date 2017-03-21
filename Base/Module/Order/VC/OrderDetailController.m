//
//  OrderDetailController.m
//  Base
//
//  Created by admin on 2017/3/20.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "OrderDetailController.h"
#import "OrderDetailHeadCell.h"
#import "OrderRefundCell.h"
#import "OrderCodeCell.h"
#import "OrderDetailCell.h"

#import "UIViewController+Extension.h"

@interface OrderDetailController ()

@property(strong,nonatomic)NSMutableArray* codeArray;
@property(strong,nonatomic)NSString* type;  //订单类型
@property(assign,nonatomic)NSInteger Id;    //订单Id

@property(strong,nonatomic)NSArray* maps;//手机安装的地图的数组
@end

@implementation OrderDetailController

- (void)viewDidLoad {
    [super viewDidLoad];

    if (self.schemaArgu[@"type"]) {
        self.type = [self.schemaArgu objectForKey:@"type"];
    }
    if (self.schemaArgu[@"Id"]) {
        self.Id = [[self.schemaArgu objectForKey:@"Id"] integerValue];
    }
    [self baseSetupTableView:UITableViewStylePlain InSets:UIEdgeInsetsMake(0, 0, 0, 0)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tableView registerNib:[UINib nibWithNibName:[OrderDetailHeadCell identify] bundle:nil] forCellReuseIdentifier:[OrderDetailHeadCell identify]];
    [self.tableView registerNib:[UINib nibWithNibName:[OrderRefundCell identify] bundle:nil] forCellReuseIdentifier:[OrderRefundCell identify]];
    [self.tableView registerNib:[UINib nibWithNibName:[OrderCodeCell identify] bundle:nil] forCellReuseIdentifier:[OrderCodeCell identify]];
    [self.tableView registerNib:[UINib nibWithNibName:[OrderDetailCell identify] bundle:nil] forCellReuseIdentifier:[OrderDetailCell identify]];

    
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
    if (section == 2) {
        return self.codeArray.count;
    }else{
        return 2;
    }
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
            return [self codeCellForTableView:tableView indexPath:indexPath];
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
        return [height[2][0] floatValue];
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
        //TODO:打开地图
        [self geocoderClick:@"东莞玉兰大剧院"];
        return;
    }
    if (indexPath.section == 2) {
        //TODO:跳到二维码页面,传递参数
        APPROUTE(([NSString stringWithFormat:@"%@?Id=%d",kOrderCodeController,0]))
        return;
    }
}
#pragma mark - private methods
-(UITableViewCell*)headCellForTableView:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath {
    OrderDetailHeadCell* cell = [tableView dequeueReusableCellWithIdentifier:[OrderDetailHeadCell identify]];
    [HYTool configTableViewCellDefault:cell];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    
    if ([self.type isEqualToString:@"theater"]) {
        [cell configTheaterHeadCell:nil];
    }else if ([self.type isEqualToString:@"lecture"]) {
        [cell configLectureHeadCell:nil];
    }else if ([self.type isEqualToString:@"derive"]) {
        [cell configDeriveHeadCell:nil];
    }else{
        [cell configYearCardHeadCell:nil];
    }
    return cell;
}
-(UITableViewCell*)refundCellForTableView:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath {
    OrderRefundCell* cell = [tableView dequeueReusableCellWithIdentifier:[OrderRefundCell identify]];
    if ([self.type isEqualToString:@"derive"]) {
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
    
    lbl.text = @"有效期至: 2017-4-30";
    
    if ([self.type isEqualToString:@"derive"]) {
        [btn setTitle:@"去评价" forState:UIControlStateNormal];
        [btn bk_whenTapped:^{
            //TODO:评价
        }];
    }else{
        [btn bk_whenTapped:^{
            //TODO:退款
        }];
    }
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
        
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 11.5, 25, 25)];
        imageView.image = ImageNamed(@"定位");
        UILabel* lbl = [HYTool getLabelWithFrame:CGRectMake(40, 0, kScreen_Width, 48) text:@"" fontSize:15 textColor:[UIColor hyBlueTextColor] textAlignment:NSTextAlignmentLeft];
        lbl.tag = 1000;
        [cell.contentView addSubview:imageView];
        [cell.contentView addSubview:lbl];
    }
    UILabel* lbl = [cell.contentView viewWithTag:1000];
    lbl.text = @"东莞玉兰大剧场";
    return cell;
}
-(UITableViewCell*)codeCellForTableView:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath {
    OrderCodeCell*cell = [tableView dequeueReusableCellWithIdentifier:[OrderCodeCell identify]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    [cell configCodeCell:nil];
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
    [cell configDetailCell:nil];
    return cell;
}
-(NSMutableArray *)codeArray {
    if (!_codeArray) {
        _codeArray = [NSMutableArray array];
    }
    return _codeArray;
}

-(void)fetchData {
    self.codeArray = [@[@"",@""] mutableCopy];
    [self.tableView reloadData];
}
@end
