//
//  OrderHomeController.m
//  Base
//
//  Created by admin on 2017/3/10.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "OrderHomeController.h"
#import "OrderFilterTableController.h"
#import "OrderListCell.h"
#import "CustomJumpBtns.h"

@interface OrderHomeController ()<UITextFieldDelegate>

@property(strong,nonatomic)UIView* topView;

@property(assign,nonatomic)NSInteger typeId;    //0为演出、1为商品、2为年卡
@property(assign,nonatomic)NSInteger statuId;   //待付款、待评价等等
@property(strong,nonatomic)NSMutableArray* dataArray;

@property(strong,nonatomic)NSArray *types;
@property(strong,nonatomic)NSArray *status;
@property(strong,nonatomic)UIButton* filterBtn;

@property(strong,nonatomic)OrderFilterTableController* filterVC;
@property(strong,nonatomic)UIView* backGrayView;

@end

@implementation OrderHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.backItemHidden = YES;
    self.types = @[@"演出",@"商品",@"年卡"];
    self.status = @[@"已付款",@"待付款",@"待评价",@"退款"];
    
    [self baseSetupTableView:UITableViewStylePlain InSets:UIEdgeInsetsMake(90, 0, 0, 0)];
    [self.tableView registerNib:[UINib nibWithNibName:[OrderListCell identify] bundle:nil] forCellReuseIdentifier:[OrderListCell identify]];

    [self subviewStyle];
    [self fetchData];
}

-(void)viewWillDisappear:(BOOL)animated {
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
    
    if (self.typeId == 0) {
        [cell configTheaterCell:nil];
    }else if (self.typeId == 1) {
        [cell configDeriveCell:nil];
    }else{
        [cell configYearCardCell:nil];
    }
    return cell;
}

#pragma mark - tableView delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 174;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //TODO:进入订单详情，传递type参数,传递订单Id参数
    NSArray* types = @[@"theater",@"derive",@"yearCard",@"lecture"];
    APPROUTE(([NSString stringWithFormat:@"%@?type=%@&orderId=%d",kOrderDetailController,types[self.typeId],1]));
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

-(void)fetchData {
    self.dataArray = [@[@"",@""] mutableCopy];
    //TODO:根据self.typeId、self.statuId请求数据
    [self.tableView reloadData];
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
        self.statuId = index;
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
    if (row == 0) {

    }else{
//        self.filterParam[@"type_id"] = [NSString stringWithFormat:@"%@", @(row)];
    }
    [self fetchData];
}
@end
