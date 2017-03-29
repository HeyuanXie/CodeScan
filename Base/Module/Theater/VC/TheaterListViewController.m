//
//  TheaterListViewController.m
//  Base
//
//  Created by admin on 2017/3/6.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "TheaterListViewController.h"
#import "HYAddressController.h"
#import "FilterAddressController.h"
#import "FilterTableViewController.h"
#import "TheaterListCell.h"
#import "APIHelper+Theater.h"
#import "TheaterModel.h"

@interface TheaterListViewController ()

@property(nonatomic,strong)UIButton *addressBtn;
@property(nonatomic,strong)UIButton *filterBtn;
@property(nonatomic,strong)UIView *backGrayView;
@property(nonatomic,strong)FilterAddressController* filterCityVC;
@property(nonatomic,strong)FilterTableViewController* filterVC;

@property(nonatomic,assign)NSInteger currentIndex;
@property(nonatomic,strong)NSMutableArray* dataArray;

@end

@implementation TheaterListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self baseSetupTableView:UITableViewStylePlain InSets:UIEdgeInsetsMake(zoom(44), 0, 0, 0)];
    [self.tableView registerNib:[UINib nibWithNibName:[TheaterListCell identify] bundle:nil] forCellReuseIdentifier:[TheaterListCell identify]];

    [self subviewInit];
    [self fetchData];
    [self headerViewInit];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - tableView dataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TheaterListCell* cell = [tableView dequeueReusableCellWithIdentifier:[TheaterListCell identify]];
    [HYTool configTableViewCellDefault:cell];
    //TODO:
    [cell setTicketBtnClick:^(id model) {
        APPROUTE(kTheaterTicketViewController);
    }];
    [cell configTheaterListCell:nil];
    return cell;
}

#pragma mark - tableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 173;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    APPROUTE(kTheaterDetailViewController);
}

#pragma mark - private methods
-(NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

-(void)subviewInit {
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc] initWithImage:[ImageNamed(@"订单搜索") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(search)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UIView* filterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, zoom(44))];
    filterView.backgroundColor = [UIColor whiteColor];
    NSArray* titles = @[@"地点",@"筛选"];
    NSInteger i = 0;
    for (NSString* title in titles) {
        UIButton * btn = [HYTool getButtonWithFrame:CGRectMake(i*kScreen_Width/titles.count, 0, kScreen_Width/titles.count, zoom(44)) title:title titleSize:14 titleColor:[UIColor hyBlackTextColor] backgroundColor:[UIColor clearColor] blockForClick:nil];
        btn.tag = 1000 + i;
        [btn setImage:ImageNamed(@"三角形_黑色下") forState:UIControlStateNormal];
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, 75, 0, 0);
        [btn addTarget:self action:@selector(filter:) forControlEvents:UIControlEventTouchUpInside];
        [filterView addSubview:btn];
        i++;
    }
    [filterView addSubview:[HYTool getLineWithFrame:CGRectMake(0, zoom(44), kScreen_Width, 0.5) lineColor:nil]];
    [self.view addSubview:filterView];
}

- (void)fetchData {
    [self.dataArray removeAllObjects];
    [self showLoadingAnimation];
    [APIHELPER theaterListStart:0 limit:10 classId:0 orderType:@"" city:@"" complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
        [self hideLoadingAnimation];
        
        if (isSuccess) {
            [self.dataArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:[TheaterModel class] array:responseObject[@"data"][@"list"]] ];
            self.haveNext = [responseObject[@"data"][@"have_next"] boolValue];
            if (self.haveNext) {
                [self appendFooterView];
            }else{
                [self removeFooterRefresh];
            }
            [self.tableView reloadData];
        }else{
            [self showMessage:error.userInfo[NSLocalizedDescriptionKey]];
        }
    }];
}

-(void)headerViewInit {
    @weakify(self);
    [self.dataArray removeAllObjects];
    [self addHeaderRefresh:^{
        @strongify(self);
        [self showLoadingAnimation];
        [APIHELPER theaterListStart:0 limit:10 classId:0 orderType:@"" city:@"" complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
            [self hideLoadingAnimation];
            
            if (isSuccess) {
                [self.dataArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:[TheaterModel class] array:responseObject[@"data"][@"list"]] ];
                self.haveNext = [responseObject[@"data"][@"have_next"] boolValue];
                if (self.haveNext) {
                    [self appendFooterView];
                }else{
                    [self removeFooterRefresh];
                }
                [self.tableView reloadData];
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
        [APIHELPER theaterListStart:self.dataArray.count limit:10 classId:0 orderType:@"" city:@"" complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
            [self hideLoadingAnimation];
            
            if (isSuccess) {
                [self.dataArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:[TheaterModel class] array:responseObject[@"data"][@"list"]] ];
                self.haveNext = [responseObject[@"data"][@"have_next"] boolValue];
                if (self.haveNext) {
                    [self appendFooterView];
                }else{
                    [self removeFooterRefresh];
                }
                [self.tableView reloadData];
            }else{
                [self showMessage:error.userInfo[NSLocalizedDescriptionKey]];
            }
            [self endRefreshing];
        }];
    }];
}

