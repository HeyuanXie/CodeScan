//
//  CollectViewController.m
//  Base
//
//  Created by admin on 2017/3/6.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "CollectViewController.h"
#import "UIViewController+Extension.h"
#import "NSString+Extension.h"
#import "CustomJumpBtns.h"
#import "TheaterListCell.h"

@interface CollectViewController ()

@property(strong,nonatomic)NSArray* cellTypes;
@property(strong,nonatomic)NSString* cellType;
@property(strong,nonatomic)NSMutableArray* dataArray;
@property (weak, nonatomic) IBOutlet UIScrollView *topScroll;

@end

@implementation CollectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.backItemHidden = YES;
    self.cellTypes = @[@"theaterCell",@"lectureCell",@"skillCell",@"deriveCell"];
    [self baseSetupTableView:UITableViewStylePlain InSets:UIEdgeInsetsMake(zoom(42), 0, 0, 0)];
    [self.tableView registerNib:[UINib nibWithNibName:[TheaterListCell identify] bundle:nil] forCellReuseIdentifier:[TheaterListCell identify]];
    
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
    if ([self.cellType isEqualToString:@"theaterCell"]) {
        TheaterListCell* cell = [tableView dequeueReusableCellWithIdentifier:[TheaterListCell identify]];
        cell.contentView.backgroundColor = [UIColor hyViewBackgroundColor];
        [cell setTicketBtnClick:^(id model) {
            //TODO:取消收藏
            
        }];
        cell.ticketBtnWidth.constant = 80;
        [cell.ticketBtn setTitle:@"取消收藏" forState:UIControlStateNormal];
        return cell;
    }
    if ([self.cellType isEqualToString:@"lectureCell"]) {
        
    }
    if ([self.cellType isEqualToString:@"skillCell"]) {
        
    }
    if ([self.cellType isEqualToString:@"deriveCell"]) {
        
    }
    return [UITableViewCell new];
}

#pragma mark - tableView delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.cellType isEqualToString:@"theaterCell"]) {
        return 173;
    }
    if ([self.cellType isEqualToString:@"lectureCell"]) {
        
    }
    if ([self.cellType isEqualToString:@"skillCell"]) {
        
    }
    if ([self.cellType isEqualToString:@"deriveCell"]) {
        
    }
    return 0;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark - private methods
-(NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

-(void)subviewStyle {
    NSArray* titles = @[@"亲子剧场",@"专家讲座",@"才艺竞赛",@"衍生品"];
    CGFloat width = [titles[0] sizeWithFont:[UIFont systemFontOfSize:15] maxWidth:CGFLOAT_MAX].width;
    CustomJumpBtns* btns = [CustomJumpBtns customBtnsWithFrame:CGRectMake(0, 0, MAX(width*titles.count, kScreen_Width) , 42) menuTitles:titles textColorForNormal:[UIColor hyBlackTextColor] textColorForSelect:[UIColor hyBlueTextColor] isLineAdaptText:YES];
    [btns setFinished:^(NSInteger index) {
        //TODO:
        self.cellType = self.cellTypes[index];
        [self fetchData];
    }];
    [self.topScroll addSubview:btns];
    self.topScroll.contentSize = CGSizeMake(titles.count*width, 0);
}

-(void)fetchData {
    self.dataArray = [@[@"",@""] mutableCopy];
    //TODO:根据self.cellType请求数据
    
    [self.tableView reloadData];
}

@end
