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
#import "TheaterModel.h"
#import "DeriveModel.h"

#import "APIHelper+Theater.h"
@interface TheaterDetailViewController ()

@property(nonatomic,strong)TheaterModel* playInfo;
@property(nonatomic,strong)NSMutableArray* goodList;
@property(nonatomic,strong)NSMutableArray* commentList;
@property(nonatomic,strong)NSMutableArray* commendList;

@property(nonatomic,strong)NSArray* titles;
@property(nonatomic,assign)NSInteger descriptionHight;
@property(nonatomic,assign)BOOL isFold;

@property(nonatomic,assign)NSInteger Id;

@end

@implementation TheaterDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.schemaArgu[@"Id"]) {
        self.Id = [[self.schemaArgu objectForKey:@"Id"] integerValue];
    }
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
    return self.playInfo == nil ? 0 : self.titles.count;
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
    NSString* imgName = self.isFold ? @"三角形_黑色下" : @"三角形_黑色上";
    [cell.unfoldBtn setImage:ImageNamed(imgName) forState:UIControlStateNormal];
    cell.unfoldBtnHeight.constant = self.descriptionHight < 68 ? 0 : 30;
    [cell configTopCell:self.playInfo];
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
    for (int i = 0; i<self.goodList.count; i++) {
        DeriveModel* model = self.goodList[i];
        DetailDervieView* view = (DetailDervieView*)[[NSBundle mainBundle] loadNibNamed:@"TheaterUseView" owner:self options:nil][0];
        view.frame = CGRectMake(106*i+10, 0, 106, 138);
        [view.imgView sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:ImageNamed(@"elephant")];
        view.titleLbl.text = model.goodName;
        view.priceLbl.text = model.shopPrice;
        [view bk_whenTapped:^{
            APPROUTE(([NSString stringWithFormat:@"%@?id=%ld",kDeriveDetailController,model.goodId.integerValue]));
        }];
        [scrollView addSubview:view];
    }
    scrollView.contentSize = CGSizeMake(10+106*self.goodList.count, 0);
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
                    [cell configTopCell:self.playInfo];
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
                    [cell configTopCell:self.playInfo];
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
- (NSMutableArray *)goodList {
    if (!_goodList) {
        _goodList = [NSMutableArray array];
    }
    return _goodList;
}

- (NSMutableArray *)commentList {
    if (!_commentList) {
        _commentList = [NSMutableArray array];
    }
    return _commentList;
}

- (NSMutableArray *)commendList {
    if (!_commendList) {
        _commendList = [NSMutableArray array];
    }
    return _commendList;
}

-(void)dataInit {
    self.titles = @[@"",@"戏剧周边",@"观众点评",@"演出推荐"];
    self.isFold = YES;  //默认折叠
    
    [self showLoadingAnimation];
    [APIHELPER theaterDetail:self.Id complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
        [self hideLoadingAnimation];
        if (isSuccess) {
            self.playInfo = [TheaterModel yy_modelWithJSON:responseObject[@"data"][@"play_info"]];
            NSString* desc = self.playInfo.desc;
            NSMutableParagraphStyle* style = [[NSMutableParagraphStyle alloc] init];
            [style setLineSpacing:4];
            NSDictionary* attributes = @{NSParagraphStyleAttributeName:style,NSFontAttributeName:[UIFont systemFontOfSize:14]};
            CGRect rect = [desc boundingRectWithSize:CGSizeMake(kScreen_Width-46, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:NULL];
            self.descriptionHight = rect.size.height;
            
            [self.goodList addObjectsFromArray:[NSArray yy_modelArrayWithClass:[DeriveModel class] json:responseObject[@"data"][@"goods_list"]]];
            [self.commentList addObject:responseObject[@"data"][@"comment_list"]];
            [self.commendList addObject:[NSArray yy_modelArrayWithClass:[TheaterModel class] json:responseObject[@"data"][@"commend_list"]]];
            
            self.title = self.playInfo.playName;
            [self.tableView reloadData];
        }else{
            [self showMessage:error.userInfo[NSLocalizedDescriptionKey]];
        }
    }];

}

-(void)subviewInit {
    
    UIBarButtonItem* item1 = [[UIBarButtonItem alloc] initWithImage:ImageNamed(@"cart") style:UIBarButtonItemStyleDone target:self action:@selector(collect)];
    UIBarButtonItem* item2 = [[UIBarButtonItem alloc] initWithImage:ImageNamed(@"") style:UIBarButtonItemStyleDone target:self action:@selector(share)];
    self.navigationController.navigationItem.rightBarButtonItems = @[item1,item2];
}
-(void)collect {
    
}
-(void)share {
    
}


@end
