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
#import "HYAlertView.h"
#import "UIButton+HYButtons.h"
#import "NSString+Extension.h"
#import "DeriveModel.h"

@interface DeriveListController ()

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIButton *scoreBtn;
@property (weak, nonatomic) IBOutlet UIButton *recordBtn;

@property (strong, nonatomic) NSMutableArray* categoryArr;
@property (assign, nonatomic) NSInteger categoryId; //选中的分类Id
@property (strong, nonatomic) NSMutableArray* dataArray;

@property (strong, nonatomic) NSString* minePoint;

@end

@implementation DeriveListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.categoryId = 0;
    self.haveTableFooter = YES;
    [self baseSetupTableView:UITableViewStylePlain InSets:UIEdgeInsetsMake(92, 0, 0, 0)];
    [self.tableView registerNib:[UINib nibWithNibName:[DeriveListCell identify] bundle:nil] forCellReuseIdentifier:[DeriveListCell identify]];
    
    [self fetchData];
    [self headerViewInit];
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
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger line = self.dataArray.count / 2;
    NSInteger row = self.dataArray.count % 2;
    return line + row;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DeriveListCell* cell = [tableView dequeueReusableCellWithIdentifier:[DeriveListCell identify]];
    [HYTool configTableViewCellDefault:cell];
    [cell setItemClick:^(DeriveModel* model) {
        NSString* sourceUrl = model.sourceUrl;
        APPROUTE(([NSString stringWithFormat:@"%@?id=%ld&sourceUrl=%@",kDeriveDetailController,model.goodId.integerValue,sourceUrl]));
    }];
    [cell setExchangeClick:^(DeriveModel* model) {
        if (model.storeCount.integerValue == 0) {
            [self showMessage:@"商品数量不足"];
            return ;
        }
        HYAlertView* alert = [HYAlertView sharedInstance];
        [alert setSubBottonBackgroundColor:[UIColor hyRedColor]];
        [alert setSubBottonTitleColor:[UIColor whiteColor]];
        [alert setCancelButtonBorderColor:[UIColor hyBarTintColor]];
        [alert setCancelButtonTitleColor:[UIColor hyBarTintColor]];
        [alert setCancelButtonBackgroundColor:[UIColor whiteColor]];
        [alert setBtnCornerRadius:5];
        [alert showAlertViewWithMessage:[NSString stringWithFormat:@"是否用%ld积分兑换该商品?",model.shopPrice.integerValue] subBottonTitle:@"确定" cancelButtonTitle:@"取消" handler:^(AlertViewClickBottonType bottonType) {
            switch (bottonType) {
                case AlertViewClickBottonTypeSubBotton: {
                    //TODO:兑换
                    [APIHELPER deriveExchange:model.goodId.integerValue buyNum:1 complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
                        if (isSuccess) {
                            NSDictionary* param = responseObject[@"data"];
                            //剧场下单成功和衍生品兑换成功公用一个VC
                            [ROUTER routeByStoryboardID:[NSString stringWithFormat:@"%@?contentType=1&order_sn=%@&",kTheaterCommitOrderSuccessController,responseObject[@"data"][@"order_sn"]] withParam:param];
                        }else{
                            [self showMessage:error.userInfo[NSLocalizedDescriptionKey]];
                        }
                    }];
                    break;
                }
                default:{
                    break;
                }
            }
        }];

    }];
    
    DeriveModel* leftModel = self.dataArray[indexPath.section*2];
    DeriveModel* rightModel = (self.dataArray.count%2!=0 && self.dataArray.count/2==indexPath.section) ? nil : self.dataArray[indexPath.section*2+1];
    [cell configListCellWithLeft:leftModel right:rightModel isCollect:NO];
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
        _categoryArr = [NSMutableArray array];
    }
    return _categoryArr;
}
-(NSMutableArray *)dataArray {
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
    [APIHELPER deriveListStart:0 limit:8 categoryId:self.categoryId complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
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
            
            [self.categoryArr addObjectsFromArray:responseObject[@"data"][@"category_list"]];
            self.minePoint = [NSString stringWithFormat:@"%ld",[responseObject[@"data"][@"score"] integerValue]];
            if (![self.topView viewWithTag:1000]) {
                [self subviewStyle];
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
        [APIHELPER deriveListStart:0 limit:8 categoryId:self.categoryId complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
            [self hideLoadingAnimation];
            
            [self.dataArray removeAllObjects];
            [self.tableView reloadData];
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

-(void)appendFooterView {
    @weakify(self);
    [self addFooterRefresh:^{
        @strongify(self);
        [self showLoadingAnimation];
         [APIHELPER deriveListStart:self.dataArray.count limit:8 categoryId:self.categoryId complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
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

-(void)subviewStyle {
    UIScrollView* scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 42)];
    scroll.tag = 1000;
    scroll.showsHorizontalScrollIndicator = NO;
    scroll.contentSize = CGSizeMake(74*self.categoryArr.count, 0);
    [self.topView addSubview:scroll];
    
    NSMutableArray* titles = [NSMutableArray array];
    for (NSDictionary* dic in self.categoryArr) {
        [titles addObject:dic[@"name"]];
    }
    CustomJumpBtns* btns = [CustomJumpBtns customBtnsWithFrame:CGRectMake(0, 0, MAX(74*self.categoryArr.count, kScreen_Width) , 42) menuTitles:titles textColorForNormal:[UIColor hyBlackTextColor] textColorForSelect:[UIColor hyBlueTextColor] isLineAdaptText:YES];
    [btns setFinished:^(NSInteger index) {
        self.categoryId = [self.categoryArr[index][@"cat_id"] integerValue];
        [self fetchData];
    }];
    [scroll addSubview:btns];
    
    NSString* title = [NSString stringWithFormat:@"积分%@",self.minePoint];
    NSAttributedString* attrTitle = [title addAttribute:@[NSForegroundColorAttributeName] values:@[[UIColor hyBlueTextColor]] subStrings:@[self.minePoint]];
    [self.scoreBtn setAttributedTitle:attrTitle forState:UIControlStateNormal];
}

-(void)subviewBind {
    [self.scoreBtn addTarget:self action:@selector(mineScore:) forControlEvents:UIControlEventTouchUpInside];
    [self.recordBtn addTarget:self action:@selector(mineRecord:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)mineScore:(UIButton*)btn {
    APPROUTE(kPointManageController);
}
-(void)mineRecord:(UIButton*)btn {
    APPROUTE(([NSString stringWithFormat:@"%@?typeId=1",kOrderHomeController]));
}


@end
