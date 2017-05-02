//
//  CollectViewController.m
//  Base
//
//  Created by admin on 2017/3/6.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "CollectViewController.h"
#import "TheaterListCell.h"
#import "NewsCell.h"
#import "WeekEndCell.h"
#import "DeriveListCell.h"
#import "TheaterModel.h"
#import "UIViewController+Extension.h"
#import "UITableViewCell+HYCell.h"
#import "NSString+Extension.h"
#import "CustomJumpBtns.h"
#import "HYAlertView.h"

typedef enum : NSUInteger {
    TypeTheater = 1,
    TypeNews,
    TypeWeekEnd,
    TypeDerive
} ContentType;

@interface CollectViewController ()

@property(strong,nonatomic)NSArray* titles;
@property(assign,nonatomic)ContentType contentType;
@property(strong,nonatomic)NSMutableArray* dataArray;
@property (weak, nonatomic) IBOutlet UIScrollView *topScroll;

@end

@implementation CollectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.backItemHidden = YES;
    self.haveTableFooter = YES;
    self.contentType = 1;
    self.titles = @[@"亲子剧场",@"资讯",@"周末去哪儿",@"衍生品"];
    [self baseSetupTableView:UITableViewStylePlain InSets:UIEdgeInsetsMake(zoom(42), 0, 0, 0)];
    [self.tableView registerNib:[UINib nibWithNibName:[TheaterListCell identify] bundle:nil] forCellReuseIdentifier:[TheaterListCell identify]];
    [self.tableView registerNib:[UINib nibWithNibName:[NewsCell identify] bundle:nil] forCellReuseIdentifier:[NewsCell identify]];
    [self.tableView registerNib:[UINib nibWithNibName:[WeekEndCell identify] bundle:nil] forCellReuseIdentifier:[WeekEndCell identify]];
    [self.tableView registerNib:[UINib nibWithNibName:[DeriveListCell identify] bundle:nil] forCellReuseIdentifier:[DeriveListCell identify]];

    
    [self subviewStyle];
    [self headerViewInit];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    [self fetchData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - talbeView dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger line = self.dataArray.count / 2,col = self.dataArray.count % 2;
    return self.contentType == TypeDerive ? line + col : 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contentType == TypeDerive ? 1 : self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (self.contentType) {
        case TypeTheater:
        {
            TheaterListCell* cell = [tableView dequeueReusableCellWithIdentifier:[TheaterListCell identify]];
            [HYTool configTableViewCellDefault:cell];
            
            NSDictionary* model = self.dataArray.count == 0 ? nil : self.dataArray[indexPath.row];
            TheaterModel* theater = [TheaterModel yy_modelWithDictionary:model];
            [cell configTheaterListCell:theater];
            [cell setTicketBtnClick:^(id model) {
                //取消收藏
                [APIHELPER cancelCollect:theater.playId.integerValue type:1 complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
                    if (isSuccess) {
                        [self showMessage:@"取消收藏成功"];
                        [self fetchData];
                    }else{
                        [self showMessage:error.userInfo[NSLocalizedDescriptionKey]];
                    }
                }];
            }];
            cell.collectBtn.hidden = YES;
            cell.ticketBtnWidth.constant = 80;
            [cell.ticketBtn setTitle:@"取消收藏" forState:UIControlStateNormal];
            
            return cell;
        }
        case TypeNews:
        {
            NewsCell* cell = [tableView dequeueReusableCellWithIdentifier:[NewsCell identify]];
            [HYTool configTableViewCellDefault:cell];
            cell.contentView.backgroundColor = [UIColor whiteColor];
            cell.allViewHeight.constant = 0;
            cell.allView.hidden = YES;
            
            NSDictionary* dict = self.dataArray.count == 0 ? nil : self.dataArray[indexPath.row];
            [cell configNewsCell:[ArticleModel yy_modelWithDictionary:dict] isCollect:YES];
            [cell setCancelCollect:^(ArticleModel * model) {
                //取消收藏
                [APIHELPER cancelCollect:model.seekId.integerValue type:2 complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
                    if (isSuccess) {
                        [self showMessage:@"取消收藏成功"];
                        [self fetchData];
                    }else{
                        [self showMessage:error.userInfo[NSLocalizedDescriptionKey]];
                    }
                }];
            }];
            [cell addLine:NO leftOffSet:12 rightOffSet:0];
            return cell;
        }
        case TypeWeekEnd:
        {
            WeekEndCell* cell = [tableView dequeueReusableCellWithIdentifier:[WeekEndCell identify]];
            [HYTool configTableViewCellDefault:cell];
            cell.contentView.backgroundColor = [UIColor whiteColor];
            cell.allViewHeight.constant = 0;
            cell.allView.hidden = YES;
            
            NSDictionary* dict = self.dataArray.count == 0 ? nil : self.dataArray[indexPath.row];
            [cell configWeekEndCell:[ArticleModel yy_modelWithDictionary:dict] isCollect:YES];
            [cell setCancelCollect:^(ArticleModel * model) {
                //取消收藏
                [APIHELPER cancelCollect:model.articleId.integerValue type:3 complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
                    if (isSuccess) {
                        [self showMessage:@"取消收藏成功"];
                        [self fetchData];
                    }else{
                        [self showMessage:error.userInfo[NSLocalizedDescriptionKey]];
                    }
                }];
            }];
            [cell addLine:NO leftOffSet:12 rightOffSet:0];
            return cell;
        }
        case TypeDerive:
        {
            DeriveListCell* cell = [tableView dequeueReusableCellWithIdentifier:[DeriveListCell identify]];
            [HYTool configTableViewCellDefault:cell];
            cell.contentView.backgroundColor = [UIColor hyViewBackgroundColor];
            
            DeriveModel* leftModel = [DeriveModel yy_modelWithDictionary:self.dataArray[indexPath.section*2]];
            DeriveModel* rightModel = [DeriveModel yy_modelWithDictionary:(self.dataArray.count%2!=0 && self.dataArray.count/2==indexPath.section) ? nil : self.dataArray[indexPath.section*2+1]];
            [cell configListCellWithLeft:leftModel right:rightModel isCollect:YES];
            [cell setItemClick:^(DeriveModel* model) {
                APPROUTE(([NSString stringWithFormat:@"%@?id=%ld&isFav=%@&sourceUrl=%@",kDeriveDetailController,model.goodId.integerValue,@(YES),model.sourceUrl]));
            }];
            [cell setExchangeClick:^(DeriveModel* model) {
                //取消收藏
                [APIHELPER cancelCollect:model.goodId.integerValue type:4 complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
                    if (isSuccess) {
                        [self showMessage:@"取消收藏成功"];
                        [self fetchData];
                    }else{
                        [self showMessage:error.userInfo[NSLocalizedDescriptionKey]];
                    }
                }];
            }];
            return cell;
        }
        default:
            break;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView* headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, zoom(12))];
    headView.backgroundColor = [UIColor hyViewBackgroundColor];
    return headView;
}

