//
//  WeekEndListController.m
//  Base
//
//  Created by admin on 2017/3/21.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "WeekEndListController.h"
#import "WeekEndCell.h"
#import "WeekEndUseView.h"
#import "WeekEndTopView.h"
#import "NSString+Extension.h"
#import "ArticleModel.h"

@interface WeekEndListController ()

@property(nonatomic,strong)NSMutableArray* dataArray;
@property(nonatomic,assign)NSInteger type;  //类型，1为小飞象资讯、2为周末去哪儿

@property(nonatomic,strong)NSArray* countries;   //镇区names
@property(nonatomic,strong)NSArray* areaIds;            //镇区Ids
@property(nonatomic,assign)NSInteger areaId;
@property(nonatomic,assign)NSInteger cateId;
@property(nonatomic,strong)NSString* selectCountry;
@property(nonatomic,strong)UIButton* rightBtn;  //navigationItem 的btn

@end

@implementation WeekEndListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.schemaArgu[@"type"]) {
        self.type = [[self.schemaArgu objectForKey:@"type"] integerValue];
    }
    
    self.areaId = 291700;
    self.selectCountry = @"东莞市";
    [self.rightBtn setTitle:@"东莞市" forState:UIControlStateNormal];
    
    self.countries = @[@"东莞市",@"莞城区",@"南城区",@"东城区",@"万江区",@"松山区",@"石碣区",@"石龙区",@"茶山区",@"石排区",@"企石区",@"横沥区",@"桥头区",@"谢岗区",@"东坑区",@"常平区",@"寮步区",@"大朗区",@"黄江区",@"清溪区",@"塘厦区",@"凤岗区",@"长安区",@"虎门区",@"厚街区",@"沙田区",@"道滘区",@"洪梅区",@"麻涌区",@"中堂区",@"高埗区",@"樟木头区",@"大岭山区",@"望牛墩区"];
    self.areaIds = @[@(291700),@(291701),@(291702),@(291703),@(291704),@(291733),@(291705),@(291706),@(291707),@(291708),@(291709),@(291710),@(291711),@(291712),@(291713),@(291714),@(291715),@(291716),@(291717),@(291718),@(291719),@(291720),@(291721),@(291722),@(291723),@(291724),@(291725),@(291726),@(291727),@(291728),@(291729),@(291730),@(291731),@(291732)];
    
    [self baseSetupTableView:UITableViewStylePlain InSets:UIEdgeInsetsMake(0, 0, 0, 0)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tableView registerNib:[UINib nibWithNibName:[WeekEndCell identify] bundle:nil] forCellReuseIdentifier:[WeekEndCell identify]];

    [self subviewStyle];
    [self fetchData];
    [self headViewInit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - talbeView dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WeekEndCell* cell = [tableView dequeueReusableCellWithIdentifier:[WeekEndCell identify]];
    cell.allViewHeight.constant = 0;
    cell.allView.hidden = YES;
    [cell configWeekEndCell:self.dataArray[indexPath.row] isCollect:NO];
    return cell;
}

