//
//  TheaterDetailViewController.m
//  Base
//
//  Created by admin on 2017/3/6.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "TheaterDetailViewController.h"
#import "TheaterDetailCell.h"
#import "CommentListCell.h"
#import "DetailDervieView.h"
#import <UITableView+FDTemplateLayoutCell.h>
#import "RecentHotView.h"
#import "TheaterModel.h"
#import "DeriveModel.h"
#import "UIViewController+Extension.h"
#import "UITableViewCell+HYCell.h"

@interface TheaterDetailViewController ()

@property(nonatomic,strong)TheaterModel* playInfo;
@property(nonatomic,strong)NSMutableArray* goodList;
@property(nonatomic,strong)NSMutableArray* commentList;
@property(nonatomic,strong)NSMutableArray* commendList;

@property(nonatomic,strong)NSArray* titles;
@property(nonatomic,assign)NSInteger descriptionHight;
@property(nonatomic,assign)BOOL isFold;

@property(nonatomic,assign)NSInteger Id;
@property(nonatomic,assign)BOOL isFav;

@end

@implementation TheaterDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.schemaArgu[@"Id"]) {
        self.Id = [[self.schemaArgu objectForKey:@"Id"] integerValue];
    }
    if (self.schemaArgu[@"isFav"]) {
        self.isFav = [[self.schemaArgu objectForKey:@"isFav"] boolValue];
    }
    self.navigationBarTransparent = YES;
    [self baseSetupTableView:UITableViewStylePlain InSets:UIEdgeInsetsMake(-64, 0, 60, 0)];
    [self.tableView registerNib:[UINib nibWithNibName:[TheaterDetailCell identify] bundle:nil] forCellReuseIdentifier:[TheaterDetailCell identify]];
    [self.tableView registerNib:[UINib nibWithNibName:[CommentListCell identify] bundle:nil] forCellReuseIdentifier:[CommentListCell identify]];
    
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
    NSString* title = self.titles[section];
    if ([title isEqualToString:@"观众点评"]) {
        return self.commentList.count >= 2 ? 3 : self.commentList.count;
    }
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
    NSString* title = self.titles[section];
    if ([title isEqualToString:@"观众点评"]) {
        lbl.text = [NSString stringWithFormat:@"%@(%ld)",title,self.commentList.count];
    }else{
        lbl.text = title;
    }
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
    if (indexPath.row == 2) {
        static NSString* cellId = @"seeAllCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            [HYTool configTableViewCellDefault:cell];
            cell.contentView.backgroundColor = [UIColor whiteColor];
            
            UIButton* btn = [HYTool getButtonWithFrame:CGRectMake((kScreen_Width-90)/2, 0, 90, 48) title:@"查看全部" titleSize:15 titleColor:[UIColor darkGrayColor] backgroundColor:nil blockForClick:^(id sender) {
                //TODO:进入评论列表页面
                APPROUTE(kCommentListController);
            }];
            [btn setImage:ImageNamed(@"下个页面箭头_灰") forState:UIControlStateNormal];
            btn.titleEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 10);
            btn.imageEdgeInsets = UIEdgeInsetsMake(0, 70, 0, -70);
            [cell.contentView addSubview:btn];
        }
        return cell;
    }
    CommentListCell* cell = [tableView dequeueReusableCellWithIdentifier:[CommentListCell identify]];
    [HYTool configTableViewCellDefault:cell];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    
    [cell configListCell:self.commentList[indexPath.row]];
    if (indexPath.row==0) {
        cell.scrollHeight.constant = 0;
        cell.scrollBottom.constant = 0;
    }else{
        cell.scrollHeight.constant = 106;
        cell.scrollBottom.constant = 14;
    }
    cell.topLineVHeight.constant = 0.5;
    [cell addLine:NO leftOffSet:0 rightOffSet:0];
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
            TheaterModel* model = self.commendList[i];
            [view configRecentView:model];
            view.desLbl.font = [UIFont systemFontOfSize:12];
            [view setRecentViewClick:^(TheaterModel *model) {
                APPROUTE(([NSString stringWithFormat:@"%@?isFav=%@&Id=%ld",kTheaterDetailViewController,@(model.isFav),model.playId.integerValue]));
            }];
        }
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
            if (indexPath.row == 2) {
                return 48;
            }
            return [tableView fd_heightForCellWithIdentifier:[CommentListCell identify] cacheByIndexPath:indexPath configuration:^(CommentListCell* cell) {
                
                [cell configListCell:self.commentList[indexPath.row]];
                if (indexPath.row==0) {
                    cell.scrollHeight.constant = 0;
                    cell.scrollBottom.constant = 0;
                }else{
                    cell.scrollHeight.constant = 106;
                    cell.scrollBottom.constant = 14;
                }
                cell.topLineVHeight.constant = 0;
                [cell addLine:NO leftOffSet:0 rightOffSet:0];
            }];
        default:
            return 222;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? 0 : zoom(44);
}

#pragma mark - actions
- (IBAction)buyTicket:(id)sender {
    TheaterModel* model = self.playInfo;
    APPROUTE(([NSString stringWithFormat:@"%@?playId=%ld&img=%@&name=%@&score=%ld&subTitle=%@&time=%@&date=%@&statu=%ld",kTheaterTicketViewController,model.playId.integerValue,model.picurl,model.playName,model.score.integerValue,model.subTitle,model.pctime,model.sydate,model.status.integerValue]));
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
            [self.commentList addObjectsFromArray:responseObject[@"data"][@"comment_list"]];
            [self.commendList addObjectsFromArray:[NSArray yy_modelArrayWithClass:[TheaterModel class] json:responseObject[@"data"][@"commend_list"]]];
            
            [self.tableView reloadData];
        }else{
            [self showMessage:error.userInfo[NSLocalizedDescriptionKey]];
        }
    }];

}

-(void)subviewInit {
    self.title = @"详情";
    [self configNavigation];
}
-(void)configNavigation {
    NSArray* images = self.isFav ? @[@"collect02",@"share"] : @[@"collect01",@"share"];
    @weakify(self);
    [self addDoubleNavigationItemsWithImages:images firstBlock:^{
        @strongify(self);
        if (!self.isFav) {
            //TODO:收藏
            [APIHELPER collect:self.Id type:1 complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
                if (isSuccess) {
                    [self showMessage:@"收藏成功"];
                    self.isFav = !self.isFav;
                    [self configNavigation];
                }else{
                    [self showMessage:error.userInfo[NSLocalizedDescriptionKey]];
                }
            }];
        }else{
            //TODO:取消收藏
            [APIHELPER cancelCollect:self.Id type:1 complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
                if (isSuccess) {
                    [self showMessage:@"取消收藏成功"];
                    self.isFav = !self.isFav;
                    [self configNavigation];
                }else{
                    [self showMessage:error.userInfo[NSLocalizedDescriptionKey]];
                }
            }];
        }
    } secondBlock:^{
        //TODO:分享
        
    }];
}

@end
