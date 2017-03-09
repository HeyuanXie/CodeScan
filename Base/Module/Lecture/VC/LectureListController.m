//
//  LectureListController.m
//  Base
//
//  Created by admin on 2017/3/8.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "LectureListController.h"
#import "LectureListCell.h"

@interface LectureListController ()

@property(nonatomic,strong)NSMutableArray* dataArray;

@end

@implementation LectureListController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self subviewInit];
    [self fetchData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - tableView delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return self.dataArray.count;
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 250;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LectureListCell* cell = [tableView dequeueReusableCellWithIdentifier:[LectureListCell identify]];
    [HYTool configTableViewCellDefault:cell];
    [cell configListCell:nil];
    [cell setApplyBtnClick:^{
        APPROUTE(([NSString stringWithFormat:@"%@?type=%@",kLectureApplyController,@"onLine"]));
    }];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    APPROUTE(kLectureDetailController);
}


#pragma mark - private methods
-(void)subviewInit {
    self.navigationBarBlue = YES;
    [self baseSetupTableView:UITableViewStylePlain InSets:UIEdgeInsetsMake(0, 0, 0, 0)];
    self.tableView.backgroundColor = [UIColor hyViewBackgroundColor];
    [self.tableView registerNib:[UINib nibWithNibName:[LectureListCell identify] bundle:nil] forCellReuseIdentifier:[LectureListCell identify]];
}

-(void)fetchData {
    
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