#pragma mark - tableView delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ArticleModel* article = self.dataArray[indexPath.row];
    NSInteger articleId = self.type == 0 ? article.seekId.integerValue : article.articleId.integerValue;
    APPROUTE(([NSString stringWithFormat:@"%@?url=%@&isFav=%@&articleId=%ld&type=%ld&title=%@&summary=%@&img=%@",kWeekEndDetailController,article.sourceUrl,@(article.isFav.boolValue),articleId,article.articleType.integerValue+2,article.title,article.summary,article.img]));
}
#pragma mark - private methods
-(NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

-(void)fetchData {
    [self.dataArray removeAllObjects];
    [self showLoadingAnimation];
    if (self.type == 1) {
        [APIHELPER weekEndArticleAreaId:self.areaId cateId:self.cateId start:0 limit:10 complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
            [self hideLoadingAnimation];
            if (isSuccess) {
                NSArray* articleArr = [NSArray yy_modelArrayWithClass:[ArticleModel class] array:responseObject[@"data"][@"list"]];
                [self.dataArray addObjectsFromArray:articleArr];
                self.haveNext = [responseObject[@"data"][@"have_next"] boolValue];
                if (self.haveNext) {
                    [self appendFooterView];
                }else{
                    [self removeFooterRefresh];
                }
                [self.tableView reloadData];
            }else{
                [self showMessage:error.userInfo[NSLocalizedDescriptionKey]];
            }
        }];
    }else{
        [APIHELPER informationArticleStart:0 limit:10 complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
            [self hideLoadingAnimation];
            if (isSuccess) {
                NSArray* articleArr = [NSArray yy_modelArrayWithClass:[ArticleModel class] array:responseObject[@"data"][@"list"]];
                [self.dataArray addObjectsFromArray:articleArr];
                self.haveNext = [responseObject[@"data"][@"have_next"] boolValue];
                if (self.haveNext) {
                    [self appendFooterView];
                }else{
                    [self removeFooterRefresh];
                }
                [self.tableView reloadData];
            }else{
                [self showMessage:error.userInfo[NSLocalizedDescriptionKey]];
            }
        }];
    }
}
-(void)headViewInit {
    @weakify(self);
    [self addHeaderRefresh:^{
        @strongify(self);
        [self.dataArray removeAllObjects];
        if (self.type == 1) {
            [APIHELPER weekEndArticleAreaId:self.areaId cateId:self.cateId start:0 limit:10 complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
                if (isSuccess) {
                    NSArray* articleArr = [NSArray yy_modelArrayWithClass:[ArticleModel class] array:responseObject[@"data"][@"list"]];
                    [self.dataArray addObjectsFromArray:articleArr];
                    self.haveNext = [responseObject[@"data"][@"have_next"] boolValue];
                    if (self.haveNext) {
                        [self appendFooterView];
                    }else{
                        [self removeFooterRefresh];
                    }
                    [self.tableView reloadData];
                }else{
                    [self showMessage:error.userInfo[NSLocalizedDescriptionKey]];
                }
                [self endRefreshing];
            }];
        }else{
            [APIHELPER informationArticleStart:0 limit:10 complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
                if (isSuccess) {
                    NSArray* articleArr = [NSArray yy_modelArrayWithClass:[ArticleModel class] array:responseObject[@"data"][@"list"]];
                    [self.dataArray addObjectsFromArray:articleArr];
                    self.haveNext = [responseObject[@"data"][@"have_next"] boolValue];
                    if (self.haveNext) {
                        [self appendFooterView];
                    }else{
                        [self removeFooterRefresh];
                    }
                    [self.tableView reloadData];
                }else{
                    [self showMessage:error.userInfo[NSLocalizedDescriptionKey]];
                }
                [self endRefreshing];
            }];
        }
    }];
}
-(void)appendFooterView {
    @weakify(self);
    [self addFooterRefresh:^{
        @strongify(self);
        [self showLoadingAnimation];
        if (self.type == 1) {
            [APIHELPER weekEndArticleAreaId:self.areaId cateId:self.cateId start:self.dataArray.count limit:10 complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
                [self hideLoadingAnimation];
                if (isSuccess) {
                    NSArray* articleArr = [NSArray yy_modelArrayWithClass:[ArticleModel class] array:responseObject[@"data"][@"list"]];
                    [self.dataArray addObjectsFromArray:articleArr];
                    self.haveNext = [responseObject[@"data"][@"have_next"] boolValue];
                    if (self.haveNext) {
                        [self appendFooterView];
                    }else{
                        [self removeFooterRefresh];
                    }
                    [self.tableView reloadData];
                }else{
                    [self showMessage:error.userInfo[NSLocalizedDescriptionKey]];
                }
                [self endRefreshing];
            }];
        }else{
            [APIHELPER informationArticleStart:self.dataArray.count limit:10 complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
                [self hideLoadingAnimation];
                if (isSuccess) {
                    NSArray* articleArr = [NSArray yy_modelArrayWithClass:[ArticleModel class] array:responseObject[@"data"][@"list"]];
                    [self.dataArray addObjectsFromArray:articleArr];
                    self.haveNext = [responseObject[@"data"][@"have_next"] boolValue];
                    if (self.haveNext) {
                        [self appendFooterView];
                    }else{
                        [self removeFooterRefresh];
                    }
                    [self.tableView reloadData];
                }else{
                    [self showMessage:error.userInfo[NSLocalizedDescriptionKey]];
                }
                [self endRefreshing];
            }];
        }
    }];
}