#pragma mark - tableView delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (self.contentType) {
        case TypeTheater:
            return 173;
        case TypeNews:
            return 120;
        case TypeWeekEnd:
            return 120;
        case TypeDerive:
            return 230;
        default:
            return 0;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return self.contentType == TypeDerive ? zoom(12) : 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary* model = self.dataArray[indexPath.row];
    
    switch (self.contentType) {
        case TypeTheater:
            APPROUTE(([NSString stringWithFormat:@"%@?Id=%ld&isFav=%@",kTheaterDetailViewController,[model[@"play_id"] integerValue],@(YES)]));
            break;
        case TypeDerive:
        {
            break;
        }
        case TypeNews:
        {
            //资讯
            NSInteger articleId = [model[@"seek_id"] integerValue];
            NSInteger type = [model[@"type"] integerValue];
            APPROUTE(([NSString stringWithFormat:@"%@?isFav=%@&articleId=%ld&type=%ld&url=%@&title=%@&summary=%@&img=%@",kWeekEndDetailController,@(YES),articleId,type,model[@"source_url"],model[@"title"],model[@"summary"],model[@"img"]]));
            break;
        }
        default:
        {
            //周末去哪儿
            NSInteger articleId = [model[@"article_id"] integerValue];
            NSInteger type = [model[@"type"] integerValue];
            APPROUTE(([NSString stringWithFormat:@"%@?isFav=%@&articleId=%ld&type=%ld&url=%@&title=%@&summary=%@&img=%@",kWeekEndDetailController,@(YES),articleId,type,model[@"source_url"],model[@"title"],model[@"summary"],model[@"img"]]));
            break;
        }
    }
}
#pragma mark - private methods
-(NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

-(void)subviewStyle {
    
    [self configMessage];
    
    CGFloat width = [self.titles[0] sizeWithFont:[UIFont systemFontOfSize:15] maxWidth:CGFLOAT_MAX].width;
    CustomJumpBtns* btns = [CustomJumpBtns customBtnsWithFrame:CGRectMake(0, 0, MAX(width*self.titles.count, kScreen_Width) , 42) menuTitles:self.titles textColorForNormal:[UIColor hyBlackTextColor] textColorForSelect:[UIColor hyBlueTextColor] isLineAdaptText:YES];
    [btns setFinished:^(NSInteger index) {
        self.contentType = index+1;
        [self fetchData];
    }];
    [self.topScroll addSubview:btns];
    self.topScroll.contentSize = CGSizeMake(self.titles.count*width, 0);
}

- (void)fetchData {

    [self.dataArray removeAllObjects];
    [self.tableView reloadData];
    self.tableView.tableFooterView = nil;
    [self showLoadingAnimation];
    [APIHELPER fetchCollectList:self.dataArray.count limit:8 type:self.contentType complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
        [self hideLoadingAnimation];
        
        if (isSuccess) {
            [self.dataArray addObjectsFromArray:responseObject[@"data"][@"list"]];
            [self.tableView reloadData];
            
            self.haveNext = [responseObject[@"data"][@"have_next"] boolValue];
            if (self.haveNext) {
                [self appendFooterView];
            }else{
                [self removeFooterRefresh];
            }
        }else{
            [self showMessage:error.userInfo[NSLocalizedDescriptionKey]];
        }
    }];
}

