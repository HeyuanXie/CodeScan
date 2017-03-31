//
//  TheaterCommitOrderSuccessController.m
//  Base
//
//  Created by admin on 2017/3/28.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "TheaterCommitOrderSuccessController.h"
#import <UITableView+FDTemplateLayoutCell.h>
#import "CommitOrderSuccessCell.h"
#import "CommitOrderSuccessCell2.h"

@interface TheaterCommitOrderSuccessController ()

@property(nonatomic,strong)NSMutableArray* infos;
@property(nonatomic,strong)NSMutableDictionary* data;

@end

@implementation TheaterCommitOrderSuccessController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.schemaArgu[@"contentType"]) {
        self.contentType = [[self.schemaArgu objectForKey:@"contentType"] integerValue];
    }
    self.data = [NSMutableDictionary dictionary];
    for (NSString* key in @[@"thumb_img",@"goods_name",@"total_price",@"exchange_place",@"order_sn"]) {
        [self.data setValue:[self.schemaArgu objectForKey:key] forKey:key];
    }

    [self baseSetupTableView:UITableViewStylePlain InSets:UIEdgeInsetsZero];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tableView registerNib:[UINib nibWithNibName:[CommitOrderSuccessCell identify] bundle:nil] forCellReuseIdentifier:[CommitOrderSuccessCell identify]];
    [self.tableView registerNib:[UINib nibWithNibName:[CommitOrderSuccessCell2 identify] bundle:nil] forCellReuseIdentifier:[CommitOrderSuccessCell2 identify]];
    
    [self fetchData];
    [self subviewStyle];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - talbeView dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.infos.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        switch (self.contentType) {
            case TypeTheater:
            {
                CommitOrderSuccessCell* cell = [tableView dequeueReusableCellWithIdentifier:[CommitOrderSuccessCell identify]];
                [HYTool configTableViewCellDefault:cell];
                cell.contentView.backgroundColor = [UIColor whiteColor];
                [cell configTheaterCell:self.data];
                return cell;
            }
            case TypeDerive:
            {
                CommitOrderSuccessCell2* cell = [tableView dequeueReusableCellWithIdentifier:[CommitOrderSuccessCell2 identify]];
                [HYTool configTableViewCellDefault:cell];
                cell.contentView.backgroundColor = [UIColor whiteColor];
                
                [cell configDeriveCell:self.data];
                return cell;
            }
            default:
                return [UITableViewCell new];
        }
    }else{
        static NSString* cellId = @"botCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            [HYTool configTableViewCellDefault:cell];
            cell.contentView.backgroundColor = [UIColor whiteColor];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            cell.textLabel.textColor = [UIColor hyBarTintColor];
        }
        NSString* text = @"";
        switch (self.contentType) {
            case TypeTheater:
                text = @"立即使用";
                break;
            case TypeDerive:
                text = @"查看订单详情";
                break;
            default:
                break;
        }
        cell.textLabel.text = text;
        return cell;
    }
}

#pragma mark - tableView delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        return 50;
    }
    switch (self.contentType) {
        case TypeTheater:
            return [tableView fd_heightForCellWithIdentifier:[CommitOrderSuccessCell identify] cacheByIndexPath:indexPath configuration:^(CommitOrderSuccessCell* cell) {
                
                [cell configTheaterCell:nil];
            }];
        case TypeDerive:
            return 127;
        default:
            return 0;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section != 1) {
        return;
    }
    switch (self.contentType) {
        case TypeTheater:
            
            break;
        case TypeDerive:
            APPROUTE(([NSString stringWithFormat:@"%@?orderId=%@&type=%@",kOrderDetailController,self.data[@"order_sn"],@"derive"]));
            break;
        default:
            break;
    }
}
#pragma mark - private methods
-(NSMutableArray *)infos {
    if (!_infos) {
        _infos = [NSMutableArray array];
    }
    return _infos;
}

-(void)subviewStyle {
    
    
    NSInteger index = 100;
    switch (self.contentType) {
        case TypeTheater:
            index = 4;
            self.title = @"下单成功";
            break;
        case TypeDerive:
            index = 5;
            self.title = @"兑换成功";
            break;
        default:
            break;
    }
    UIView* headView = LOADNIB(@"TheaterUseView", index);
    self.tableView.tableHeaderView = headView;
}

-(void)fetchData {
    [self.infos addObject:@""];
    [self.infos addObject:@""];
    [self.tableView reloadData];
}

@end
