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

@interface TheaterTicketViewController ()

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
@property (strong, nonatomic) NSMutableArray* dataArray;

@end

@implementation TheaterTicketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationBarTransparent = YES;
    [self subviewStyle];
    [self fetchData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableView delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return self.dataArray.count;
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 203;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TheaterTicketCell* cell = [tableView dequeueReusableCellWithIdentifier:[TheaterTicketCell identify]];
    [HYTool configTableViewCellDefault:cell];
    [cell configTicketCell:nil];
    return cell;
}

#pragma mark - private methods
- (void)subviewStyle {
    
    self.statuLbl.backgroundColor = [self.statuLbl.backgroundColor colorWithAlphaComponent:0.5];
    
    _scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 45)];
    _scroll.showsVerticalScrollIndicator = NO;
    _scroll.showsHorizontalScrollIndicator = NO;
    [self.btnsView addSubview:_scroll];
    
    [self baseSetupTableView:UITableViewStylePlain InSets:UIEdgeInsetsMake(223, 0, 0, 0)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:[TheaterTicketCell identify] bundle:nil] forCellReuseIdentifier:[TheaterTicketCell identify]];

    [self appendHeadView];
}

-(void)fetchData {
    //TODO:请求数据成功后再在self.scroll上添加customJumpBtns
    NSArray* titles = @[@"3月23日周五",@"3月24日周一",@"3月25日周二",@"3月25日周三",@"3月26日周四"];
    CustomJumpBtns* btns = [CustomJumpBtns customBtnsWithFrame:CGRectMake(0, 0, MAX(115*titles.count, kScreen_Width), 45) menuTitles:titles textColorForNormal:[UIColor hyBlackTextColor] textColorForSelect:[UIColor hyBlueTextColor] isLineAdaptText:NO];
    [btns setFinished:^(NSInteger index) {
        //TODO:
        NSLog(@"%@",titles[index]);
    }];
    [_scroll addSubview:btns];
    _scroll.contentSize = CGSizeMake(titles.count*115, 0);
}

-(void)appendHeadView {
    @weakify(self);
    [self addHeaderRefresh:^{
        @strongify(self);
        
    }];
}

-(void)appendFootView {
    @weakify(self);
    [self addFooterRefresh:^{
        @strongify(self);
        
    }];
}



@end
