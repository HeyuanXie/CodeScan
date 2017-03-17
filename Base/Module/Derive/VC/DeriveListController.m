//
//  DeriveListController.m
//  Base
//
//  Created by admin on 2017/3/10.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "DeriveListController.h"
#import "DeriveListCell.h"
#import "CustomJumpBtns.h"

@interface DeriveListController ()

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIButton *scoreBtn;
@property (weak, nonatomic) IBOutlet UIButton *recordBtn;

@property (strong, nonatomic) NSMutableArray* categoryArr;
@property (strong, nonatomic) NSMutableArray* dataArray;

@property (strong, nonatomic) NSString* minePoint;

@end

@implementation DeriveListController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self baseSetupTableView:UITableViewStylePlain InSets:UIEdgeInsetsMake(92, 0, 0, 0)];
    [self.tableView registerNib:[UINib nibWithNibName:[DeriveListCell identify] bundle:nil] forCellReuseIdentifier:[DeriveListCell identify]];
    
    [self subviewStyle];
    [self subviewBind];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView)
    {
        CGFloat sectionHeaderHeight = zoom(12);
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
}

#pragma mark - tableView dataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
    NSInteger line = self.dataArray.count / 2;
    NSInteger row = self.dataArray.count % 2;
    return line + row;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DeriveListCell* cell = [tableView dequeueReusableCellWithIdentifier:[DeriveListCell identify]];
    [HYTool configTableViewCellDefault:cell];
    [cell setItemClick:^(id model) {
        //TODO:
        BOOL isEnough = self.minePoint.integerValue > 1200;
        APPROUTE(([NSString stringWithFormat:@"%@?id=%d&isEnough=%d",kDeriveDetailController,0,isEnough]));
    }];
    [cell setExchangeClick:^(id model) {
        //TODO:兑换
    }];
    [cell configListCellWithLeft:nil right:nil];
    return cell;
}
                 
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, zoom(12))];
    view.backgroundColor = [UIColor hyViewBackgroundColor];
    return view;
}

#pragma mark - tableView delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 230;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return zoom(12);
}


#pragma mark - private methods
-(NSMutableArray *)categoryArr {
    if (!_categoryArr) {
        _categoryArr = [@[@"全部",@"玩具",@"服饰"] mutableCopy];
    }
    return _categoryArr;
}

-(void)subviewStyle {
    UIScrollView* scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 42)];
    scroll.showsHorizontalScrollIndicator = NO;
    scroll.contentSize = CGSizeMake(74*self.categoryArr.count, 0);
    [self.topView addSubview:scroll];
    CustomJumpBtns* btns = [CustomJumpBtns customBtnsWithFrame:CGRectMake(0, 0, MAX(74*self.categoryArr.count, kScreen_Width) , 42) menuTitles:self.categoryArr textColorForNormal:[UIColor hyBlackTextColor] textColorForSelect:[UIColor hyBlueTextColor] isLineAdaptText:YES];
    [btns setFinished:^(NSInteger index) {
        NSString* category = self.categoryArr[index];
        //TODO:刷新table
    }];
    [scroll addSubview:btns];
    
    self.minePoint = @"1000";
    [self.scoreBtn setTitle:[NSString stringWithFormat:@"积分%@",self.minePoint] forState:UIControlStateNormal];
}

-(void)subviewBind {
    [self.scoreBtn addTarget:self action:@selector(mineScore:) forControlEvents:UIControlEventTouchUpInside];
    [self.recordBtn addTarget:self action:@selector(mineRecord:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)mineScore:(UIButton*)btn {
    DLog(@"我的积分");
}
-(void)mineRecord:(UIButton*)btn {
    DLog(@"兑换记录");
}


@end
