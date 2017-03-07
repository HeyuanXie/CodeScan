//
//  MineHomeViewController.m
//  Base
//
//  Created by admin on 17/1/16.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "MineHomeViewController.h"
#import "UITableViewCell+HYCell.h"
#import "HeadCell.h"
#import "MineHeadCell.h"
#import "FunctionCell.h"

@interface MineHomeViewController ()

@property(nonatomic,strong)NSArray* infos;


@end

@implementation MineHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self subviewStyle];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSArray *)infos {
    if (!_infos) {
        _infos = @[@[@{}],
                   @[@{@"image":@"",@"title":@"剧院年卡",@"router":@"",@"needLogin":@(YES)},
                     @{@"image":@"",@"title":@"报名信息",@"router":@"",@"needLogin":@(YES)},
                     @{@"image":@"",@"title":@"积分管理",@"router":@"",@"needLogin":@(YES)},
                     @{@"image":@"",@"title":@"优惠券",@"router":@"",@"needLogin":@(YES)},
                    ],
                   @[@{@"image":@"",@"title":@"设置",@"router":@"",@"needLogin":@(YES)}]];
    }
    return _infos;
}

- (void)subviewStyle {
    self.backItemHidden = YES;
    self.navigationBarTransparent = YES;
//    [self baseSetupTableView:UITableViewStylePlain InSets:UIEdgeInsetsMake(-64, 0, 0, 0)];
    [self baseSetupTableView:UITableViewStylePlain InSets:UIEdgeInsetsMake(-64, 0, 64, 0)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor hyViewBackgroundColor];
    self.tableView.scrollEnabled = NO;
    [self.tableView registerNib:[UINib nibWithNibName:[HeadCell identify] bundle:nil] forCellReuseIdentifier:[HeadCell identify]];
    [self.tableView registerNib:[UINib nibWithNibName:[MineHeadCell identify] bundle:nil] forCellReuseIdentifier:[MineHeadCell identify]];
    [self.tableView registerNib:[UINib nibWithNibName:[FunctionCell identify] bundle:nil] forCellReuseIdentifier:[FunctionCell identify]];
    [self.tableView reloadData];
    
    @weakify(self);
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:kAfterUserLoginSuccessNotification object:nil] subscribeNext:^(NSNotification *notification){
        @strongify(self);
        [self.tableView reloadData];
    }];
}



#pragma mark - tableView delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.infos.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray* arr = self.infos[section];
    return arr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 2 ? zoom(12) : 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, zoom(12))];
    view.backgroundColor = [UIColor clearColor];
    return section == 0 ? nil : view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 0 ? zoom(185) : zoom(48);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MineHeadCell* cell = [tableView dequeueReusableCellWithIdentifier:[MineHeadCell identify]];
        [HYTool configTableViewCellDefault:cell];
        //configcell
        [cell configHeadCell:nil];
        return cell;
    }
    FunctionCell *cell = [tableView dequeueReusableCellWithIdentifier:[FunctionCell identify]];
    [HYTool configTableViewCellDefault:cell];
    cell.contentView.backgroundColor = [UIColor hyViewBackgroundColor];

    if (indexPath.row != ((NSArray*)self.infos[indexPath.section]).count-1) {
        [cell addLine:NO leftOffSet:42+zoom(30) rightOffSet:-12];
    }
    //设置圆角
    if (indexPath.row == 0) {
        UIView* view = cell.backView;
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(5, 5)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = view.bounds;
        maskLayer.path = maskPath.CGPath;
        view.layer.mask = maskLayer;
    }
    if (indexPath.row == ((NSArray*)self.infos[indexPath.section]).count-1) {
        UIView* view = cell.backView;
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(5, 5)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = view.bounds;
        maskLayer.path = maskPath.CGPath;
        view.layer.mask = maskLayer;
    }
    if (indexPath.section == 2) {
        [HYTool configViewLayer:cell.backView size:5];
    }
    if (!(indexPath.row == 0 && indexPath.section == 1)) {
        cell.blueView.hidden = YES;
    }
    NSDictionary *model = self.infos[indexPath.section][indexPath.row];
    [cell configFunctionCell:model];
    return cell;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    APPROUTE(kLoginViewController);
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
