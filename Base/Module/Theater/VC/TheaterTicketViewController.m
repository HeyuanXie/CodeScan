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
#import "NSString+Extension.h"
#import "UITableViewCell+HYCell.h"

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
    return 96;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TheaterTicketCell* cell = [tableView dequeueReusableCellWithIdentifier:[TheaterTicketCell identify]];
    [HYTool configTableViewCellDefault:cell];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    TheaterSessionModel* model = self.dataArray[indexPath.row];
    [cell configTicketCell:model];
    [cell setTicketBtnClick:^{
        NSMutableDictionary* param = [[model yy_modelToJSONObject] mutableCopy];
        [param setValue:self.name forKey:@"play_name"];
        [param setValue:self.picUrl forKey:@"picurl"];
        [ROUTER routeByStoryboardID:[NSString stringWithFormat:@"%@",kTheaterSeatPreviewController] withParam:param];
    }];
    [cell addLine:NO leftOffSet:0 rightOffSet:0];
    return cell;
}

#pragma mark - private methods
- (void)subviewStyle {
    
    self.title = self.name;
    
    [self.imgV sd_setImageWithURL:[NSURL URLWithString:self.picUrl] placeholderImage:ImageNamed(@"yazi")];
    [self.backImgV sd_setImageWithURL:[NSURL URLWithString:self.picUrl] placeholderImage:ImageNamed(@"yazi")];
    self.titleLbl.text = self.name;
    self.styleLbl.text = self.subTitle;
    self.timeLbl.text = [NSString stringWithFormat:@"时长: %@分钟",self.time];
    self.dateLbl.text = [NSString stringWithFormat:@"上映: %@",self.date];
    
    self.statuLbl.backgroundColor = [self.statuLbl.backgroundColor colorWithAlphaComponent:0.5];
    self.statuLbl.text = self.statu == 1 ? @"售票中" : @"售罄";
    
    self.scoreLbl.text = [NSString stringWithFormat:@"观众评分: %.1f分",(float)self.score];
    self.scoreLbl.attributedText = [self.scoreLbl.text addAttribute:@[NSFontAttributeName] values:@[[UIFont systemFontOfSize:18]] subStrings:@[[NSString stringWithFormat:@"%ld",self.score]]];
    for (int i=0; i<self.score/2; i++) {
        UIImageView* imgV = (UIImageView*)[self.scoreView viewWithTag:100+i];
        imgV.image = ImageNamed(@"星星01");
    }
    for (int i=(int)self.score/2; i<5; i++) {
        UIImageView* imgV = (UIImageView*)[self.scoreView viewWithTag:100+i];
        imgV.image = ImageNamed(@"星星02");
    }
    
    [self baseSetupTableView:UITableViewStylePlain InSets:UIEdgeInsetsMake(178, 0, 10, 0)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:[TheaterTicketCell identify] bundle:nil] forCellReuseIdentifier:[TheaterTicketCell identify]];

}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)fetchData {

    self.tableView.tableFooterView = nil;
    [self showLoadingAnimation];
    [APIHELPER theaterSession:0 limit:4 playId:self.playId complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
        [self hideLoadingAnimation];
        if (isSuccess) {
            [self.dataArray removeAllObjects];
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
        [APIHELPER theaterSession:0 limit:4 playId:self.playId complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
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
        [APIHELPER theaterSession:0 limit:4 playId:self.playId complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
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
