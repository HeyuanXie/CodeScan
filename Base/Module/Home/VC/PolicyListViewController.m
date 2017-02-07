//
//  PolicyListViewController.m
//  Base
//
//  Created by admin on 2017/2/6.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "PolicyListViewController.h"
#import "HomeNewsCell.h"
#import "GuideTableViewCell.h"
#import "DemandTableViewCell.h"

#import <UITableView+FDTemplateLayoutCell.h>
#import "ZMDArticle.h"
#import "ZMDDemand.h"
#import "APIHelper+Policy.h"

@interface PolicyListViewController ()

@property(nonatomic,strong)NSMutableArray* dataArray;

@end

@implementation PolicyListViewController

-(NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.schemaArgu[@"type"]) {
        self.type = [[self.schemaArgu objectForKey:@"type"] integerValue];
    }
    [self baseSetupTableView:UITableViewStylePlain InSets:UIEdgeInsetsMake(0, 0, 0, 0)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self subviewInit];
    [self fetchData];
}

-(void)subviewInit {
    
    switch (self.type) {
        case TYPEPolicy:
            self.title = @"人才政策";
            break;
        case TYPEGuide:
            self.title = @"办事指南";
            break;
        case TYPEDemand:
            self.title = @"人才需求";
            break;
        default:
            break;
    }
    
    [self.tableView registerNib:[UINib nibWithNibName:[HomeNewsCell identify] bundle:nil] forCellReuseIdentifier:[HomeNewsCell identify]];
    [self.tableView registerNib:[UINib nibWithNibName:[GuideTableViewCell identify] bundle:nil] forCellReuseIdentifier:[GuideTableViewCell identify]];
    [self.tableView registerNib:[UINib nibWithNibName:[DemandTableViewCell identify] bundle:nil] forCellReuseIdentifier:[DemandTableViewCell identify]];
    if (self.type != TYPEGuide) {
        [self appendHeaderRefresh];
    }
}

-(void)fetchData {
    switch (self.type) {
        case TYPEPolicy:
        {
            [APIHELPER fetchPolicyListWithCateId:0 start:self.dataArray.count limit:10 completeBlock:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
                if (isSuccess) {
                    NSArray* models = [NSArray yy_modelArrayWithClass:[ZMDArticle class] json:responseObject[@"data"][@"list"]];
                    [self.dataArray addObjectsFromArray:models];
                    if (models.count == 10) {
                        [self appendFooterRefresh];
                    }else{
                        [self removeFooterRefresh];
                    }
                    [self.tableView reloadData];
                }else{
                    [self showMessage:responseObject[@"msg"]];
                }
                [self endRefreshing];
            }];
            break;
        }
        case TYPEGuide:
            break;
        case TYPEDemand:
        {
            [APIHELPER fetchDemandListWithStart:self.dataArray.count limit:10 completeBlock:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
                if (isSuccess) {
                    NSArray* arr = [NSArray yy_modelArrayWithClass:[ZMDDemand class] json:responseObject[@"data"][@"list"]];
                    [self.dataArray addObjectsFromArray:arr];
                    if (responseObject[@"data"][@"has_next"]) {
                        [self appendFooterRefresh];
                    }else{
                        [self removeFooterRefresh];
                    }
                    [self.tableView reloadData];
                }else{
                    [self showMessage:responseObject[@"msg"]];
                }
                [self endRefreshing];
            }];
        }
        default:
            break;
    }
}

-(void)appendHeaderRefresh {
    [self.dataArray removeAllObjects];
    @weakify(self);
    [self addHeaderRefresh:^{
        @strongify(self);
        [self fetchData];
    }];
}
-(void)appendFooterRefresh {
    @weakify(self);
    [self addFooterRefresh:^{
        @strongify(self);
        [self fetchData];
    }];
//    @weakify(self);
//    [self addFooterRefresh:^{
//        @strongify(self);
//        switch (self.type) {
//            case TYPEPolicy:
//            {
//                
//                break;
//            }
//            case TYPEDemand:
//            {
//                [APIHELPER fetchDemandListWithStart:self.dataArray.count limit:10 completeBlock:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
//                    if (isSuccess) {
//                        NSArray* arr = [NSArray yy_modelArrayWithClass:[ZMDDemand class] json:responseObject[@"data"][@"list"]];
//                        [self.dataArray addObjectsFromArray:arr];
//                        if (responseObject[@"data"][@"has_next"]) {
//                            [self appendFooterRefresh];
//                        }else{
//                            [self removeFooterRefresh];
//                        }
//                        [self.tableView reloadData];
//                    }else{
//                        [self showMessage:responseObject[@"msg"]];
//                    }
//                    [self endRefreshing];
//                }];
//                break;
//            }
//            default:
//                break;
//        }
//    }];
}

#pragma mark - TableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.type == TYPEGuide) {
        return 1;
    }
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (self.type) {
        case TYPEPolicy: {
            HomeNewsCell* cell = [tableView dequeueReusableCellWithIdentifier:[HomeNewsCell identify]];
            ZMDArticle* policy = self.dataArray[indexPath.row];
            [cell configCellWithModel:policy];
            return cell;
        }
        case TYPEGuide: {
            GuideTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:[GuideTableViewCell identify]];
            [cell configCell];
            return cell;
        }
        case TYPEDemand: {
            DemandTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:[DemandTableViewCell identify]];
            ZMDDemand* model = self.dataArray[indexPath.row];
            [cell config:model];
            return cell;
        }
        default:
            return [[UITableViewCell alloc] init];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (self.type) {
        case TYPEPolicy:
            return [tableView fd_heightForCellWithIdentifier:[HomeNewsCell identify] cacheByIndexPath:indexPath configuration:^(HomeNewsCell* cell) {
                ZMDArticle* policy = self.dataArray[indexPath.row];
                [cell configCellWithModel:policy];
            }];
        case TYPEGuide:
//            return 250;
            return [tableView fd_heightForCellWithIdentifier:[GuideTableViewCell identify] cacheByIndexPath:indexPath configuration:^(GuideTableViewCell* cell) {
                [cell configCell];
            }];
        case TYPEDemand:
            return [tableView fd_heightForCellWithIdentifier:[DemandTableViewCell identify] cacheByIndexPath:indexPath configuration:^(DemandTableViewCell* cell) {
                ZMDDemand* model = self.dataArray[indexPath.row];
                [cell config:model];
            }];
        default:
            return 0;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
