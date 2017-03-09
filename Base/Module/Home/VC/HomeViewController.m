//
//  HomeViewController.m
//  Base
//
//  Created by admin on 17/1/16.
//  Copyright © 2017年 XHY. All rights reserved.
//


#import "HomeViewController.h"
#import "HYAddressController.h"
#import "BaseNavigationController.h"
#import "APIHelper+Home.h"

#import "HYScrollView.h"
#import "HYSearchBar.h"
#import "HomeImageCell.h"
#import "ThemeCell.h"
#import "HomeVideoCell.h"
#import "HomeHotCell.h"
#import "RecentHotView.h"

#import "UITableViewCell+HYCell.h"

@interface HomeViewController ()<UITextFieldDelegate>

@property(nonatomic, strong) NSArray* info;
@property(nonatomic, strong) NSMutableArray* banners;

@property(nonatomic, strong) UIButton* leftBtn;
@property(nonatomic, strong) BaseNavigationController* addressNVC;

@property(nonatomic, strong) HYScrollView* banner;
@property(nonatomic, strong) UIPageControl* pageControl;


@end

@implementation HomeViewController

-(UIPageControl *)pageControl {
    if (_pageControl == nil) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.currentPageIndicatorTintColor = appThemeColor;
        _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    }
    return _pageControl;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.backItemHidden = YES;
    self.navigationBarBlue = NO;
    [self baseSetupTableView:UITableViewStylePlain InSets:UIEdgeInsetsMake(0, 0, 0, 0)];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    [self.tableView registerNib:[UINib nibWithNibName:[HomeImageCell identify] bundle:nil] forCellReuseIdentifier:[HomeImageCell identify]];
    [self.tableView registerNib:[UINib nibWithNibName:[ThemeCell identify] bundle:nil] forCellReuseIdentifier:[ThemeCell identify]];
    [self.tableView registerNib:[UINib nibWithNibName:[HomeVideoCell identify] bundle:nil] forCellReuseIdentifier:[HomeVideoCell identify]];
    [self.tableView registerNib:[UINib nibWithNibName:[HomeHotCell identify] bundle:nil] forCellReuseIdentifier:[HomeHotCell identify]];


    
    self.info = @[@{@"section":@(0),@"title":@"轮播"},
                  @{@"section":@(1),@"title":@"近期上演"},
                  @{@"section":@(3),@"title":@"主题活动"},
                  @{@"section":@(4),@"title":@"精选视频"},
                  @{@"section":@(5),@"title":@"热门衍生品"}];
    
    [self effectInit];
    [self fetchData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- event function
-(void)addSearchBar {
    HYSearchBar* searchBar = [HYSearchBar searchBarWithFrame:CGRectMake(0, 0, 210, 30) placeholder:@"小鬼当家"];
    searchBar.delegate = self;
    [HYTool configViewLayer:searchBar size:15];
    self.navigationItem.titleView = searchBar;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView)
    {
        CGFloat sectionHeaderHeight = 44;
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
}

#pragma mark- UITextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField {
    UIButton* btn = [[UIButton alloc] initWithFrame:self.view.bounds];
    btn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [btn removeFromSuperview];
        return [RACSignal empty];
    }];
    btn.backgroundColor = [UIColor clearColor];
    btn.tag = 6666;
    [self.view addSubview:btn];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    if (![textField.text isEqualToString:@""]) {
        [[self.view viewWithTag:6666] removeFromSuperview];
    }
    return YES;
}


#pragma mark- tableview datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.info.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = [self.info[indexPath.section][@"section"] integerValue];
    switch (section) {
        case 0:
            return [self imageCellForTableView:tableView RowAtIndexPath:indexPath];
        case 1:
            return [self recentCellForTableView:tableView RowAtIndexPath:indexPath];
        case 2:
            return [self parentChildCellForTableView:tableView RowAtIndexPath:indexPath];
        case 3:
            return [self themeCellForTableView:tableView RowAtIndexPath:indexPath];
        case 4:
            return [self videoCellForTableView:tableView RowAtIndexPath:indexPath];
        case 5:
            return [self hotCellForTableView:tableView RowAtIndexPath:indexPath];
        default:
            return [[UITableViewCell alloc] init];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? 0 : 44;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView* headerView = [[NSBundle mainBundle] loadNibNamed:@"HomeUseView" owner:self options:nil][1];
    UILabel* line = [headerView viewWithTag:1000];
    [HYTool configViewLayer:line size:1];
    UILabel* lbl = [headerView viewWithTag:1001];
    lbl.text = self.info[section][@"title"];
    return section == 0 ? nil : headerView;
}


