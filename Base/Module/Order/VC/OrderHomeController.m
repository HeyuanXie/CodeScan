//
//  OrderHomeController.m
//  Base
//
//  Created by admin on 2017/3/10.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "OrderHomeController.h"
#import "CommentViewController.h"
#import "OrderFilterTableController.h"
#import "OrderListCell.h"
#import "CustomJumpBtns.h"

@interface OrderHomeController ()<UITextFieldDelegate>

@property(strong,nonatomic)UIView* topView;

@property(assign,nonatomic)NSInteger typeId;    //订单类型Id, 0为演出、1为商品、2为年卡
@property(assign,nonatomic)NSInteger statuId;   //订单状态Id, 待付款、待评价等等
@property(strong,nonatomic)NSMutableArray* dataArray;

@property(strong,nonatomic)NSArray *types;  //订单类型数组
@property(strong,nonatomic)NSArray *status; //订单状态数组
@property(strong,nonatomic)UIButton* filterBtn;

@property(strong,nonatomic)OrderFilterTableController* filterVC;
@property(strong,nonatomic)UIView* backGrayView;

@end

@implementation OrderHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.backItemHidden = YES;
    self.haveTableFooter = YES;
    self.types = @[@"演出",@"商品",@"年卡"];
    self.status = @[@"已付款",@"待付款",@"待评价",@"退款"];
    if (self.schemaArgu[@"typeId"]) {
        self.typeId = [[self.schemaArgu objectForKey:@"typeId"] integerValue];
    }
    self.statuId = 1;
    
    [self baseSetupTableView:UITableViewStylePlain InSets:UIEdgeInsetsMake(90, 0, 0, 0)];
    [self.tableView registerNib:[UINib nibWithNibName:[OrderListCell identify] bundle:nil] forCellReuseIdentifier:[OrderListCell identify]];

    [self subviewStyle];
    [self headerViewInit];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    [self fetchData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    
    [self hiddenFilterClassify];
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
    OrderListCell* cell = [tableView dequeueReusableCellWithIdentifier:[OrderListCell identify]];
    [HYTool configTableViewCellDefault:cell];
    
    NSDictionary* model = self.dataArray[indexPath.row];
    CommentType type;
    if (self.typeId == 0) {
        [cell configTheaterCell:model];
        type = CommentTypeTheater;
    }else if (self.typeId == 1) {
        [cell configDeriveCell:model];
        type = CommentTypeDerive;
    }else{
        [cell configYearCardCell:model];
    }
    [cell setCommentBlock:^(id model) {
        CommentViewController* vc = (CommentViewController*)VIEWCONTROLLER(kCommentViewController);
        vc.data = model;
        vc.type = type;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    return cell;
}

#pragma mark - tableView delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 174;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary* model = self.dataArray[indexPath.row];
    NSString* orderId = model[@"order_sn"];
    //TODO:进入订单详情，传递type参数,传递订单Id参数
    APPROUTE(([NSString stringWithFormat:@"%@?contentType=%ld&orderId=%@",kOrderDetailController,self.typeId,orderId]));
}

#pragma mark - textField delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    //TODO:根据关键字fetchData
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

-(OrderFilterTableController *)filterVC {
    if (!_filterVC) {
        _filterVC = [[OrderFilterTableController alloc] init];
    }
    return _filterVC;
}

- (UIView *)backGrayView {
    if (_backGrayView == nil) {
        _backGrayView = [[UIView alloc] initWithFrame:self.view.bounds];
        _backGrayView.backgroundColor = [UIColor hyBlackTextColor];
        _backGrayView.alpha = 0.4;
        [_backGrayView bk_whenTapped:^{
            [self hiddenFilterClassify];
        }];
    }
    return _backGrayView;
}

- (void)fetchData {
    
    self.tableView.tableFooterView = nil;
    [self.dataArray removeAllObjects];
    [self.tableView reloadData];
    [self showLoadingAnimation];
    switch (self.typeId) {
        case 0:
        {
            //演出
            [APIHELPER orderListTheater:0 limit:4 complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
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
            break;
        }
        case 1:
        {
            //商品
            [APIHELPER orderListDerive:0 limit:4 statu:self.statuId complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
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
            break;
        }
        case 2:
        {
            //年卡
            [APIHELPER orderListCard:0 limit:4 statu:self.statuId complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
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
            break;
        }
        default:
            break;
    }
}

-(void)headerViewInit {
    @weakify(self);
    [self addHeaderRefresh:^{
        @strongify(self);
        [self showLoadingAnimation];
        switch (self.typeId) {
            case 0:
            {
                //演出
                [APIHELPER orderListTheater:0 limit:4 complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
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
                break;
            }
            case 1:
            {
                //商品
                [APIHELPER orderListDerive:0 limit:4 statu:self.statuId complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
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
                break;
            }
            case 2:
            {
                //年卡
                [APIHELPER orderListCard:0 limit:4 statu:self.statuId complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
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
                break;
            }
            default:
                break;
        }
    }];
}

-(void)appendFooterView {
    @weakify(self);
    [self addFooterRefresh:^{
        @strongify(self);
        [self showLoadingAnimation];
        switch (self.typeId) {
            case 0:
            {
                //演出
                [APIHELPER orderListTheater:self.dataArray.count limit:4 complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
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
                break;
            }
            case 1:
            {
                //商品
                [APIHELPER orderListDerive:self.dataArray.count limit:4 statu:self.statuId complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
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
                break;
            }
            case 2:
            {
                //年卡
                [APIHELPER orderListCard:self.dataArray.count limit:4 statu:self.statuId complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
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
                break;
            }
            default:
                break;
        }
    }];
}

-(void)subviewStyle {
    
    [self configNavigation];
    
    if (!self.topView) {
        self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 90)];
    }
    [self.view addSubview:_topView];
    for (UIView* subview in self.topView.subviews) {
        [subview removeFromSuperview];
    }
    _topView.backgroundColor = [UIColor whiteColor];
    
    CustomJumpBtns* btns = [CustomJumpBtns customBtnsWithFrame:CGRectMake(0, 0, kScreen_Width, 42) menuTitles:_status textColorForNormal:[UIColor hyBlackTextColor] textColorForSelect:[UIColor hyBarTintColor] isLineAdaptText:YES];
    [btns setFinished:^(NSInteger index) {
        self.statuId = index+1;
        [self fetchData];
    }];
    [_topView addSubview:btns];
 
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 42, kScreen_Width, 48)];
    view.backgroundColor = [UIColor hyViewBackgroundColor];
    [_topView addSubview:view];
    UITextField* textField = [HYTool getTextFieldWithFrame:CGRectMake(12, 12, kScreen_Width-24, 36) placeHolder:@"输入订单号/名称" fontSize:16 textColor:[UIColor hyBlackTextColor]];
    textField.backgroundColor = [UIColor whiteColor];
    textField.returnKeyType = UIReturnKeySearch;
    textField.delegate = self;
    [HYTool configViewLayer:textField];
    UIView* leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 36, 36)];
    UIImageView* imgV = [[UIImageView alloc] initWithFrame:CGRectMake(8, 8, 20, 20)];
    imgV.image = ImageNamed(@"home_search");
    [leftView addSubview:imgV];
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.leftView = leftView;
    [view addSubview:textField];
}

-(void)configNavigation {
    self.filterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.filterBtn.frame = CGRectMake(0, 0, 80, 44);
    [self.filterBtn setTitle:_types[self.typeId] forState:UIControlStateNormal];
    [self.filterBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.filterBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [self.filterBtn setImage:ImageNamed(@"三角形_白色下") forState:UIControlStateNormal];
    self.filterBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 40, 0, -40);
    self.filterBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 10);

    [self.filterBtn addTarget:self action:@selector(filterClassify) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = self.filterBtn;
}

- (void)filterClassify{
    [self.view endEditing:YES];
    if (self.filterVC.view.superview) {//分类
        [self hiddenFilterClassify];
        return;
    }
    [self.view addSubview:self.backGrayView];
    [self.filterBtn setImage:ImageNamed(@"三角形_白色上") forState:UIControlStateNormal];
    self.filterBtn.enabled = NO;
    [self.view addSubview:self.filterVC.view];
    [self addChildViewController:self.filterVC];
    [self.view bringSubviewToFront:self.filterVC.view];
    self.filterVC.view.frame = CGRectMake(0, -(kScreen_Height-64), kScreen_Width, kScreen_Height-64);
    self.filterVC.view.hidden = YES;
    self.filterVC.currentIndex = self.typeId;
    [UIView animateWithDuration:0.3 animations:^{
        self.filterVC.view.hidden = NO;
        self.filterVC.view.frame = CGRectMake(0, 0, kScreen_Width, kScreen_Height-64);
        self.filterVC.tableView.frame = CGRectMake(0, 0, kScreen_Width, 182*3/4);
        
    } completion:^(BOOL finished) {
        self.filterBtn.enabled = YES;
    }];
    
    @weakify(self)
    [self.filterVC setSelectIndex:^(NSInteger row) {
        @strongify(self);
        self.typeId = row;
        [self selectClass:row];
        [self hiddenFilterClassify];
        
        if (row == 0) {
            self.status = @[@"已付款",@"待付款",@"待评价",@"退款"];
        }else if (row == 1) {
            self.status = @[@"待领取",@"待评价",@"已完成"];
        }else{
            self.status = @[@"已付款",@"待付款",@"已使用",@"退款"];
        }
        [self subviewStyle];
    }];
    
}
- (void)hiddenFilterClassify{
    [self.filterVC removeFromParentViewController];
    [self.filterVC.view removeFromSuperview];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.filterVC.view.frame = CGRectMake(0, -(kScreen_Height-64), kScreen_Width, kScreen_Height-64);
        self.filterVC.view.hidden = YES;
    }];
    [self.backGrayView removeFromSuperview];
    [self.filterBtn setImage:ImageNamed(@"三角形_白色下") forState:UIControlStateNormal];
    self.filterBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 40, 0, -40);
    self.filterBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 10);
}
- (void)selectClass:(NSInteger)row{
    [self.filterBtn setTitle:_types[row] forState:UIControlStateNormal];
    //选择订单类型，设置默认订单状态
    self.statuId = 1;
    [self fetchData];
}
@end
