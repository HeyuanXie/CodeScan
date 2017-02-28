//
//  HomeViewController.m
//  Base
//
//  Created by admin on 17/1/16.
//  Copyright © 2017年 XHY. All rights reserved.
//


#import "APIHelper+Home.h"
#import "APIHelper+User.h"
#import "HYAddressController.h"
#import "HYScrollView.h"
#import "HYSearchBar.h"
#import "HomeDeclareView.h"
#import "HomeNewsCell.h"
#import "HomeViewController.h"
#import "ThreeImgCell.h"
#import "WKWebViewController.h"
#import "WebViewController.h"
#import "ZMDArticle.h"
#import "ZMDHomeData.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import <UITableView+FDTemplateLayoutCell.h>
#import <UIView+BlocksKit.h>

@interface HomeViewController ()<UITextFieldDelegate>

@property(nonatomic,strong)HYScrollView* scrollView;

@property(nonatomic,strong)UIScrollView* decleraScrollV;
@property(nonatomic,strong)UIPageControl* pageControl;

@property(nonatomic,strong)NSArray* info;
@property(nonatomic,strong)NSMutableArray* newsArray;
@property(nonatomic,strong)ZMDHomeData* data;

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

-(UIScrollView *)decleraScrollV {
    if (_decleraScrollV == nil) {
        _decleraScrollV = [[UIScrollView alloc] init];
        _decleraScrollV.delegate = self;
        _decleraScrollV.showsVerticalScrollIndicator = NO;
        _decleraScrollV .showsHorizontalScrollIndicator = NO;
    }
    return _decleraScrollV;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.backItemHidden = YES;
    [self baseSetupTableView:UITableViewStylePlain InSets:UIEdgeInsetsMake(0, 0, 0, 0)];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    self.info = @[@{@"title":@"轮播"},
                  @{@"title":@"Menu"},
                  @{@"title":@"快捷申报"},
                  @{@"title":@"新闻动态"}];
    self.newsArray = [NSMutableArray array];
    
    [self effectInit];
    [self fetchData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)effectInit {
    [self.tableView registerNib:[UINib nibWithNibName:[ThreeImgCell identify] bundle:nil] forCellReuseIdentifier:[ThreeImgCell identify]];
    [self.tableView registerNib:[UINib nibWithNibName:[HomeNewsCell identify] bundle:nil] forCellReuseIdentifier:[HomeNewsCell identify]];
    [self.tableView registerNib:[UINib nibWithNibName:[HomeDeclareView identify] bundle:nil] forCellReuseIdentifier:[HomeDeclareView identify]];
    [self addSearchBar];
}

-(void)fetchData {
    [self showLoadingAnimation];
    @weakify(self);
    [APIHELPER fetchHomePageData:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
        @strongify(self);
        [self hideLoadingAnimation];
        if (isSuccess) {
            self.data = [ZMDHomeData yy_modelWithDictionary:responseObject[@"data"]];
            [self.tableView reloadData];
        }else{
             [self showMessage:responseObject[@"msg"]];
        }
    }];
}

#pragma mark- event function
-(void)addSearchBar {
    HYSearchBar* searchBar = [HYSearchBar searchBarWithFrame:CGRectMake(0, 0, 300, 30) placeholder:@"松山湖政策"];
    searchBar.delegate = self;
    [HYTool configViewLayer:searchBar size:15];
    self.navigationItem.titleView = searchBar;
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
    NSString* title = self.info[section][@"title"];
    if ([title isEqualToString:@"新闻动态"]) {
        return self.data.news.count;
    }else{
        return 1;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            return [self tableView:tableView bannerCellForIndexPath:indexPath];
            break;
        case 1:
            return [self tableView:tableView menuCellForIndexPath:indexPath];
        case 2:
            return [self tableView:tableView declareCellForIndexPath:indexPath];
        default:
            return [self tableView:tableView newsCellForIndexPath:indexPath];
            break;
    }
}

#pragma mark- tableview delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            return 186;
            break;
        case 1:
            return 103;
        case 2:
            return 164;
        default: {
            ZMDArticle* article = self.data.news[indexPath.row];
            if (![article.thumb isEqualToString:@""]) {
                return 106;
            }
            return [tableView fd_heightForCellWithIdentifier:[HomeNewsCell identify] cacheByIndexPath:indexPath configuration:^(HomeNewsCell* cell) {
                [cell configCellWithModel:self.data.news[indexPath.row]];
            }];
            break;
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        [self touchIDAuth];
        HYAddressController* addressVC = [[HYAddressController alloc] init];
        APPROUTE(kAddressController);
    }
}

-(void)touchIDAuth {
    

}

