//
//  SkillDetailController.m
//  Base
//
//  Created by admin on 2017/3/13.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "SkillDetailController.h"
#import "UIViewController+Extension.h"
#import "SituationDoubleCell.h"
#import "NSString+Extension.h"
#import "UIImage+HYImages.h"
#import <UITableView+FDTemplateLayoutCell.h>
#import "UIImageView+HYImageView.h"
#import "SkillDetailHeadView.h"

@interface SkillDetailController ()

@property (weak, nonatomic) IBOutlet UILabel *priceLbl;
@property(strong,nonatomic)NSString* skillId;

@property(nonatomic,strong)NSMutableArray* dataArray;

@end

@implementation SkillDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.schemaArgu[@"skillId"]) {
        self.skillId = [self.schemaArgu objectForKey:@"skillId"];
    }

    self.navigationBarTransparent = YES;
    [self baseSetupTableView:UITableViewStylePlain InSets:UIEdgeInsetsMake(-64, 0, zoom(60), 0)];
    [self.tableView registerNib:[UINib nibWithNibName:[SituationDoubleCell identify] bundle:nil] forCellReuseIdentifier:[SituationDoubleCell identify]];
    
    [self subviewStyle];
    [self fetchData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - talbeView dataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger line = self.dataArray.count / 2;
    NSInteger row = self.dataArray.count % 2;
    return line + row;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SituationDoubleCell* cell = [tableView dequeueReusableCellWithIdentifier:[SituationDoubleCell identify]];
    [HYTool configTableViewCellDefault:cell];
    //TODO:
    [cell configDoubleCellWithLeftModel:nil rightModel:nil];
    [cell setItemClick:^(id model) {
        APPROUTE(([NSString stringWithFormat:@"%@",kSkillCompetitorController]));
    }];
    [cell setSupportClick:^(id model) {
        DLog(@"support");
    }];
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView* headView = LOADNIB(@"HomeUseView", 1);
    UILabel* label = [headView viewWithTag:1001];
    label.text = @"排行榜";
    return headView;
}
#pragma mark - tableView delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView fd_heightForCellWithIdentifier:[SituationDoubleCell identify] cacheByIndexPath:indexPath configuration:^(SituationDoubleCell* cell) {
        [cell configDoubleCellWithLeftModel:nil rightModel:nil];
        [cell setItemClick:^(id model) {
            APPROUTE(([NSString stringWithFormat:@"%@",kSkillCompetitorController]));
        }];
        [cell setSupportClick:^(id model) {
            DLog(@"support");
        }];
    }];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return zoom(44);
}

#pragma mark - private methods
-(NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
-(void)fetchData{
    self.dataArray = [@[@"",@""] mutableCopy];
    [self.tableView reloadData];
}

-(void)subviewStyle {
    
    [self configNavigationItem];
    
    SkillDetailHeadView* headView = LOADNIB(@"SkillUseView", 1);
    [headView setSearchFinish:^(NSString *text) {
        //TODO:search
    }];
    [headView configHeadView:nil];
    self.tableView.tableHeaderView = headView;
}
-(void)configNavigationItem {
    //TODO:rightItems
    [self addDoubleNavigationItemsWithImages:@[@"search02",@"search02"] firstBlock:^{
        //TODO:收藏
        DLog(@"收藏");
    } secondBlock:^{
        //TODO:分享
        DLog(@"分享");
    }];
}

#pragma mark - IBActions
- (IBAction)skillApply:(id)sender {
    //TODO:是否传递价格
    APPROUTE(kSkillApplyViewController);
}

@end