-(void)subviewStyle {
    
    self.title = self.type == 0 ? @"小飞象资讯" : @"周末去哪儿";
    
    self.rightBtn = [HYTool getButtonWithFrame:CGRectMake(0, 0, 110, 36) title:@"镇区" titleSize:17 titleColor:[UIColor whiteColor] backgroundColor:nil blockForClick:nil];
    [self.rightBtn setImage:ImageNamed(@"arrow_down") forState:UIControlStateNormal];
    self.rightBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20);
    self.rightBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 95, 0, 0);
    self.rightBtn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        
        if ([self.view viewWithTag:1000]) {
            [self hideAddressView];
        }else{
            [self showAddressView];
        }
        return [RACSignal empty];
    }];
    if (self.type == 1) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightBtn];
    }
    
    WeekEndTopView* topView = LOADNIB(@"WeekEndUseView", 1);
    CGFloat width = (kScreen_Width-24)/3;
    @weakify(topView);
    [topView setFirstClick:^{
        @strongify(topView);
        [UIView animateWithDuration:0.2 animations:^{
            topView.Line.frame = CGRectMake(22, 98, width-20, 2);
        }];
        self.cateId = 0;
        [self fetchData];
    }];
    [topView setSecondClick:^{
        @strongify(topView);
        [UIView animateWithDuration:0.2 animations:^{
            topView.Line.frame = CGRectMake(22+width, 98, width-20, 2);
        }];
        self.cateId = 1;
        [self fetchData];
    }];
    [topView setThirdClick:^{
        @strongify(topView);
        [UIView animateWithDuration:0.2 animations:^{
            topView.Line.frame = CGRectMake(22+2*width, 98, width-20, 2);
        }];
        self.cateId = 2;
        [self fetchData];
    }];
    
    if (self.type == 1) {
        self.tableView.tableHeaderView = topView;
    }
    
}

-(void)showAddressView {
    
    WeekEndUseView* view = LOADNIB(@"WeekEndUseView", 0);
    if (IS_IPHONE_5s) {
        view.height.constant = 350;
    }
    if (IS_IPHONE_Plus) {
        view.height.constant = 250;
    }
    view.frame = CGRectMake(0, -140, kScreen_Width, kScreen_Height+140);
    view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    [view bk_whenTapped:^{
        [self hideAddressView];
    }];
    view.tag = 1000;
    [self.view addSubview:view];
    
    CGFloat x = 0;CGFloat y = 10;
    for (int i=0; i<self.countries.count; i++) {
        NSString* country = self.countries[i];
        NSInteger areId = [self.areaIds[i] integerValue];
        CGFloat width = [country sizeWithFont:[UIFont systemFontOfSize:16] maxWidth:CGFLOAT_MAX].width;
        UIButton* btn = [HYTool getButtonWithFrame:CGRectMake(x, y, width+20, 38) title:country titleSize:16 titleColor:[UIColor hyBlackTextColor] backgroundColor:nil blockForClick:^(id sender) {
            self.selectCountry = country;
            self.areaId = areId;
            [self.rightBtn setTitle:country forState:UIControlStateNormal];
            [self hideAddressView];
            [self fetchData];
        }];
        if ([country isEqualToString:self.selectCountry]) {
            [btn setTitleColor:[UIColor hyBlueTextColor] forState:UIControlStateNormal];
        }
        [view.botView addSubview:btn];
        x = x + width+20;
        if (x >= kScreen_Width) {
            btn.frame = CGRectMake(0, y+38, width+20, 38);
            x = width+20;
            y = y+38;
        }
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        view.frame = CGRectMake(0, 0, kScreen_Width, kScreen_Height);
    } completion:nil];
    
}

-(void)hideAddressView {
    if ([self.view viewWithTag:1000]) {
        
        UIView* addressView = [self.view viewWithTag:1000];
        [UIView animateWithDuration:0.3 animations:^{
            addressView.frame = CGRectMake(0, -140, kScreen_Width, kScreen_Height+140);
            addressView.alpha = 0;
        } completion:^(BOOL finished) {
            [addressView removeFromSuperview];
        }];
    }
}

@end
