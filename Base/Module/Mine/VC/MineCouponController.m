//
//  MineCouponController.m
//  Base
//
//  Created by admin on 2017/3/16.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "MineCouponController.h"
#import "MineCouponCell.h"

@interface MineCouponController ()

@property(nonatomic,strong)NSMutableArray* dataArray;

@end

@implementation MineCouponController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self baseSetupTableView:UITableViewStylePlain InSets:UIEdgeInsetsMake(41*kScreen_Height/667, 0, 0, 0)];
    [self.tableView registerNib:[UINib nibWithNibName:[MineCouponCell identify] bundle:nil] forCellReuseIdentifier:[MineCouponCell identify]];
    [self fetchData];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - talbeView dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MineCouponCell* cell = [tableView dequeueReusableCellWithIdentifier:[MineCouponCell identify]];
    [HYTool configTableViewCellDefault:cell];
    
    CouponModel* coupon = self.dataArray[indexPath.row];
    [cell configCouponCell:coupon];
    return cell;
}

#pragma mark - tableView delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 112;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //使用优惠券
    CouponModel* coupon = self.dataArray[indexPath.row];
    switch (coupon.orderType.integerValue) {
        case 1:{
            APPROUTE(kTheaterListViewController);
        }break;
        case 2:{
            APPROUTE(kYearCardHomeController);
        }break;
            
        default:
            break;
    }
}
#pragma mark - private methods
-(NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)fetchData {
    self.tableView.tableFooterView = nil;
    [self showLoadingAnimation];
    [APIHELPER mineCouponList:0 limit:6 orderType:0 complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
        [self hideLoadingAnimation];
        
        if (isSuccess) {
            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:[CouponModel class] array:responseObject[@"data"][@"list"]] ];
            [self.tableView reloadData];
            
            self.haveNext = [responseObject[@"data"][@"have_next"] boolValue];
            if (self.haveNext) {
                [self appendFooterView];
            }else{
                [self removeFooterRefresh];
            }
        }else{
            [self showMessage:error.userInfo[NSLocalizedDescriptionKey]];
        }
    }];
}

-(void)headerViewInit {
    @weakify(self);
    [self addHeaderRefresh:^{
        @strongify(self);
        [self showLoadingAnimation];
        [APIHELPER mineCouponList:0 limit:6 orderType:0 complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
            [self hideLoadingAnimation];

            if (isSuccess) {
                [self.dataArray removeAllObjects];
                [self.dataArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:[CouponModel class] array:responseObject[@"data"][@"list"]] ];
                [self.tableView reloadData];
                
                self.haveNext = [responseObject[@"data"][@"have_next"] boolValue];
                if (self.haveNext) {
                    [self appendFooterView];
                }else{
                    [self removeFooterRefresh];
                }
            }else{
                [self showMessage:error.userInfo[NSLocalizedDescriptionKey]];
            }
            [self endRefreshing];
        }];
    }];
}

-(void)appendFooterView {
    @weakify(self);
    [self addFooterRefresh:^{
        @strongify(self);
        [self showLoadingAnimation];
        [APIHELPER mineCouponList:self.dataArray.count limit:6 orderType:0 complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
            [self hideLoadingAnimation];
            
            if (isSuccess) {
                [self.dataArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:[CouponModel class] array:responseObject[@"data"][@"list"]] ];
                [self.tableView reloadData];
                
                self.haveNext = [responseObject[@"data"][@"have_next"] boolValue];
                if (self.haveNext) {
                    [self appendFooterView];
                }else{
                    [self removeFooterRefresh];
                }
            }else{
                [self showMessage:error.userInfo[NSLocalizedDescriptionKey]];
            }
            [self endRefreshing];
        }];
    }];
}

#pragma mark - IBActions
- (IBAction)useRules:(id)sender {
    //使用规则
    APPROUTE(kCouponRulesController);
}


@end