#pragma mark- private Method
-(UITableViewCell*)tableView:(UITableView *)tableView bannerCellForIndexPath:(NSIndexPath*)indexPath {
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"bannerCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] init];
        if (self.scrollView == nil) {
            self.scrollView = [[HYScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 186)];
            self.scrollView.pageControl.pageIndicatorTintColor = [UIColor whiteColor];
            self.scrollView.pageControl.currentPageIndicatorTintColor = appThemeColor;
        }
        [cell.contentView addSubview:self.scrollView.rollView];
    }
    NSMutableArray* arr = [NSMutableArray array];
    for (ZMDArticle* item in self.data.slide) {
        [arr addObject:item.thumb];
    }
    self.scrollView.dataArray = arr;
    @weakify(self);
    self.scrollView.clickAction = ^(NSInteger index,NSArray* arr) {
        @strongify(self);
        ZMDArticle* article = self.data.slide[index];
        WKWebViewController* web = [[WKWebViewController alloc] init];
//        WebViewController* web = [[WebViewController alloc] init];
        web.url = article.detailUrl;
        web.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:web animated:YES];
        NSLog(@"%@",article.detailUrl);
    };
    return cell;
}

-(UITableViewCell*)tableView:(UITableView *)tableView menuCellForIndexPath:(NSIndexPath*)indexPath {
    ThreeImgCell* menuCell = [tableView dequeueReusableCellWithIdentifier:[ThreeImgCell identify]];
    [menuCell setClickBlock:^(int index) {
        APPROUTE(([NSString stringWithFormat:@"%@?type=%d",kPolicyListController,index]))
    }];
    return menuCell;
}
-(UITableViewCell*)tableView:(UITableView *)tableView declareCellForIndexPath:(NSIndexPath*)indexPath {
    static NSString* cellId = @"HomeDecleraCell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        self.decleraScrollV.delegate = self;
        self.decleraScrollV.frame = CGRectMake(0, 0, kScreen_Width, 164);
        self.pageControl.frame = CGRectMake(0, 144, kScreen_Width, 20);
        [cell.contentView addSubview:_decleraScrollV];
        [cell.contentView addSubview:_pageControl];
    }
    
    NSArray* policys = self.data.policy;
    self.decleraScrollV.contentSize = CGSizeMake(policys.count*kScreen_Width, 0);
    self.pageControl.numberOfPages = policys.count;
    int pages = (int)policys.count/4+policys.count%4;
    for (int i=0; i<pages; i++) {
        UIView* view = [[NSBundle mainBundle] loadNibNamed:@"HomeDeclareView" owner:nil options:nil][0];
        HomeDeclareView* decleraView = (HomeDeclareView*)view;
        decleraView.frame = CGRectMake(i*kScreen_Width, 0, kScreen_Width, cell.frame.size.height);
        [self.decleraScrollV addSubview:decleraView];
        [self configDecleraView:decleraView WithArray:policys andIndex:i];
    }
    return cell;
}

-(void)configDecleraView:(HomeDeclareView*)view WithArray:(NSArray*)array andIndex:(int)index {
    int pages = (int)array.count/4;
    int remainder = (int)array.count%4;
    int arc = arc4random();
    if (index < pages) {
        //config满载declareView
        for (int j=0; j<4; j++) {
            int imgIndex = (arc+j)%9;
            ZMDArticle* policy = array[index*4+j];
            UIView* miniView = [view viewWithTag:10000+j];
            UILabel* titleLbl = [miniView viewWithTag:100];
            UIImageView* imgV = [miniView viewWithTag:101];
            UIButton* btn = [miniView viewWithTag:102];
            
            titleLbl.text = policy.title;
            imgV.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d",imgIndex]];
            btn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
                NSLog(@"%ld",btn.tag-100);
                return [RACSignal empty];
            }];
        }
    }else{
        //config非满载declareView
        int arc = arc4random();
        for (int j=0; j<remainder; j++) {
            ZMDArticle* policy = array[j];
            int imgIndex = (arc+j)%9;
            UIView* miniView = [view viewWithTag:10000+j];
            UILabel* titleLbl = [miniView viewWithTag:100];
            UIImageView* imgV = [ miniView viewWithTag:101];
            UIButton* btn = [miniView viewWithTag:102];
            
            titleLbl.text = policy.title;
            imgV.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d",imgIndex]];
            imgV.image = [UIImage imageNamed:@"8"];
            btn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
                NSLog(@"%ld",btn.tag-100);
                return [RACSignal empty];
            }];
        }
        for (int j=remainder; j<4; j++) {
            UIView* miniView = [view viewWithTag:10000+j];
            miniView.hidden = YES;
        }
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView newsCellForIndexPath:(NSIndexPath*)indexPath {
    
    HomeNewsCell* newsCell = [tableView dequeueReusableCellWithIdentifier:[HomeNewsCell identify]];
    [newsCell configCellWithModel:self.data.news[indexPath.row]];
    return newsCell;
}

@end
