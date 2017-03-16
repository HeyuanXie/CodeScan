//
//  PointManageController.m
//  Base
//
//  Created by admin on 2017/3/16.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "PointManageController.h"
#import "PointManageTopCell.h"
#import "PointManageBotCell.h"
#import "UITableViewCell+HYCell.h"

@interface PointManageController ()

@property(nonatomic,strong)NSMutableArray* dataArray;

@end

@implementation PointManageController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBarTransparent = YES;
    [self baseSetupTableView:UITableViewStylePlain InSets:UIEdgeInsetsMake(-64, 0, zoom(60), 0)];
    [self.tableView registerNib:[UINib nibWithNibName:[PointManageTopCell identify] bundle:nil] forCellReuseIdentifier:[PointManageTopCell identify]];
    [self.tableView registerNib:[UINib nibWithNibName:[PointManageBotCell identify] bundle:nil] forCellReuseIdentifier:[PointManageBotCell identify]];
    
    [self fetchData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - talbeView dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? 1 : self.dataArray.count+1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        PointManageTopCell* cell = [tableView dequeueReusableCellWithIdentifier:[PointManageTopCell identify]];
        [HYTool configTableViewCellDefault:cell];
        [cell configPointManageTopCell:nil];
        return cell;
    }
    
    PointManageBotCell* cell = [tableView dequeueReusableCellWithIdentifier:[PointManageBotCell identify]];
    [HYTool configTableViewCellDefault:cell];
    //设置圆角
    if (indexPath.row == 0) {
        UIView* view = cell.backView;
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(5, 5)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = view.bounds;
        maskLayer.path = maskPath.CGPath;
        view.layer.mask = maskLayer;
    }
    if (indexPath.row == self.dataArray.count) {
        UIView* view = cell.backView;
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(5, 5)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = view.bounds;
        maskLayer.path = maskPath.CGPath;
        view.layer.mask = maskLayer;
    }
    if (indexPath.row != self.dataArray.count) {
        [cell addLine:NO leftOffSet:12 rightOffSet:-12];
    }
    [cell configPointManageBotCell:nil indexPath:indexPath];
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView* headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, zoom(12))];
    headView.backgroundColor = [UIColor hyViewBackgroundColor];
    return section == 0 ? nil : headView;
}

#pragma mark - tableView delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 0 ? zoom(256) : zoom(47);
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? 0 : zoom(12);
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //TODO:
}
#pragma mark - private methods
-(NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

-(void)fetchData {
    self.dataArray = [@[@"",@"",@""] mutableCopy];
    [self.tableView reloadData];
}

#pragma mark - IBActions
- (IBAction)exchange:(id)sender {
    APPROUTE(kDeriveListController);
}

@end