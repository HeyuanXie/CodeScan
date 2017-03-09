//
//  TheaterDetailViewController.m
//  Base
//
//  Created by admin on 2017/3/6.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "TheaterDetailViewController.h"
#import "TheaterDetailCell.h"
#import "DetailDervieView.h"
#import <UITableView+FDTemplateLayoutCell.h>
#import "RecentHotView.h"

@interface TheaterDetailViewController ()

@property(nonatomic,strong)NSArray* titles;
@property(nonatomic,assign)NSInteger descriptionHight;
@property(nonatomic,assign)BOOL isFold;

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


#pragma mark - scrollView delegate
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
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView* headerView = [[NSBundle mainBundle] loadNibNamed:@"HomeUseView" owner:self options:nil][1];
    UILabel* lbl = (UILabel*)[headerView viewWithTag:1001];
    lbl.text = self.titles[section];
    return section == 0 ? nil : headerView;
}

//MARK:the cells
-(TheaterDetailCell*)topCellForTableView:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath {
    TheaterDetailCell* cell = [tableView dequeueReusableCellWithIdentifier:[TheaterDetailCell identify]];
    [HYTool configTableViewCellDefault:cell];
    [cell setUnfoldBtnClick:^{
        self.isFold = !self.isFold;
        [self.tableView reloadData];
    }];
    cell.isFold = self.isFold;
    cell.unfoldBtnHeight.constant = self.descriptionHight < 68 ? 0 : 30;
    [cell configTopCell:nil];
    return cell;
}
-(UITableViewCell*)aroundCellForTableView:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath {
    static NSString* cellId = @"aroundCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        UIScrollView* scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 138)];
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.delegate = self;
        scrollView.tag = 1000;
        [cell.contentView addSubview:scrollView];
    }
    UIScrollView* scrollView = (UIScrollView*)[cell.contentView viewWithTag:1000];
    for (int i = 0; i<7; i++) {
        DetailDervieView* view = (DetailDervieView*)[[NSBundle mainBundle] loadNibNamed:@"TheaterUseView" owner:self options:nil][0];
        view.frame = CGRectMake(106*i+10, 0, 106, 138);
        [scrollView addSubview:view];
    }
    scrollView.contentSize = CGSizeMake(10+106*7, 0);
    return cell;
}

-(UITableViewCell*)commentCellForTableView:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath {
    static NSString* cellId = @"commentCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        [HYTool configTableViewCellDefault:cell];
    }
    return cell;
}
-(UITableViewCell*)recommendCellForTableView:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath {
    static NSString* cellId = @"recommendCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        [HYTool configTableViewCellDefault:cell];
        CGFloat width = (kScreen_Width-40)/3;
        for (int i = 0; i<3; i++) {
            RecentHotView* view = [[NSBundle mainBundle] loadNibNamed:@"HomeUseView" owner:self options:nil][0];
            [cell.contentView addSubview:view];
            [view autoPinEdgeToSuperviewEdge:ALEdgeTop];
            [view autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10+(width+10)*i];
            [view autoSetDimensionsToSize:[RecentHotView showDetailSize]];
            view.tag = 1000 + i;
        }
        
        //TODO:configHotView
        
    }
    return cell;
}
#pragma mark - tableView delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            if (!self.isFold) {
                return [tableView fd_heightForCellWithIdentifier:[TheaterDetailCell identify] cacheByIndexPath:indexPath configuration:^(TheaterDetailCell* cell) {
                    [HYTool configTableViewCellDefault:cell];
                    [cell setUnfoldBtnClick:^{
                        self.isFold = !self.isFold;
                        [self.tableView reloadData];
                    }];
                    cell.isFold = self.isFold;
                    cell.unfoldBtnHeight.constant = self.descriptionHight < 68 ? 0 : 30;
                    [cell configTopCell:nil];
                }];
            }else{
                return [tableView fd_heightForCellWithIdentifier:[TheaterDetailCell identify] configuration:^(TheaterDetailCell* cell) {
                    [HYTool configTableViewCellDefault:cell];
                    [cell setUnfoldBtnClick:^{
                        self.isFold = !self.isFold;
                        [self.tableView reloadData];
                    }];
                    cell.isFold = self.isFold;
                    cell.unfoldBtnHeight.constant = self.descriptionHight < 68 ? 0 : 30;
                    [cell configTopCell:nil];
                }];
            }
        case 1:
            return 138;
        case 2:
            return 245;
        default:
            return 222;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? 0 : zoom(44);
}

#pragma mark - actions
- (IBAction)buyTicket:(id)sender {
    APPROUTE(kTheaterTicketViewController);
}

#pragma mark - private methods
-(void)dataInit {
    self.titles = @[@"",@"戏剧周边",@"观众点评",@"演出推荐"];
    self.isFold = YES;  //默认折叠
    
//    [APIHELPER ]
    NSString* desc = @"阿萨德法师法师法师打发的方式是打发发生的发生发大水]阿斯达所阿萨德法师法师法师打发的方式是打发发生的发生发大水法法师打发斯蒂芬啊实打实大水电费阿萨德法师法师法师打发的方式是打发发生的发生发大水法法师打发斯蒂芬阿萨德法师法师法师打发的方式是打发发生的发生发大水法法师打发斯蒂芬阿萨德法师法师法师打发的方式是打发发生的发生发大水法法师打发斯蒂芬阿萨德法师法师法师打发的方式是打发发生的发生发大水法法师打发斯蒂芬啊啊啊";
    NSMutableParagraphStyle* style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:4];
    NSDictionary* attributes = @{NSParagraphStyleAttributeName:style,NSFontAttributeName:[UIFont systemFontOfSize:14]};
    
    CGRect rect = [desc boundingRectWithSize:CGSizeMake(kScreen_Width-46, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:NULL];
    self.descriptionHight = rect.size.height;
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