-(void)search {
    APPROUTE(([NSString stringWithFormat:@"%@?contentType=%d",kSearchGuideController,0]));
}

-(void)filter:(UIButton*)btn {
    if (btn.tag == 1000) {
        [self filterAddress:self.addressBtn];
    }else{
        [self showFilterView:self.filterBtn];
    }
}

- (UIView *)backGrayView {
    if (_backGrayView == nil) {
        _backGrayView = [[UIView alloc] initWithFrame:CGRectMake(0, zoom(45), kScreen_Width, kScreen_Height-zoom(45))];
        _backGrayView.backgroundColor = [UIColor hyBlackTextColor];
        _backGrayView.alpha = 0.4;
        [_backGrayView bk_whenTapped:^{
            [self hideFilterView:self.filterBtn];
        }];
    }
    return _backGrayView;
}

- (FilterTableViewController *)filterVC {
    if (!_filterVC) {
        _filterVC = (FilterTableViewController*)VIEWCONTROLLER(kFilterTableViewController);
    }
    return _filterVC;
}


-(FilterAddressController *)filterCityVC {
    if (!_filterCityVC) {
        _filterCityVC = (FilterAddressController*)VIEWCONTROLLER(kFilterAddressController);
        @weakify(self);
        [_filterCityVC setSelectCity:^(NSString * city) {
            @strongify(self);
            [self hiddenFilterAddress];
            //TODO:fetchData
        }];
    }
    return _filterCityVC;
}

- (void)filterAddress:(UIButton *)button{
    [self hideFilterView:self.filterBtn];
    if (self.filterCityVC.view.superview) {
        [self hiddenFilterAddress];
        return;
    }
    button.enabled = NO;    //避免多次addressNVC未加载成功时点击多次，而加载多个addressNVC
    [self addChildViewController:self.filterCityVC];
    [self.view addSubview:self.filterCityVC.view];
    [self.view bringSubviewToFront:self.filterCityVC.view];
    [self.filterCityVC.view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(zoom(45), 0, -44, 0)];
    [UIView animateWithDuration:0.3 animations:^{
        self.filterCityVC.view.alpha = 1.0;
    } completion:^(BOOL finished) {
        button.enabled = YES;   //addressNVC加载成功后恢复button.enabled
    }];
    
}

- (void)hiddenFilterAddress{
    [self.filterCityVC removeFromParentViewController];
    [self.filterCityVC.view removeFromSuperview];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.filterCityVC.view.alpha = CGFLOAT_MIN;
    }];
}

- (void)showFilterView:(UIButton *)btn {
    [self hiddenFilterAddress];
    if (self.filterVC.view.superview) {
        [self hideFilterView:self.filterBtn];
        return;
    }
    [self.filterBtn setImage:ImageNamed(@"up") forState:UIControlStateNormal];
    self.filterBtn.enabled = NO;
    [self.view addSubview:self.backGrayView];
    [self addChildViewController:self.filterVC];
    [self.view addSubview:self.filterVC.view];
    [self.view bringSubviewToFront:self.filterVC.view];
    self.filterVC.view.frame = CGRectMake(0, zoom(44)-240, kScreen_Width, 240);
    self.filterVC.view.hidden = YES;
    self.filterVC.currentIndex = self.currentIndex;
    [UIView animateWithDuration:0.3 animations:^{
        self.filterVC.view.frame = CGRectMake(0, zoom(45), kScreen_Width, 240);
        self.filterVC.view.hidden = NO;
    } completion:^(BOOL finished) {
        self.filterBtn.enabled = YES;
    }];
    
    @weakify(self);
    [self.filterVC setSelectIndex:^(NSInteger index) {
        @strongify(self);
        [self hideFilterView:self.filterBtn];
        self.currentIndex = index;
        //TODO:fetchData
    }];
}

- (void)hideFilterView:(UIButton *)btn {
    [self.backGrayView removeFromSuperview];
    self.filterBtn.enabled = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.filterVC.view.frame = CGRectMake(0, zoom(44)-240, kScreen_Width, 240);
        self.filterVC.view.hidden = YES;
    } completion:^(BOOL finished) {
        self.filterBtn.enabled = YES;
    }];
    [self.filterVC.view removeFromSuperview];
    [self.filterVC removeFromParentViewController];
}

@end
