//
//  YearCardHomeController.m
//  Base
//
//  Created by admin on 2017/3/9.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "YearCardHomeController.h"
#import "HomeTopCell.h"
#import "HomeSecondCell.h"
#import "APIHelper+YearCard.h"

@interface YearCardHomeController ()

@end

@implementation YearCardHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self baseSetupTableView:UITableViewStylePlain InSets:UIEdgeInsetsMake(0, 0, 90, 0)];
    [self.tableView registerNib:[UINib nibWithNibName:[HomeTopCell identify] bundle:nil] forCellReuseIdentifier:[HomeTopCell identify]];
    [self.tableView registerNib:[UINib nibWithNibName:[HomeSecondCell identify] bundle:nil] forCellReuseIdentifier:[HomeSecondCell identify]];

    [self subviewInit];
    [self fetchData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - talbeView dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
        {
            HomeTopCell* cell = [tableView dequeueReusableCellWithIdentifier:[HomeTopCell identify]];
            [HYTool configTableViewCellDefault:cell];
            [cell configTopCell:nil];
            return cell;
            break;
        }
        case 1:
        {
            HomeSecondCell* cell = [tableView dequeueReusableCellWithIdentifier:[HomeSecondCell identify]];
            [HYTool configTableViewCellDefault:cell];
            return cell;
        }
        default:
        {
            static NSString* cellId = @"descCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
                [HYTool configTableViewCellDefault:cell];
                UIImageView* imgV = [[UIImageView alloc] initWithImage:ImageNamed(@"")];
                imgV.backgroundColor = [UIColor whiteColor];
                [cell.contentView addSubview:imgV];
                [imgV autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 12, 0, 12)];
            }
            return cell;
        }
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, zoom(15))];
    headerView.backgroundColor = [UIColor hyViewBackgroundColor];
    return section == 0 ? nil : headerView;
}
#pragma mark - tableView delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            return 304;
        case 1:
            return 76;
        default:
            return 113;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? 0 : zoom(15);
}


#pragma mark - private methods
-(void)fetchData {
    [APIHELPER fetchYearCardInfoComplete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
        if (isSuccess) {
            
        }
    }];
}


-(void)subviewInit {
    
//    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc] initWithImage:ImageNamed(@"") style:UIBarButtonItemStylePlain target:self action:@selector(message:)];
//    self.navigationController.navigationItem.rightBarButtonItem = rightItem;
}

-(void)message:(UIBarButtonItem*)item {
    //TODO:
//    APPROUTE(kMessageController)
}

@end
