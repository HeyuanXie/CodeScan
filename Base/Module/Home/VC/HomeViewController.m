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
#import "WeekEndDetailController.h"
#import "APIHelper+Home.h"

#import "HYScrollView.h"
#import "HYSearchBar.h"
#import "HomeImageCell.h"
#import "ThemeCell.h"
#import "HomeVideoCell.h"
#import "HomeHotCell.h"
#import "RecentHotView.h"
#import "NewsCell.h"
#import "WeekEndCell.h"

#import "UITableViewCell+HYCell.h"
#import "UIViewController+Extension.h"

@interface HomeViewController ()<UITextFieldDelegate>

@property(nonatomic, strong) NSArray* info;
@property(nonatomic, strong) NSMutableArray* banners;   //轮播
@property(nonatomic, strong) NSMutableArray* news;  //资讯
@property(nonatomic, strong) NSMutableArray* weekEnds;   //周末

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
    self.tabBarController.tabBar.hidden = NO;
    [self baseSetupTableView:UITableViewStylePlain InSets:UIEdgeInsetsMake(0, 0, 0, 0)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    [self.tableView registerNib:[UINib nibWithNibName:[HomeImageCell identify] bundle:nil] forCellReuseIdentifier:[HomeImageCell identify]];
    [self.tableView registerNib:[UINib nibWithNibName:[ThemeCell identify] bundle:nil] forCellReuseIdentifier:[ThemeCell identify]];
    [self.tableView registerNib:[UINib nibWithNibName:[HomeVideoCell identify] bundle:nil] forCellReuseIdentifier:[HomeVideoCell identify]];
    [self.tableView registerNib:[UINib nibWithNibName:[HomeHotCell identify] bundle:nil] forCellReuseIdentifier:[HomeHotCell identify]];
    [self.tableView registerNib:[UINib nibWithNibName:[NewsCell identify] bundle:nil] forCellReuseIdentifier:[NewsCell identify]];
    [self.tableView registerNib:[UINib nibWithNibName:[WeekEndCell identify] bundle:nil] forCellReuseIdentifier:[WeekEndCell identify]];

    
    self.info = @[@{@"section":@(0),@"title":@"轮播"},
                  @{@"section":@(1),@"title":@"近期上演"},
                  @{@"section":@(3),@"title":@"小飞象资讯"},
                  @{@"section":@(4),@"title":@"周末去哪儿"},
//                  @{@"section":@(3),@"title":@"主题活动"},
//                  @{@"section":@(4),@"title":@"精选视频"},
                  @{@"section":@(5),@"title":@"热门衍生品"}];
    
    [self effectInit];
    [self fetchData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
//-(void)textFieldDidBeginEditing:(UITextField *)textField {
//    [self.view endEditing:YES];
//    [textField resignFirstResponder];
//    APPROUTE(kSearchGuideController);
//}

#pragma mark- tableview datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.info.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString* title = self.info[section][@"title"];
    if ([title isEqualToString:@"小飞象资讯"]) {
        return self.news.count;
    }
    if ([title isEqualToString:@"周末去哪儿"]) {
        return self.weekEnds.count;
    }
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
//            return [self weekEndCellForTableView:tableView indexPath:indexPath];
        case 3:
//            return [self themeCellForTableView:tableView RowAtIndexPath:indexPath];
            return [self newsCellForTableView:tableView indexPath:indexPath];
        case 4:
//            return [self videoCellForTableView:tableView RowAtIndexPath:indexPath];
            return [self weekEndCellForTableView:tableView indexPath:indexPath];
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
                APPROUTE(kYearCardHomeController);
                break;
            case 2:
                APPROUTE(([NSString stringWithFormat:@"%@?type=0",kWeekEndListController]));
                break;
            case 3:
                APPROUTE(([NSString stringWithFormat:@"%@?type=1",kWeekEndListController]));
                break;
            case 4:
                APPROUTE(kDeriveListController);
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
        [hotView configRecentView:nil];
        [hotView bk_whenTapped:^{
            APPROUTE(kTheaterDetailViewController);
        }];
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
    [HYTool configTableViewCellDefault:cell];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    //TODO:configCell
    [cell configHotCell:nil];
    return cell;
}
-(NewsCell*)newsCellForTableView:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath {
    NewsCell* cell = [tableView dequeueReusableCellWithIdentifier:[NewsCell identify]];
    [HYTool configTableViewCellDefault:cell];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    if (indexPath.row == self.news.count-1) {
        cell.allViewHeight.constant = 40;
        cell.allView.hidden = NO;
    }else{
        cell.allViewHeight.constant = 0;
        cell.allView.hidden = YES;
    }

    [cell.allBtn bk_whenTapped:^{
        APPROUTE(([NSString stringWithFormat:@"%@?type=%d",kWeekEndListController,0]));
    }];

    [cell configNewsCell:nil];
    return cell;
}

-(WeekEndCell*)weekEndCellForTableView:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath {
    NSInteger section = [self.info[indexPath.section][@"section"] integerValue];
    WeekEndCell* cell = [tableView dequeueReusableCellWithIdentifier:[WeekEndCell identify]];
    [HYTool configTableViewCellDefault:cell];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    if (section == 4 && indexPath.row == self.weekEnds.count-1) {
        cell.allViewHeight.constant = 40;
        cell.allView.hidden = NO;
    }else{
        cell.allViewHeight.constant = 0;
        cell.allView.hidden = YES;
    }
    //TODO:configCell
    [cell configWeekEndCell:nil type:indexPath.section-2];
    [cell.allBtn bk_whenTapped:^{
        APPROUTE(([NSString stringWithFormat:@"%@?type=%ld",kWeekEndListController,indexPath.section-2]));
    }];
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
//            return 66;
            return indexPath.row == self.news.count-1 ? 158 : 120;
        case 4:
//            return 390;
            return indexPath.row == self.weekEnds.count-1 ? 158 : 120;
        case 5:
            return 320;
        default:
            return 0;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = [self.info[indexPath.section][@"section"] integerValue];
    switch (section) {
        case 0:
            
            break;
        case 1:
            
            break;
        case 2:
            
            break;
        case 3:
        {
            //资讯
            WeekEndDetailController* vc = (WeekEndDetailController*)VIEWCONTROLLER(kWeekEndDetailController);
            vc.data = self.news[indexPath.row];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 4:
        {
            //周末去哪儿
            WeekEndDetailController* vc = (WeekEndDetailController*)VIEWCONTROLLER(kWeekEndDetailController);
            vc.data = self.news[indexPath.row];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 5:

            break;
        default:
            break;
    }
}


#pragma mark- private Method
-(void)effectInit {
    [self addSearchBar];
    
    self.leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.leftBtn.frame = CGRectMake(0, 0, 60, 32);
//    [_leftBtn setImage:[UIImage imageNamed:@"dinwei01"] forState:UIControlStateNormal];
    [_leftBtn setTitle:@"未定位" forState:UIControlStateNormal];
    [_leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _leftBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//    _leftBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
//    _leftBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    [_leftBtn addTarget:self action:@selector(filterAddress:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* leftItem = [[UIBarButtonItem alloc] initWithCustomView:self.leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    [self configMessage];
    
    UIView* footerView = [[NSBundle mainBundle] loadNibNamed:@"HomeUseView" owner:self options:nil][2];
    self.tableView.tableFooterView = footerView;
}

-(void)addSearchBar {
    HYSearchBar* searchBar = [HYSearchBar searchBarWithFrame:CGRectMake(0, 0, kScreen_Width-110, 30) placeholder:@"小鬼当家"];
    [HYTool configViewLayer:searchBar size:15];
    self.navigationItem.titleView = searchBar;
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 210, 30)];
    view.backgroundColor = [UIColor clearColor];
    [view bk_whenTapped:^{
        APPROUTE(kSearchGuideController);
    }];
    [searchBar addSubview:view];
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
    self.news = [@[@"",@"",@""] mutableCopy];
    self.weekEnds = [@[@"",@"",@""] mutableCopy];
    [self.tableView reloadData];
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

@end
