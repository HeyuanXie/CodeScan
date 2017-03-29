//
//  FilterTableViewController.m
//  Base
//
//  Created by admin on 2017/3/7.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "FilterTableViewController.h"

@interface FilterTableViewController ()

@property(nonatomic,strong)NSArray* titles;
@property(nonatomic,strong)UIView* backGrayView;

@end

@implementation FilterTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundView = nil;
    self.tableView.tableFooterView = nil;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self.tableView reloadData];
}

-(NSArray *)titles {
    if (!_titles) {
        _titles = @[@"默认排序",@"价格",@"演出时间",@"演出时长",@"好评度"];
    }
    return _titles;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titles.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 240/5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* cellId = @"filterCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreen_Width-32, (240/5-20)/2, 20, 20)];
        imageView.image = ImageNamed(@"选中");
        imageView.tag = 1000;
        [cell.contentView addSubview:imageView];
    }
    cell.textLabel.text = self.titles[indexPath.row];
    cell.textLabel.textColor = self.currentIndex == indexPath.row ? [UIColor hyBlueTextColor] : [UIColor hyBlackTextColor];
    
    UIImageView* imgV = [cell.contentView viewWithTag:1000];
    imgV.hidden = !(self.currentIndex == indexPath.row);
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectIndex) {
        self.selectIndex(indexPath.row);
    }
    self.currentIndex = indexPath.row;
}

@end
