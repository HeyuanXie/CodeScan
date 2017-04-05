//
//  MessageListController.m
//  Base
//
//  Created by admin on 2017/3/20.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "MessageListController.h"
#import "CustomJumpBtns.h"
#import "NSString+Extension.h"
#import "MessageOrderCell.h"
#import <UITableView+FDTemplateLayoutCell.h>

@interface MessageListController ()

@property(assign,nonatomic)NSInteger type;
@property(strong,nonatomic)NSMutableArray* dataArray;

@end

@implementation MessageListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.schemaArgu[@"type"]) {
        self.type = [[self.schemaArgu objectForKey:@"type"] integerValue];
    }
    
    [self baseSetupTableView:UITableViewStylePlain InSets:UIEdgeInsetsMake(0, 0, 0, 0)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tableView registerNib:[UINib nibWithNibName:[MessageOrderCell identify] bundle:nil] forCellReuseIdentifier:[MessageOrderCell identify]];

    [self subviewStyle];
    [self fetchData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - talbeView dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.type == 0 ? 1 : 2;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (self.type == 0) {//系统消息
        return [UITableViewCell new];
    }
    
    //订单消息
    if (indexPath.row == 0) {
        MessageOrderCell* cell = [tableView dequeueReusableCellWithIdentifier:[MessageOrderCell identify]];
        [HYTool configTableViewCellDefault:cell];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        
        //TODO:
        [cell configMessageOrderCell:nil];
        return cell;
    }else{
        static NSString* cellId = @"orderBotCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
            [HYTool configTableViewCellDefault:cell];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.contentView.backgroundColor = [UIColor whiteColor];
            
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.textLabel.textColor = [UIColor hyGrayTextColor];
            
            cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
            cell.detailTextLabel.textColor = [UIColor hyBlackTextColor];
        }
        cell.textLabel.text = @"2017-02-23 14:00";
        cell.detailTextLabel.text = @"查看详情";
        return cell;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, zoom(15))];
    footerView.backgroundColor = [UIColor hyViewBackgroundColor];
    return footerView;
}

#pragma mark - tableView delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.type == 0) {
        return 0;
    }
    return indexPath.row == 0 ? [tableView fd_heightForCellWithIdentifier:[MessageOrderCell identify] cacheByIndexPath:indexPath configuration:^(MessageOrderCell* cell) {
        
        [cell configMessageOrderCell:nil];
    }] : zoom(40);
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return section == self.dataArray.count-1 ? 0 : zoom(15);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.type == 0) {
        return;
    }
    if (indexPath.row == 1) {
        APPROUTE(([NSString stringWithFormat:@"%@?contentType=%d&orderId=%@",kOrderDetailController,0,@"orderId"]));
    }
}
#pragma mark - private methods
-(NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

-(void)subviewStyle {
    
    self.title = self.type == 0 ? @"系统消息" : @"订单消息";
}

-(void)fetchData {
    self.dataArray = [@[@"",@"",@"",@"",@""] mutableCopy];
    //TODO:根据self.cellType请求数据
    
    [self.tableView reloadData];
}

@end
