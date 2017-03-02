//
//  HomeViewController.m
//  Base
//
//  Created by admin on 17/1/16.
//  Copyright © 2017年 XHY. All rights reserved.
//


#import "HomeViewController.h"
#import "APIHelper+Home.h"
#import "HYScrollView.h"
#import "HYSearchBar.h"

#import <LocalAuthentication/LocalAuthentication.h>
#import <UITableView+FDTemplateLayoutCell.h>
#import <UIView+BlocksKit.h>

@interface HomeViewController ()<UITextFieldDelegate>

@property(nonatomic,strong)HYScrollView* scrollView;
@property(nonatomic,strong)UIScrollView* decleraScrollV;
@property(nonatomic,strong)UIPageControl* pageControl;
@property(nonatomic,strong)NSArray* info;

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
    self.navigationBarTransparent = YES;
    [self baseSetupTableView:UITableViewStylePlain InSets:UIEdgeInsetsMake(-64, 0, 0, 0)];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    self.info = @[@{@"title":@"轮播"},
                  @{@"title":@"Menu"},
                  @{@"title":@"快捷申报"},
                  @{@"title":@"新闻动态"}];
    
    [self effectInit];
    [self fetchData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)effectInit {
    [self addSearchBar];
}

-(void)fetchData {
    [self showLoadingAnimation];
    @weakify(self);
    [APIHELPER fetchHomePageData:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
        @strongify(self);
        [self hideLoadingAnimation];
        if (isSuccess) {
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
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [[UITableViewCell alloc] init];
}

#pragma mark- tableview delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

-(void)touchIDAuth {
    

}

#pragma mark- private Method

@end
