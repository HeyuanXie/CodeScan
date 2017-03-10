//
//  LectureApplyController.m
//  Base
//
//  Created by admin on 2017/3/9.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "LectureApplyController.h"
#import "BaseNavigationController.h"
#import "HYAddressController.h"
#import "ApplyTitleCell.h"
#import "ApplyCommonCell.h"

@interface LectureApplyController ()<UITextFieldDelegate>

@property(assign,nonatomic)BOOL isAgree;
@property(strong,nonatomic)NSString* type;//线上or线下

@property(strong,nonatomic)NSArray* infos;
@property(strong,nonatomic)NSMutableArray* payways;
@property(assign,nonatomic)NSInteger selectIndex;   //记录选中的支付方式

@property(assign,nonatomic)NSInteger count; //总票数
@property(assign,nonatomic)NSInteger total; //总金额
@property(strong,nonatomic)UILabel* priceLbl;

@property(strong,nonatomic)BaseNavigationController* addressNVC;
@property(nonatomic,strong)NSString *address;


@end

@implementation LectureApplyController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isAgree = NO;
    if (self.schemaArgu[@"type"]) {
        self.type = [self.schemaArgu objectForKey:@"type"];
    }
    if ([self.type isEqualToString:@"onLine"]) {
        self.infos = @[@[@{@"title":@"主题",@"necessary":@(0)},
                         @{@"title":@"姓名:",@"necessary":@(1)},
                         @{@"title":@"所在城市:",@"necessary":@(0)},
                         @{@"title":@"手机号:",@"necessary":@(1)},
                         @{@"title":@"报名费",@"necessary":@(0)}
                         ],
                    @[@{@"title":@"支付方式"},
                      @{@"title":@"微信支付"},
                      @{@"title":@"支付宝支付"}]
                    ];
    }else{
        self.infos = @[@[@{@"title":@"主题",@"necessary":@(0)},
                         @{@"title":@"姓名:",@"necessary":@(1)},
                         @{@"title":@"所在城市:",@"necessary":@(0)},
                         @{@"title":@"手机号:",@"necessary":@(1)},
                         @{@"title":@"报名费",@"necessary":@(0)},
                         @{@"title":@"报名人数:",@"necessary":@(1)}
                         ],
                       @[@{@"title":@"支付方式"},
                         @{@"title":@"微信支付"},
                         @{@"title":@"支付宝支付"}]
                    ];
    }
    self.payways = [@[@"支付方式",@"微信支付",@"支付宝支付"] mutableCopy];
    self.count = 1;
    self.total = 15;
    
    [self baseSetupTableView:UITableViewStylePlain InSets:UIEdgeInsetsMake(0, 0, zoom(120), 0)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    [self.tableView registerNib:[UINib nibWithNibName:[ApplyTitleCell identify] bundle:nil] forCellReuseIdentifier:[ApplyTitleCell identify]];
    [self.tableView registerNib:[UINib nibWithNibName:[ApplyCommonCell identify] bundle:nil] forCellReuseIdentifier:[ApplyCommonCell identify]];

    [self subviewInit];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - textfield delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField {
    switch (textField.tag) {
        case 1003:
            textField.keyboardType = UIKeyboardTypeNumberPad;
            break;
        default:
            textField.keyboardType = UIKeyboardTypeDefault;
            break;
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField {
    switch (textField.tag) {
        case 1001:
            break;
        default:
            break;
    }
}

#pragma mark - tableView dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.infos.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        NSArray* sectionArr = self.infos[section];
        return sectionArr.count;
    }else{
        return self.payways.count;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        NSString* title = self.infos[0][indexPath.row][@"title"];
        if ([title isEqualToString:@"报名费"]) {
            static NSString* cellId = @"moneyCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
                [HYTool configTableViewCellDefault:cell];
                cell.contentView.backgroundColor = [UIColor whiteColor];
                [cell.contentView addSubview:self.priceLbl];
                [self.priceLbl autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 30)];
            }
            return cell;
        }else if (indexPath.row == 0) {
            ApplyTitleCell* cell = [tableView dequeueReusableCellWithIdentifier:[ApplyTitleCell identify]];
            //TODO:
            [cell configTitleCell:nil];
            return cell;
        }else{
            ApplyCommonCell* cell = [tableView dequeueReusableCellWithIdentifier:[ApplyCommonCell identify]];
            [HYTool configTableViewCellDefault:cell];
            cell.contentView.backgroundColor = [UIColor whiteColor];
            
            cell.countView.hidden = [title isEqualToString:@"报名人数:"] ? NO : YES;
            cell.inputTf.userInteractionEnabled = ([title isEqualToString:@"报名人数:"] || [title isEqualToString:@"所在城市:"]) ? NO : YES;
            cell.accessoryType = [title isEqualToString:@"所在城市:"] ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
            cell.addressLbl.hidden = [title isEqualToString:@"所在城市:"] ? NO : YES;
            cell.addressLbl.text = self.address;
            
            cell.inputTf.tag = 1000 + indexPath.row;
            cell.inputTf.delegate = self;
            
            @weakify(self);
            [cell setSubClick:^{
                @strongify(self);
                if (self.count == 1) {
                    return ;
                }
                self.count--;
                self.total = self.count*15;
                self.priceLbl.text = [NSString stringWithFormat:@"报名费: %ld",self.total];
                [self.tableView reloadData];
            }];
            [cell setAddClick:^{
                @strongify(self);
                self.count++;
                self.total = self.count*15;
                self.priceLbl.text = [NSString stringWithFormat:@"报名费: %ld",self.total];
                [self.tableView reloadData];
            }];
            [cell configCommonCell:self.infos[0][indexPath.row] count:self.count];
            return cell;
        }
    }else{
        static NSString* cellId = @"payCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            [HYTool configTableViewCellDefault:cell];
            cell.contentView.backgroundColor = [UIColor whiteColor];

            UIButton* selectBtn = [HYTool getButtonWithFrame:CGRectZero title:nil titleSize:0 titleColor:nil backgroundColor:[UIColor clearColor] blockForClick:nil];
            [selectBtn setImage:ImageNamed(@"on") forState:UIControlStateSelected];
            [selectBtn setImage:ImageNamed(@"off") forState:UIControlStateNormal];
            selectBtn.tag = 1000 + indexPath.row;
            [cell.contentView addSubview:selectBtn];
            [selectBtn autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0) excludingEdge:ALEdgeLeft];
            [selectBtn autoSetDimension:ALDimensionWidth toSize:48];
        }
        UIButton* selectBtn = [cell.contentView viewWithTag:1000+indexPath.row];
        selectBtn.selected = indexPath.row == self.selectIndex;
        selectBtn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            self.selectIndex = indexPath.row;
            [self.tableView reloadSections:[[NSIndexSet alloc] initWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
            return [RACSignal empty];
        }];
        if (indexPath.row == 0) {
            selectBtn.hidden = YES;
            cell.textLabel.text = @"支付方式";
            cell.textLabel.textColor = [UIColor blackColor];
        }else{
            selectBtn.hidden = NO;
            cell.imageView.image = ImageNamed(@"cart");
            cell.textLabel.text = self.payways[indexPath.row];
            cell.textLabel.textColor = [UIColor hyBlackTextColor];
        }
        return cell;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView* headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 15)];
    headView.backgroundColor = [UIColor hyViewBackgroundColor];
    return section == 0 ? nil : headView;
}

