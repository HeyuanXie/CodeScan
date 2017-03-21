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


@interface WeekEndListController ()

@property(nonatomic,strong)NSMutableArray* dataArray;
@property(nonatomic,assign)NSInteger type;  //类型，0为小飞象资讯、1为周末去哪儿

@property(nonatomic,strong)NSMutableArray* countries;   //镇区
@property(nonatomic,strong)NSString* selectCountry;
@property(nonatomic,strong)UIButton* rightBtn;  //navigationItem 的btn

@end

@implementation WeekEndListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.schemaArgu[@"type"]) {
        self.type = [[self.schemaArgu objectForKey:@"type"] integerValue];
    }
    
    self.countries = [@[@"东城区",@"南城区",@"莞城区",@"石碣镇",@"大岭山镇",@"厚街镇",@"虎门镇",@"常平镇",@"松山湖"] mutableCopy];
    
    [self baseSetupTableView:UITableViewStylePlain InSets:UIEdgeInsetsMake(0, 0, 0, 0)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tableView registerNib:[UINib nibWithNibName:[WeekEndCell identify] bundle:nil] forCellReuseIdentifier:[WeekEndCell identify]];

    [self subviewStyle];
    [self fetchData];
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
    [cell configWeekEndCell:nil];
    return cell;
}

#pragma mark - tableView delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    APPROUTE(([NSString stringWithFormat:@"%@?Id=%@",kWeekEndDetailController,@"1"]));
}
#pragma mark - private methods
-(NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

-(void)fetchData {
    if (self.type == 0) {
        
    }else{
        
    }
    self.dataArray = [@[@"",@""] mutableCopy];
    [self.tableView reloadData];
}

-(void)subviewStyle  {
    
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
        //TODO:fetchData
    }];
    [topView setSecondClick:^{
        @strongify(topView);
        [UIView animateWithDuration:0.2 animations:^{
            topView.Line.frame = CGRectMake(22+width, 98, width-20, 2);
        }];
        //TODO:fetchData
    }];
    [topView setThirdClick:^{
        @strongify(topView);
        [UIView animateWithDuration:0.2 animations:^{
            topView.Line.frame = CGRectMake(22+2*width, 98, width-20, 2);
        }];
        //TODO:fetchData
    }];
    
    if (self.type == 1) {
        self.tableView.tableHeaderView = topView;
    }
    
}

-(void)showAddressView {
    
    WeekEndUseView* view = LOADNIB(@"WeekEndUseView", 0);
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
        CGFloat width = [country sizeWithFont:[UIFont systemFontOfSize:16] maxWidth:CGFLOAT_MAX].width;
        UIButton* btn = [HYTool getButtonWithFrame:CGRectMake(x, y, width+20, 38) title:country titleSize:16 titleColor:[UIColor hyBlackTextColor] backgroundColor:nil blockForClick:^(id sender) {
            self.selectCountry = country;
            [self.rightBtn setTitle:country forState:UIControlStateNormal];
            [self hideAddressView];
        }];
        if ([country isEqualToString:self.selectCountry]) {
            [btn setTitleColor:[UIColor hyBlueTextColor] forState:UIControlStateNormal];
        }
        [view.botView addSubview:btn];
        x = x + width+20;
        if (x >= kScreen_Width) {
            btn.frame = CGRectMake(0, 10+38, width+20, 38);
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
