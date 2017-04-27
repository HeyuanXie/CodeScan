//
//  YearCardHomeController.m
//  Base
//
//  Created by admin on 2017/3/9.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "YearCardHomeController.h"
#import "HomeTopCell.h"
#import "HomeSecondCell.h"
#import "HomeDescCell.h"
#import <UITableView+FDTemplateLayoutCell.h>
#import "UIViewController+Extension.h"

@interface YearCardHomeController ()

@property (nonatomic, strong)NSDictionary* data;
@property (nonatomic, assign)BOOL isFold;

@end

@implementation YearCardHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isFold = YES;  //默认为折叠
    [self baseSetupTableView:UITableViewStylePlain InSets:UIEdgeInsetsMake(0, 0, 90, 0)];
    [self.tableView registerNib:[UINib nibWithNibName:[HomeTopCell identify] bundle:nil] forCellReuseIdentifier:[HomeTopCell identify]];
    [self.tableView registerNib:[UINib nibWithNibName:[HomeSecondCell identify] bundle:nil] forCellReuseIdentifier:[HomeSecondCell identify]];
    [self.tableView registerNib:[UINib nibWithNibName:[HomeDescCell identify] bundle:nil] forCellReuseIdentifier:[HomeDescCell identify]];

    [self subviewInit];
    [self fetchData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - talbeView dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.data == nil ? 0 : 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
        {
            HomeTopCell* cell = [tableView dequeueReusableCellWithIdentifier:[HomeTopCell identify]];
            [HYTool configTableViewCellDefault:cell];
            [cell configTopCell:self.data];
            return cell;
        }
        case 1:
        {
            HomeSecondCell* cell = [tableView dequeueReusableCellWithIdentifier:[HomeSecondCell identify]];
            [HYTool configTableViewCellDefault:cell];
            [cell configSecondCell:self.data];
            return cell;
        }
        default:
        {
            HomeDescCell* cell = [tableView dequeueReusableCellWithIdentifier:[HomeDescCell identify]];
            [HYTool configTableViewCellDefault:cell];
            [cell setUnFoldBtnClick:^{
                self.isFold = !self.isFold;
                [self.tableView reloadData];
            }];
            cell.isFold = self.isFold;
            [cell configDescCell:self.data];
            return cell;
        }
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, zoom(15))];
    headerView.backgroundColor = [UIColor hyViewBackgroundColor];
    return section == 0 ? nil : headerView;
}
#pragma mark - tableView delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            return 304;
        case 1:
            return 110;
        default:
            if (!self.isFold) {
                return [tableView fd_heightForCellWithIdentifier:[HomeDescCell identify] cacheByIndexPath:indexPath configuration:^(HomeDescCell* cell) {
                    [HYTool configTableViewCellDefault:cell];
                    [cell setUnFoldBtnClick:^{
                        self.isFold = !self.isFold;
                        [self.tableView reloadData];
                    }];
                    cell.isFold = self.isFold;
                    [cell configDescCell:self.data];
                }];
            }else{
                return [tableView fd_heightForCellWithIdentifier:[HomeDescCell identify] configuration:^(HomeDescCell* cell) {
                    [HYTool configTableViewCellDefault:cell];
                    [cell setUnFoldBtnClick:^{
                        self.isFold = !self.isFold;
                        [self.tableView reloadData];
                    }];
                    cell.isFold = self.isFold;
                    [cell configDescCell:self.data];
                }];
            }
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? 0 : zoom(15);
}


#pragma mark - private methods
-(void)fetchData {
    [self showLoadingAnimation];
    [APIHELPER fetchYearCardInfoComplete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
        [self hideLoadingAnimation];
        if (isSuccess) {
            self.data = responseObject[@"data"];
            [self.tableView reloadData];
        }
    }];
}


-(void)subviewInit {
    [self configMessage];
}

#pragma mark - IBActions
- (IBAction)buyNow:(id)sender {
    
    if ([self checkUserLogined]) {
        [ROUTER routeByStoryboardID:kYearCardCommitOrderController withParam:self.data];
    }
}

- (IBAction)bindNow:(id)sender {
    
    if ([self checkUserLogined]) {
        APPROUTE(kYearCardBindController);
    }
}

@end
