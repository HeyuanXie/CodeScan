//
//  SearchResultController.m
//  Base
//
//  Created by admin on 2017/3/23.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "SearchResultController.h"
#import "WeekEndDetailController.h"
#import "FTPopOverMenu.h"
#import "TheaterListCell.h"
#import "WeekEndCell.h"
#import "SearchDeriveCell.h"

typedef enum : NSUInteger {
    ContentTypeTheater = 0,
    ContentTypeDerive,
    ContentTypeArticle,
} ContentType;

@interface SearchResultController ()<UITextFieldDelegate>

@property(nonatomic,strong)NSMutableArray* dataArray;
@property(nonatomic,assign)ContentType contentType;

@property(nonatomic,strong)UITextField* textField;
@property(nonatomic,strong)NSString* word;  //关键字

@end

@implementation SearchResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.contentType = ContentTypeArticle;  //默认为文章
    if (self.schemaArgu[@"type"]) {
        self.contentType = [[self.schemaArgu objectForKey:@"type"] integerValue];
    }
    if (self.schemaArgu[@"word"]) {
        self.word = [self.schemaArgu objectForKey:@"word"];
    }
    
    [self baseSetupTableView:UITableViewStylePlain InSets:UIEdgeInsetsMake(0, 0, 0, 0)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tableView registerNib:[UINib nibWithNibName:[TheaterListCell identify] bundle:nil] forCellReuseIdentifier:[TheaterListCell identify]];
    [self.tableView registerNib:[UINib nibWithNibName:[WeekEndCell identify] bundle:nil] forCellReuseIdentifier:[WeekEndCell identify]];
    [self.tableView registerNib:[UINib nibWithNibName:[SearchDeriveCell identify] bundle:nil] forCellReuseIdentifier:[SearchDeriveCell identify]];

    
    [self subviewStyle];
    [self fetchData];
    [self headerViewInit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - talbeView dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (self.contentType) {
        case ContentTypeTheater:
        {
            TheaterListCell* cell = [tableView dequeueReusableCellWithIdentifier:[TheaterListCell identify]];
            cell.ticketBtn.hidden = YES;
            cell.collectBtn.hidden = YES;
            [HYTool configTableViewCellDefault:cell];
            TheaterModel* model = [TheaterModel yy_modelWithDictionary:self.dataArray[indexPath.section]];
            [cell configTheaterListCell:model];
            cell.dateLblBot.constant = 10;
            return cell;
        }
        case ContentTypeDerive:
        {
            SearchDeriveCell* cell = [tableView dequeueReusableCellWithIdentifier:[SearchDeriveCell identify]];
            DeriveModel* model = [DeriveModel yy_modelWithDictionary:self.dataArray[indexPath.section]];
            [cell configSearchDeriveCell:model keyword:self.word];
            return cell;
        }
        default:
        {
            WeekEndCell* cell = [tableView dequeueReusableCellWithIdentifier:[WeekEndCell identify]];
            [HYTool configTableViewCellDefault:cell];
            cell.contentView.backgroundColor = [UIColor whiteColor];
            cell.allViewHeight.constant = 0;
            cell.allView.hidden = YES;
            ArticleModel* model = [ArticleModel yy_modelWithDictionary:self.dataArray[indexPath.section]];
            [cell configWeekEndCell:model isCollect:NO];
            return cell;
        }
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView* headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, zoom(13))];
    headView.backgroundColor = [UIColor hyViewBackgroundColor];
    return headView;
}
#pragma mark - tableView delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.contentType == ContentTypeTheater) {
        return 148;
    }else{
        return 120;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? 0 : zoom(13);
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    id model = self.dataArray[indexPath.section];
    
    switch (self.contentType) {
        case ContentTypeTheater:
            APPROUTE(([NSString stringWithFormat:@"%@?id=%ld",kTheaterDetailViewController,[model[@"play_id"] integerValue]]));
            break;
        case ContentTypeDerive:
            APPROUTE(([NSString stringWithFormat:@"%@?id=%ld&sourceUrl=%@",kDeriveDetailController,[model[@"goods_id"] integerValue],model[@"source_url"]]));
            break;
        default:
        {
            NSInteger articleId = [self.dataArray[indexPath.section][@"article_id"] integerValue];
            NSInteger type = [self.dataArray[indexPath.section][@"article_type"] integerValue]+1;
            BOOL isFav = [self.dataArray[indexPath.section][@"is_fav"] boolValue];
            APPROUTE(([NSString stringWithFormat:@"%@?isFav=%@&articleId=%ld&type=%ld&url=%@&title=%@&summary=%@&img=%@",kWeekEndDetailController,@(isFav),articleId,type,model[@"source_url"],model[@"title"],model[@"summary"],model[@"img"]]));
            break;
        }
    }
}

#pragma mark - textField delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    self.word = textField.text;
    [self fetchData];
    return YES;
}

#pragma mark - private methods
-(NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


- (void)fetchData {
    self.tableView.tableFooterView = nil;
    [self showLoadingAnimation];
    NSArray* types = @[@"movie",@"goods",@"article"];
    [APIHELPER homeSearch:0 limit:8 keyword:self.word type:types[self.contentType] complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
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
    }];
}

-(void)headerViewInit {
    @weakify(self);
    [self addHeaderRefresh:^{
        @strongify(self);
        [self showLoadingAnimation];
        NSArray* types = @[@"movie",@"goods",@"article"];
        [APIHELPER homeSearch:0 limit:8 keyword:self.word type:types[self.contentType] complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
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
        NSArray* types = @[@"movie",@"goods",@"article"];
        [APIHELPER homeSearch:self.dataArray.count limit:8 keyword:self.word type:types[self.contentType] complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
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
            [self endRefreshing];
        }];
    }];
}

-(void)subviewStyle {
    
    UIView* searhView = LOADNIB(@"HomeUseView", 3);
    searhView.frame = CGRectMake(0, 0, kScreen_Width-80, 34);
    [HYTool configViewLayer:searhView];
    
    NSArray* menu = @[@"演出",@"商品",@"文章"];
    UIButton* btn = [searhView viewWithTag:1000];
    [btn setTitle:menu[self.contentType] forState:UIControlStateNormal];
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, 30, 0, -30);
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, -12, 0, 12);
    [btn bk_whenTapped:^{
        [btn setImage:ImageNamed(@"三角形_黑色上") forState:UIControlStateNormal];
        [[FTPopOverMenuConfiguration defaultConfiguration] setMenuWidth:100];
        [[FTPopOverMenuConfiguration defaultConfiguration] setMenuTextMargin:12];
        [[FTPopOverMenuConfiguration defaultConfiguration] setMenuIconMargin:12];
        [FTPopOverMenu showForSender:btn withMenuArray:menu imageArray:@[@"搜索类别_演出",@"搜索类别_商品",@"搜索类别_文章"] doneBlock:^(NSInteger selectedIndex) {
            [btn setTitle:menu[selectedIndex] forState:UIControlStateNormal];
            [btn setImage:ImageNamed(@"三角形_黑色下") forState:UIControlStateNormal];
            self.contentType = selectedIndex;
        } dismissBlock:^{
            [btn setImage:ImageNamed(@"三角形_黑色下") forState:UIControlStateNormal];
        }];
    }];
    
    UITextField* textField = [searhView viewWithTag:1001];
    textField.returnKeyType = UIReturnKeySearch;
    self.textField = textField;
    self.textField.delegate = self;
    self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.textField.tintColor = RGB(0, 122, 255, 1);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searhView];
    
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    rightItem.tintColor = [UIColor whiteColor];
    [rightItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightItem;
}

-(void)cancel {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
