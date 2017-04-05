//
//  TheaterTicketViewController.m
//  Base
//
//  Created by admin on 2017/3/6.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "TheaterTicketViewController.h"
#import "CustomJumpBtns.h"
#import "TheaterTicketCell.h"
#import "TheaterSessionModel.h"

@interface TheaterTicketViewController ()

@property (nonatomic,strong)NSString* picUrl;
@property (nonatomic,strong)NSString* name;
@property (nonatomic,assign)NSInteger score;
@property (nonatomic,strong)NSString* subTitle;
@property (nonatomic,strong)NSString* time;
@property (nonatomic,strong)NSString* date;
@property (nonatomic,assign)NSInteger statu;
@property (nonatomic,assign)NSInteger playId;

@property (weak, nonatomic) IBOutlet UIImageView *imgV;
@property (weak, nonatomic) IBOutlet UIImageView *backImgV;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UIView *scoreView;
@property (weak, nonatomic) IBOutlet UILabel *scoreLbl;
@property (weak, nonatomic) IBOutlet UILabel *styleLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UILabel *dateLbl;
@property (weak, nonatomic) IBOutlet UILabel *statuLbl;
@property (weak, nonatomic) IBOutlet UIView *btnsView;

@property (strong, nonatomic) UIScrollView *scroll;
@property (strong, nonatomic) NSString* selectDate;
@property (strong, nonatomic) NSMutableArray* dataArray;

@end

@implementation TheaterTicketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.schemaArgu[@"playId"]) {
        self.playId = [[self.schemaArgu objectForKey:@"playId"] integerValue];
    }
    if (self.schemaArgu[@"img"]) {
        self.picUrl = [self.schemaArgu objectForKey:@"img"];
    }
    if (self.schemaArgu[@"name"]) {
        self.name = [self.schemaArgu objectForKey:@"name"];
    }
    if (self.schemaArgu[@"score"]) {
        self.score = [[self.schemaArgu objectForKey:@"score"] integerValue];
    }
    if (self.schemaArgu[@"subTitle"]) {
        self.subTitle = [self.schemaArgu objectForKey:@"subTitle"];
    }
    if (self.schemaArgu[@"time"]) {
        self.time = [self.schemaArgu objectForKey:@"time"];
    }
    if (self.schemaArgu[@"date"]) {
        self.date = [self.schemaArgu objectForKey:@"date"];
    }
    if (self.schemaArgu[@"statu"]) {
        self.statu = [[self.schemaArgu objectForKey:@"statu"] integerValue];
    }
    
    self.playId = 1;
    self.selectDate = @"2017-06-01";
    self.navigationBarTransparent = YES;
    [self subviewStyle];
    [self fetchData];
    [self headerViewInit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableView delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
//    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 203;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TheaterTicketCell* cell = [tableView dequeueReusableCellWithIdentifier:[TheaterTicketCell identify]];
    [HYTool configTableViewCellDefault:cell];
    TheaterSessionModel* model = self.dataArray[indexPath.row];
    [cell configTicketCell:model];
    return cell;
}

#pragma mark - private methods
- (void)subviewStyle {
    
    [self.imgV sd_setImageWithURL:[NSURL URLWithString:self.picUrl] placeholderImage:ImageNamed(@"yazi")];
    [self.backImgV sd_setImageWithURL:[NSURL URLWithString:self.picUrl] placeholderImage:ImageNamed(@"yazi")];
    self.titleLbl.text = self.name;
    self.styleLbl.text = self.subTitle;
    self.timeLbl.text = [NSString stringWithFormat:@"时长: %@分钟",self.time];
    self.dateLbl.text = [NSString stringWithFormat:@"上映: %@",self.date];
    
    self.statuLbl.backgroundColor = [self.statuLbl.backgroundColor colorWithAlphaComponent:0.5];
    self.statuLbl.text = self.statu == 1 ? @"售票中" : @"售罄";
    
    _scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 45)];
    _scroll.showsVerticalScrollIndicator = NO;
    _scroll.showsHorizontalScrollIndicator = NO;
    [self.btnsView addSubview:_scroll];
    
    [self baseSetupTableView:UITableViewStylePlain InSets:UIEdgeInsetsMake(223, 0, 0, 0)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:[TheaterTicketCell identify] bundle:nil] forCellReuseIdentifier:[TheaterTicketCell identify]];

    self.selectDate = [HYTool dateStringWithFormatter:@"yyyy-MM-dd"];
    NSString* dateStr = [HYTool dateStringWithFormatter:@"MM月dd日"];
    NSString* weekStr = [HYTool weekString];
    NSMutableArray* titles = [NSMutableArray arrayWithObjects:[NSString stringWithFormat:@"%@%@",dateStr,weekStr], nil];
    for (int i=1; i<7; i++) {
        NSDate* date = [NSDate dateWithTimeIntervalSinceNow:i*24*60*60];
        NSString* weekStr = [HYTool weekStirngWithDate:date];
        NSString* dateStr = [HYTool dateStringWithDate:date andFormatter:@"MM月dd日"];
        [titles addObject:[NSString stringWithFormat:@"%@%@",dateStr,weekStr]];
    }
    CustomJumpBtns* btns = [CustomJumpBtns customBtnsWithFrame:CGRectMake(0, 0, MAX(115*7, kScreen_Width), 45) menuTitles:titles textColorForNormal:[UIColor hyBlackTextColor] textColorForSelect:[UIColor hyBlueTextColor] isLineAdaptText:NO];
    [btns setFinished:^(NSInteger index) {
        NSDate* date = [NSDate dateWithTimeIntervalSinceNow:index*24*60*60];
        self.selectDate = [HYTool dateStringWithDate:date andFormatter:@"yyyy-MM-dd"];
        [self fetchData];
    }];
    [_scroll addSubview:btns];
    _scroll.contentSize = CGSizeMake(titles.count*115, 0);
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)fetchData {
    [self.dataArray removeAllObjects];
    [self.tableView reloadData];
    self.tableView.tableFooterView = nil;
    [self showLoadingAnimation];
    [APIHELPER theaterSession:0 limit:4 playId:self.playId date:self.selectDate complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
        [self hideLoadingAnimation];
        if (isSuccess) {
            [self.dataArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:[TheaterSessionModel class] array:responseObject[@"data"][@"list"]]];
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
        [APIHELPER theaterSession:0 limit:4 playId:self.playId date:self.selectDate complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
            [self hideLoadingAnimation];
            
            if (isSuccess) {
                [self.dataArray removeAllObjects];
                [self.dataArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:[TheaterSessionModel class] array:responseObject[@"data"][@"list"]] ];
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
        [APIHELPER theaterSession:0 limit:4 playId:self.playId date:self.selectDate complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
            [self hideLoadingAnimation];
            
            if (isSuccess) {
                [self.dataArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:[TheaterSessionModel class] array:responseObject[@"data"][@"list"]] ];
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