#pragma mark - tableView delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return indexPath.row == 0 ? 100 : 50;
    }else{
        return indexPath.row == 0 ? 50 : 68;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? 0 : 15;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 2) {
        [self filterAddress:nil];
    }
}

#pragma mark - IBActions
- (IBAction)agree:(id)sender {
    self.isAgree = !self.isAgree;
}

- (IBAction)submitApply:(id)sender {
    if (!self.isAgree) {
        [self showMessage:@"清先同意报名协议"];
        return;
    }
    //TODO:报名
//    [APIHELPER ]
}

#pragma mark - private methods
- (UILabel *)priceLbl {
    if (!_priceLbl) {
        _priceLbl = [[UILabel alloc] init];
        _priceLbl.text = [NSString stringWithFormat:@"报名费: ¥%ld",self.total];
        _priceLbl.textAlignment = NSTextAlignmentRight;
        _priceLbl.textColor = RGB(65, 65, 65, 1.0);
        _priceLbl.font = [UIFont systemFontOfSize:14];
    }
    return _priceLbl;
}

-(BaseNavigationController *)addressNVC {
    if (!_addressNVC) {
        HYAddressController *addressC = (HYAddressController *)VIEWCONTROLLER(kAddressController);
        addressC.backItemHidden = YES;
        @weakify(self);
        [addressC setSelectAddress:^(NSString *areaName, NSString *areaID) {
            @strongify(self);
            self.address = areaName;
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            [self hiddenFilterAddress];
        }];
        [addressC setFilterDismiss:^{
            @strongify(self);
            [self hiddenFilterAddress];
        }];
        addressC.isFilter = YES;
        _addressNVC = [[BaseNavigationController alloc] initWithRootViewController:addressC];
        [_addressNVC.navigationBar setBackgroundColor:[UIColor whiteColor]];
        [_addressNVC.navigationBar setTintColor:[UIColor whiteColor]];
        [_addressNVC.navigationBar setBarTintColor:[UIColor whiteColor]];
        [_addressNVC.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor hyBlackTextColor],
                                                            NSFontAttributeName: [UIFont systemFontOfSize:17.0f]}];
    }
    return _addressNVC;
}

- (void)filterAddress:(UIButton *)button{
    if (self.addressNVC.view.superview) {
        //如果self.addressNVC已经加载，点击后移除self.addressNVC
        [self hiddenFilterAddress];
        return;
    }
    button.enabled = NO;    //避免多次addressNVC未加载成功时点击多次，而加载多个addressNVC
    [self addChildViewController:self.addressNVC];
    [self.view addSubview:self.addressNVC.view];
    [self.view bringSubviewToFront:self.addressNVC.view];
    [self.addressNVC popToRootViewControllerAnimated:NO];
    self.addressNVC.view.frame = CGRectMake(0, 0, kScreen_Width, kScreen_Height-64);
    [UIView animateWithDuration:0.3 animations:^{
        self.addressNVC.view.alpha = 1.0;
    } completion:^(BOOL finished) {
        button.enabled = YES;   //addressNVC加载成功后恢复button.enabled
    }];
    
}

- (void)hiddenFilterAddress{
    [self.addressNVC removeFromParentViewController];
    [self.addressNVC.view removeFromSuperview];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.addressNVC.view.alpha = CGFLOAT_MIN;
    }];
}


-(void)fetchData {
    
}

-(void)subviewInit {
    //navigationItem
    
    //
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
