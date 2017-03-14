//
//  SkillSituationController.m
//  Base
//
//  Created by admin on 2017/3/13.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "SkillSituationController.h"
#import "SituationDoubleCell.h"
#import "NSString+Extension.h"
#import "UIImage+HYImages.h"
#import <UITableView+FDTemplateLayoutCell.h>
#import "UIImageView+HYImageView.h"

@interface SkillSituationController ()


@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIImageView *backImgV;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UIButton *voteBtn;

@property (weak, nonatomic) IBOutlet UILabel *menberLbl;
@property (weak, nonatomic) IBOutlet UILabel *voteLbl;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property(nonatomic,strong)NSMutableArray* dataArray;

@end

@implementation SkillSituationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBarTransparent = YES;
    [self baseSetupTableView:UITableViewStylePlain InSets:UIEdgeInsetsMake(287-64, 0, 0, 0)];
    [self.tableView registerNib:[UINib nibWithNibName:[SituationDoubleCell identify] bundle:nil] forCellReuseIdentifier:[SituationDoubleCell identify]];

    [self subviewStyle];
    [self subviewBind];
    [self fetchData];
    // Do any additional setup after loading the view.
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
    
    self.topView.backgroundColor = [UIColor hyViewBackgroundColor];
    [self.backImgV setBlurEffectStyle:UIBlurEffectStyleLight];
    
    self.voteBtn.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2];
    
    UIView* view = self.searchBar.subviews.firstObject;
    for (id obj in view.subviews) {
        if ([obj isKindOfClass:[UIImageView class]]) {
            [((UIImageView*)obj) removeFromSuperview];
            
        }
    }
    [_searchBar setSearchFieldBackgroundImage:[UIImage hyImageWithColor:[UIColor whiteColor] size:CGSizeMake(kScreen_Width-24, 45)] forState:UIControlStateNormal];
}

-(void)subviewBind {
    [self.voteBtn addTarget:self action:@selector(mineVote) forControlEvents:UIControlEventTouchUpInside];
}
-(void)mineVote {
    APPROUTE(kMineSupportViewController);
}



@end
