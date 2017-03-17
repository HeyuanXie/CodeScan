//
//  MineSupportViewController.m
//  Base
//
//  Created by admin on 2017/3/14.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "MineSupportViewController.h"
#import "MineSupportCell.h"
#import "UITableViewCell+HYCell.h"

@interface MineSupportViewController ()

@property(nonatomic,strong)NSMutableArray* dataArray;

@end

@implementation MineSupportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self baseSetupTableView:UITableViewStylePlain InSets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.tableView registerNib:[UINib nibWithNibName:[MineSupportCell identify] bundle:nil] forCellReuseIdentifier:[MineSupportCell identify]];
    
    [self fetchData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView)
    {
        CGFloat sectionHeaderHeight = 174;
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
}

#pragma mark - talbeView dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray* datas = self.dataArray[section];
    return  datas.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray* datas = self.dataArray[indexPath.section];
    MineSupportCell * cell = [tableView dequeueReusableCellWithIdentifier:[MineSupportCell identify]];
    //TODO:
    [cell addLine:(indexPath.row == datas.count-1) leftOffSet:12 rightOffSet:0];
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView* headView = LOADNIB(@"SkillUseView", 2);
    [self configTableHeaderView:headView model:nil];
    return headView;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView* footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, zoom(15))];
    footView.backgroundColor = [UIColor hyViewBackgroundColor];
    return footView;
}

#pragma mark - tableView delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 48;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 174;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return section == self.dataArray.count-1 ? 0 : zoom(15);
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - private methods
-(NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

-(void)fetchData {
    self.dataArray = [@[@[@"",@""],@[@"",@""]] mutableCopy];
}

-(void)configTableHeaderView:(UIView*)view model:(id)model {
    UIView* skillView = [view viewWithTag:1000];
    UIImageView* imgV = [skillView viewWithTag:1000];
    UILabel* titleLbl = [skillView viewWithTag:1001];
    UILabel* addressLbl = [skillView viewWithTag:1002];
    UILabel* statuLbl = [skillView viewWithTag:1003];
    
    [skillView bk_whenTapped:^{
        //TODO:进入skillDetailVC
    }];

    titleLbl.text = @"第一届东莞儿童飙车大赛";
    
    if (0) {
        [HYTool configViewLayer:statuLbl withColor:[UIColor hyBlackTextColor]];
        statuLbl.textColor = [UIColor hyBlackTextColor];
    }else{
        [HYTool configViewLayer:statuLbl withColor:[UIColor hyRedColor]];
        statuLbl.textColor = [UIColor hyRedColor];
    }
    [HYTool configViewLayer:statuLbl size:10];
}

@end
