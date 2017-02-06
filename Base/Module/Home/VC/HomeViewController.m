//
//  HomeViewController.m
//  Base
//
//  Created by admin on 17/1/16.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "HomeViewController.h"
#import <UIView+BlocksKit.h>
#import "ThreeImgCell.h"
#import "HomeDeclareView.h"
#import "HomeNewsCell.h"
#import "HYSearchBar.h"
#import <UITableView+FDTemplateLayoutCell.h>
#import "APIHelper+Home.h"
#import "ZMDHomeData.h"

@interface HomeViewController ()<UITextFieldDelegate>

@property(nonatomic,strong)NSArray* info;
@property(nonatomic,strong)NSMutableArray* newsArray;
@property(nonatomic,strong)ZMDHomeData* data;

@end

@implementation HomeViewController

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
             [self showMessage:error.userInfo[NSLocalizedDescriptionKey]];
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
            self.tableView.fd_debugLogEnabled = YES;
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
        default:
            return [tableView fd_heightForCellWithIdentifier:[HomeNewsCell identify] cacheByIndexPath:indexPath configuration:^(HomeNewsCell* cell) {
                [cell configCellWithModel:self.data.news[indexPath.row]];
            }];
            break;
    }
}

#pragma mark- private Method
-(UITableViewCell*)tableView:(UITableView *)tableView bannerCellForIndexPath:(NSIndexPath*)indexPath {
    
    return [[UITableViewCell alloc] init];
}
            
-(UITableViewCell*)tableView:(UITableView *)tableView menuCellForIndexPath:(NSIndexPath*)indexPath {
    ThreeImgCell* menuCell = [tableView dequeueReusableCellWithIdentifier:[ThreeImgCell identify]];
    [menuCell setPolicy:^{
        APPROUTE(kPolicyListController);
    }];
    [menuCell setGuide:^{

    }];
    [menuCell setDemand:^{

        
    }];
    return menuCell;
}
-(UITableViewCell*)tableView:(UITableView *)tableView declareCellForIndexPath:(NSIndexPath*)indexPath {
    
    return [[UITableViewCell alloc] init];
}
-(UITableViewCell*)tableView:(UITableView *)tableView newsCellForIndexPath:(NSIndexPath*)indexPath {
    
    HomeNewsCell* newsCell = [tableView dequeueReusableCellWithIdentifier:[HomeNewsCell identify]];
    [newsCell configCellWithModel:self.data.news[indexPath.row]];
    return newsCell;
}

@end