-(HomeImageCell*)imageCellForTableView:(UITableView *)tableView RowAtIndexPath:(NSIndexPath *)indexPath {
    HomeImageCell* cell = [tableView dequeueReusableCellWithIdentifier:[HomeImageCell identify]];
    [cell setBotSubviewClick:^(NSInteger index) {
        switch (index) {
                //TODO:
            case 0:
                APPROUTE(kTheaterListViewController);
                break;
            case 1:
                APPROUTE(kLectureListController);
                break;
            case 2:
                APPROUTE(kYearCardHomeController);
                break;
            default:
                break;
        }
    }];
    if (!_banner) {
        _banner = [[HYScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 120)];
        _banner.pageControl.pageIndicatorTintColor = [UIColor hyViewBackgroundColor];
        _banner.pageControl.currentPageIndicatorTintColor = [UIColor hyBarTintColor];
    }
    NSMutableArray* images = [NSMutableArray array];
    for (NSDictionary* slide in self.banners) {
        [images addObject:slide[@"img"]];
    }
    _banner.dataArray = images;
    _banner.dataArray = @[@"http://pic6.huitu.com/res/20130116/84481_20130116142820494200_1.jpg",@"http://pic55.nipic.com/file/20141208/19462408_171130083000_2.jpg",@"http://pic48.nipic.com/file/20140916/2531170_224158439000_2.jpg"];
    @weakify(self);
    _banner.clickAction = ^(NSInteger index,NSArray* dataArray){
        @strongify(self);
        //TODO:
    };
    [cell.topView addSubview:_banner.rollView];
    return cell;
}

-(UITableViewCell*)recentCellForTableView:(UITableView *)tableView RowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* cellId = @"recentCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        [HYTool configTableViewCellDefault:cell];
        
        UIScrollView* scroll = [[UIScrollView alloc] init];
        scroll.tag = 1000;
        [cell.contentView addSubview:scroll];
        scroll.showsHorizontalScrollIndicator = NO;
        [scroll autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    UIScrollView* scroll = (UIScrollView*)[cell.contentView viewWithTag:1000];
    for (int i=0; i<5; i++) {
        RecentHotView* hotView = LOADNIB(@"HomeUseView", 0);
        [scroll addSubview:hotView];
        [hotView autoSetDimensionsToSize:[RecentHotView homeSize]];
        [hotView autoPinEdgeToSuperviewEdge:ALEdgeTop];
        [hotView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10+(147+10)*i];
    }
    scroll.contentSize = CGSizeMake(5*(10+147)+10, 0);
    return cell;
    
}

-(UITableViewCell*)parentChildCellForTableView:(UITableView *)tableView RowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* cellId = @"parentChildCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    return cell;
}

-(ThemeCell*)themeCellForTableView:(UITableView *)tableView RowAtIndexPath:(NSIndexPath *)indexPath {
    ThemeCell* cell = [tableView dequeueReusableCellWithIdentifier:[ThemeCell identify]];
    //TODO:configCell
    [cell configThemeCell:nil];
    return cell;
}

-(HomeVideoCell*)videoCellForTableView:(UITableView *)tableView RowAtIndexPath:(NSIndexPath *)indexPath {
    HomeVideoCell* cell = [tableView dequeueReusableCellWithIdentifier:[HomeVideoCell identify]];
    //TODO:configCell
    [cell configVideoCell:nil];
    [cell addLine:NO leftOffSet:0 rightOffSet:0];
    return cell;
}

-(HomeHotCell*)hotCellForTableView:(UITableView *)tableView RowAtIndexPath:(NSIndexPath *)indexPath {
    HomeHotCell* cell = [tableView dequeueReusableCellWithIdentifier:[HomeHotCell identify]];
    //TODO:configCell
    [cell configHotCell:nil];
    return cell;
}

#pragma mark- tableview delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = [self.info[indexPath.section][@"section"] integerValue];
    switch (section) {
        case 0:
            return 210;
        case 1:
            return 240;//257;
        case 2:
            return 125;
        case 3:
            return 66;
        case 4:
            return 390;
        case 5:
            return 320;
        default:
            return 0;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}


#pragma mark- private Method
-(void)effectInit {
    [self addSearchBar];
    
    self.leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.leftBtn.frame = CGRectMake(0, 0, 60, 32);
    [_leftBtn setImage:[UIImage imageNamed:@"dinwei01"] forState:UIControlStateNormal];
    [_leftBtn setTitle:@"未定位" forState:UIControlStateNormal];
    [_leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _leftBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    _leftBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    _leftBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    [_leftBtn addTarget:self action:@selector(filterAddress:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* leftItem = [[UIBarButtonItem alloc] initWithCustomView:self.leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"message"] style:UIBarButtonItemStylePlain target:self action:@selector(message)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UIView* footerView = [[NSBundle mainBundle] loadNibNamed:@"HomeUseView" owner:self options:nil][2];
    self.tableView.tableFooterView = footerView;
}

-(void)fetchData {
//    [self showLoadingAnimation];
//    @weakify(self);
//    [APIHELPER fetchHomePageData:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
//        @strongify(self);
//        [self hideLoadingAnimation];
//        if (isSuccess) {
//            [self.tableView reloadData];
//        }else{
//            [self showMessage:responseObject[@"msg"]];
//        }
//    }];
}

-(BaseNavigationController *)addressNVC {
    if (!_addressNVC) {
        HYAddressController *addressC = (HYAddressController *)VIEWCONTROLLER(kAddressController);
        addressC.backItemHidden = YES;
        @weakify(self);
        [addressC setSelectAddress:^(NSString *areaName, NSString *areaID) {
            @strongify(self);
            [self.leftBtn setTitle:areaName forState:UIControlStateNormal];
            [self hiddenFilterAddress];
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
    self.addressNVC.view.frame = CGRectMake(0, 0, kScreen_Width, kScreen_Height-64);
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

- (void)message {
    
}

@end
