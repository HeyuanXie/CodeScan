//
//  SkillListViewController.m
//  Base
//
//  Created by admin on 2017/3/13.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "SkillListViewController.h"
#import "SkillDetailController.h"
#import "SkillListCell.h"
#import "UIViewController+Extension.h"

@interface SkillListViewController ()

@property(nonatomic,strong)NSMutableArray* dataArray;

@end

@implementation SkillListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self baseSetupTableView:UITableViewStylePlain InSets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.tableView registerNib:[UINib nibWithNibName:[SkillListCell identify] bundle:nil] forCellReuseIdentifier:[SkillListCell identify]];

    [self subviewInit];
    [self fetchData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - tableview dataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SkillListCell* cell = [tableView dequeueReusableCellWithIdentifier:[SkillListCell identify]];
    [HYTool configTableViewCellDefault:cell];
    [cell configListCell:nil];
    return cell;
}

#pragma mark - tableView delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 287;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //TODO:进入才艺竞赛详情
    APPROUTE(([NSString stringWithFormat:@"%@?skillId=%@",kSkillDetailController,@"1"]));
}

#pragma mark - private methods
-(NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
-(void)fetchData{
    
}
-(void)subviewInit {
    //TODO:rightItems(我的报名快捷入口、消息)
    [self addDoubleNavigationItemsWithImages:@[@"search02",@"search02"] firstBlock:^{
        //TODO:我的报名快捷入口
        DLog(@"我的报名");
    } secondBlock:^{
        //TODO:消息
        DLog(@"消息");
    }];
}
-(void)mineApply {
    
}
-(void)message {
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