-(void)headerViewInit {
    @weakify(self);
    [self addHeaderRefresh:^{
        @strongify(self);
        [self showLoadingAnimation];
        [APIHELPER fetchCollectList:0 limit:8 type:self.contentType complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
            [self hideLoadingAnimation];
            
            if (isSuccess) {
                [self.dataArray removeAllObjects];
                [self.dataArray addObjectsFromArray:responseObject[@"data"][@"list"]];
                [self.tableView reloadData];
                
                self.haveNext = [responseObject[@"data"][@"have_next"] boolValue];
                if (self.haveNext) {
                    [self appendFooterView];
                }else{
                    [self removeFooterRefresh];
                }
            }else{
                [self showMessage:error.userInfo[NSLocalizedDescriptionKey]];
            }
            [self endRefreshing];
        }];
    }];
}

-(void)appendFooterView {
    @weakify(self);
    [self addFooterRefresh:^{
        @strongify(self);
        [self showLoadingAnimation];
        [APIHELPER fetchCollectList:self.dataArray.count limit:8 type:self.contentType complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
            [self hideLoadingAnimation];
            
            if (isSuccess) {
                [self.dataArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:[DeriveModel class] array:responseObject[@"data"][@"list"]] ];
                [self.tableView reloadData];
                
                self.haveNext = [responseObject[@"data"][@"have_next"] boolValue];
                if (self.haveNext) {
                    [self appendFooterView];
                }else{
                    [self removeFooterRefresh];
                }
            }else{
                [self showMessage:error.userInfo[NSLocalizedDescriptionKey]];
            }
            [self endRefreshing];
        }];
    }];
}

@end
