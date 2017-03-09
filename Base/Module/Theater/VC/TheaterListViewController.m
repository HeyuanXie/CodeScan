//
//  TheaterListViewController.m
//  Base
//
//  Created by admin on 2017/3/6.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "TheaterListViewController.h"
#import "HYAddressController.h"
#import "BaseNavigationController.h"
#import "FilterTableViewController.h"
#import "TheaterListCell.h"

@interface TheaterListViewController ()

@property(nonatomic,strong)UIButton *addressBtn;
@property(nonatomic,strong)UIButton *filterBtn;
@property(nonatomic,strong)UIView *backGrayView;
@property(nonatomic,strong)BaseNavigationController* addressNVC;
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
-(void)subviewInit {
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc] initWithImage:ImageNamed(@"") style:UIBarButtonItemStylePlain target:self action:@selector(search)];
    self.navigationController.navigationItem.rightBarButtonItem = rightItem;
    
    UIView* filterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, zoom(44))];
    filterView.backgroundColor = [UIColor whiteColor];
    NSArray* titles = @[@"地点",@"筛选"];
    NSInteger i = 0;
    for (NSString* title in titles) {
        UIButton * btn = [HYTool getButtonWithFrame:CGRectMake(i*kScreen_Width/titles.count, 0, kScreen_Width/titles.count, zoom(44)) title:title titleSize:14 titleColor:[UIColor hyBlackTextColor] backgroundColor:[UIColor clearColor] blockForClick:nil];
        btn.tag = 1000 + i;
        [btn addTarget:self action:@selector(filter:) forControlEvents:UIControlEventTouchUpInside];
        [filterView addSubview:btn];
        i++;
    }
    [self.view addSubview:filterView];
}

- (void)fetchData {
    _dataArray = [NSMutableArray array];
    [_dataArray addObject:@(1)];
    
    if (1) {
        [self appendFooterView];
    }
}

-(void)headerViewInit {
    @weakify(self);
    [self addHeaderRefresh:^{
        @strongify(self);
        //TODO:
    }];
}

-(void)appendFooterView {
    @weakify(self);
    [self addFooterRefresh:^{
        @strongify(self);
        //TODO:
    }];
}

-(void)search {
    
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

-(BaseNavigationController *)addressNVC {
    if (!_addressNVC) {
        HYAddressController *addressC = (HYAddressController *)VIEWCONTROLLER(kAddressController);
        addressC.backItemHidden = YES;
        @weakify(self);
        [addressC setSelectAddress:^(NSString *areaName, NSString *areaID) {
            @strongify(self);
            [self.addressBtn setTitle:areaName forState:UIControlStateNormal];
            [self hiddenFilterAddress];
            //TODO:fetchData
        }];
        [addressC setFilterDismiss:^{
            @strongify(self);
            [self hiddenFilterAddress];
        }];
        addressC.isFilter = YES;
        _addressNVC = [[BaseNavigationController alloc] initWithRootViewController:addressC];
        [_addressNVC.navigationBar setBackgroundColor:[UIColor whiteColor]];
        [_addressNVC.navigationBar setTintColor:[UIColor whiteColor]];
        [_addressNVC.navigationBar setBarTintColor:[UIColor whiteColor]];
        [_addressNVC.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor hyBlackTextColor],
                                                            NSFontAttributeName: [UIFont systemFontOfSize:17.0f]}];
    }
    return _addressNVC;
}

- (void)filterAddress:(UIButton *)button{
    [self hideFilterView:self.filterBtn];
    if (self.addressNVC.view.superview) {
        //如果self.addressNVC已经加载，点击后移除self.addressNVC
        [self hiddenFilterAddress];
        return;
    }
    button.enabled = NO;    //避免多次addressNVC未加载成功时点击多次，而加载多个addressNVC
    [self addChildViewController:self.addressNVC];
    [self.view addSubview:self.addressNVC.view];
    [self.view bringSubviewToFront:self.addressNVC.view];
    [self.addressNVC popToRootViewControllerAnimated:NO];
    [self.addressNVC.view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(zoom(45), 0, -44, 0)];
    [UIView animateWithDuration:0.3 animations:^{
        self.addressNVC.view.alpha = 1.0;
    } completion:^(BOOL finished) {
        button.enabled = YES;   //addressNVC加载成功后恢复button.enabled
    }];
    
}

- (void)hiddenFilterAddress{
    [self.addressNVC removeFromParentViewController];
    [self.addressNVC.view removeFromSuperview];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.addressNVC.view.alpha = CGFLOAT_MIN;
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
