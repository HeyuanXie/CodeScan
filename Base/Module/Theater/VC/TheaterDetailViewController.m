//
//  TheaterDetailViewController.m
//  Base
//
//  Created by admin on 2017/3/6.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "TheaterDetailViewController.h"
#import "TheaterDetailCell.h"

@interface TheaterDetailViewController ()

@property(nonatomic,strong)NSArray* titles;

@end

@implementation TheaterDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBarTransparent = YES;
    [self baseSetupTableView:UITableViewStylePlain InSets:UIEdgeInsetsMake(-64, 0, 60, 0)];
    [self.tableView registerNib:[UINib nibWithNibName:[TheaterDetailCell identify] bundle:nil] forCellReuseIdentifier:[TheaterDetailCell identify]];
    
    [self dataInit];
    [self subviewInit];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - tableView dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.titles.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            return [self topCellForTableView:tableView indexPath:indexPath];
        case 1:
            return [self aroundCellForTableView:tableView indexPath:indexPath];
        case 2:
            return [self commentCellForTableView:tableView indexPath:indexPath];
        default:
            return [self recommendCellForTableView:tableView indexPath:indexPath];
    }
}
//MARK:the cells
-(TheaterDetailCell*)topCellForTableView:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath {
    TheaterDetailCell* cell = [tableView dequeueReusableCellWithIdentifier:[TheaterDetailCell identify]];
    return cell;
}
-(UITableViewCell*)aroundCellForTableView:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath {
    static NSString* cellId = @"aroundCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    return cell;
}
-(UITableViewCell*)commentCellForTableView:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath {
    static NSString* cellId = @"commentCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    return cell;
}
-(UITableViewCell*)recommendCellForTableView:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath {
    static NSString* cellId = @"recommendCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    return cell;
}
#pragma mark - tableView delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            return 397;
        case 1:
            return 138;
        case 2:
            return 245;
        default:
            return 222;
    }
}

#pragma mark - actions
- (IBAction)buyTicket:(id)sender {
    
}

#pragma mark - private methods
-(void)dataInit {
    self.titles = @[@"",@"戏剧周边",@"观众点评",@"演出推荐"];
}

-(void)subviewInit {
    self.title = @"丑小鸭";
    
    UIBarButtonItem* item1 = [[UIBarButtonItem alloc] initWithImage:ImageNamed(@"cart") style:UIBarButtonItemStyleDone target:self action:@selector(collect)];
    UIBarButtonItem* item2 = [[UIBarButtonItem alloc] initWithImage:ImageNamed(@"") style:UIBarButtonItemStyleDone target:self action:@selector(share)];
    self.navigationController.navigationItem.rightBarButtonItems = @[item1,item2];
}
-(void)collect {
    
}
-(void)share {
    
}


@end
