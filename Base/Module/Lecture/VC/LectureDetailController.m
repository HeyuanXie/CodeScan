//
//  LectureDetailController.m
//  Base
//
//  Created by admin on 2017/3/9.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "LectureDetailController.h"
#import "LectureDetailTopCell.h"
#import "LectureDescCell.h"
#import "LectureApplyerCell.h"

#import <UITableView+FDTemplateLayoutCell.h>

@interface LectureDetailController ()

@property (weak, nonatomic) IBOutlet UILabel *priceLbl;
@property (weak, nonatomic) IBOutlet UIButton *applyBtn;

@property(nonatomic,assign) BOOL isFold;
@property(nonatomic,strong) NSArray* infos;
@property(nonatomic,assign) CGFloat descriptionHeight;


@end

@implementation LectureDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self subviewInit];
    [self subviewBind];
    [self fetchData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView)
    {
        CGFloat sectionHeaderHeight = zoom(44);
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
    if (scrollView.contentOffset.y >= 64) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }else{
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
}

#pragma mark - tableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.infos.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            return 317;
        case 1:
            if (!self.isFold) {
                return [tableView fd_heightForCellWithIdentifier:[LectureDescCell identify] cacheByIndexPath:indexPath configuration:^(LectureDescCell* cell) {
                    
                    [HYTool configTableViewCellDefault:cell];
                    cell.isFold = self.isFold;
                    @weakify(self);
                    [cell setUnfoldBtnClick:^{
                        @strongify(self);
                        self.isFold = !self.isFold;
                        [self.tableView reloadSections:[[NSIndexSet alloc] initWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
                    }];
                    [cell configDescCell:nil];
                    cell.unfoldBtnHeight.constant = self.descriptionHeight < 68 ? 0 : 30;
                }];
            }else{
                return [tableView fd_heightForCellWithIdentifier:[LectureDescCell identify] configuration:^(LectureDescCell* cell) {
                    [HYTool configTableViewCellDefault:cell];
                    cell.isFold = self.isFold;
                    @weakify(self);
                    [cell setUnfoldBtnClick:^{
                        @strongify(self);
                        self.isFold = !self.isFold;
                        [self.tableView reloadSections:[[NSIndexSet alloc] initWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
                    }];
                    [cell configDescCell:nil];
                    cell.unfoldBtnHeight.constant = self.descriptionHeight < 68 ? 0 : 30;
                }];
            }
//            return 367;
        default:
            return [LectureApplyerCell height:nil];
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
        {
            LectureDetailTopCell* topCell = [tableView dequeueReusableCellWithIdentifier:[LectureDetailTopCell identify]];
            [HYTool configTableViewCellDefault:topCell];
            [topCell configTopCell:nil];
            return topCell;
        }
        case 1:
        {
            LectureDescCell* cell = [tableView dequeueReusableCellWithIdentifier:[LectureDescCell identify]];
            [HYTool configTableViewCellDefault:cell];
            cell.isFold = self.isFold;
            @weakify(self);
            [cell setUnfoldBtnClick:^{
                @strongify(self);
                self.isFold = !self.isFold;
                [self.tableView reloadSections:[[NSIndexSet alloc] initWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
            }];
            [cell configDescCell:nil];
            cell.unfoldBtnHeight.constant = self.descriptionHeight < 68 ? 0 : 30;
            return cell;
        }
        default:
        {
            LectureApplyerCell* cell = [tableView dequeueReusableCellWithIdentifier:[LectureApplyerCell identify]];
            [HYTool configTableViewCellDefault:cell];
            [cell setSeeAll:^{
                //TODO:查看全部报名者
                
            }];
            [cell configApplyerCell:nil];
            return cell;
        }
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? 0 : zoom(44);
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView* headView = LOADNIB(@"HomeUseView", 1);
    UILabel* label = [headView viewWithTag:1001];
    label.text = self.infos[section];
    return section == 0 ? nil : headView;
}



#pragma mark - private methods
- (void)fetchData {
    NSString* desc = @"啊实打实大水电费啊实打实地方阿萨德法师法师阿斯蒂芬啊实打实地方阿萨德法师法师法师打发的方式是打发发生的发生发大水法法师打发斯蒂芬阿萨德法师法师法师打发的方式是打发发生的发生发大水法法师打发斯蒂芬阿萨德法师法师法师打发的方式是打发发生的发生发大水法法师打发斯蒂芬";
    NSMutableParagraphStyle* style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:4];
    NSDictionary* attributes = @{NSParagraphStyleAttributeName:style,NSFontAttributeName:[UIFont systemFontOfSize:14]};
    
    CGRect rect = [desc boundingRectWithSize:CGSizeMake(kScreen_Width-46, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:NULL];
    self.descriptionHeight = rect.size.height;
}

- (void)subviewInit {
    
    self.navigationBarTransparent = YES;
    
    [self baseSetupTableView:UITableViewStylePlain InSets:UIEdgeInsetsMake(-64, 0, zoom(60), 0)];
    [self.tableView registerNib:[UINib nibWithNibName:[LectureDetailTopCell identify] bundle:nil] forCellReuseIdentifier:[LectureDetailTopCell identify]];
    [self.tableView registerNib:[UINib nibWithNibName:[LectureDescCell identify] bundle:nil] forCellReuseIdentifier:[LectureDescCell identify]];
    [self.tableView registerNib:[UINib nibWithNibName:[LectureApplyerCell identify] bundle:nil] forCellReuseIdentifier:[LectureApplyerCell identify]];
    
    self.isFold = YES;
    self.infos = @[@"",@"活动介绍",@"已报名"];


}

- (void)subviewBind {
    if (0) {
        [self.applyBtn setTitle:@"进入直播间" forState:UIControlStateNormal];
        
    }
    [self.applyBtn addTarget:self action:@selector(apply:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)apply:(UIButton*)btn {
    if (0) {
        //TODO:进入直播间
        return;
    }
    APPROUTE(([NSString stringWithFormat:@"%@?type=%@",kLectureApplyController,@"offLine"]));
}


@end
