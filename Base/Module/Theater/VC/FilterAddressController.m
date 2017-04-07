//
//  FilterAddressController.m
//  Base
//
//  Created by admin on 2017/3/29.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "FilterAddressController.h"

@interface FilterAddressController ()

@property(nonatomic,strong)NSArray* currentArray;
@property(nonatomic,strong)NSMutableArray* hotsArray;

@end

@implementation FilterAddressController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self fetchData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        static NSString* cellId = @"headCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            [HYTool configTableViewCellDefault:cell];
            cell.contentView.backgroundColor = [UIColor whiteColor];
            
            UILabel* lbl = [HYTool getLabelWithFrame:CGRectMake(12, 0, kScreen_Width-24, 40) text:@"" fontSize:16 textColor:RGB(166, 166, 166, 1) textAlignment:NSTextAlignmentLeft];
            lbl.tag = 1000;
            [cell.contentView addSubview:lbl];
        }
        UILabel* lbl = [cell.contentView viewWithTag:1000];
        lbl.text = indexPath.section == 0 ? @"当前定位" : @"热门城市";
        return cell;
    }else{
        static NSString* cellId = @"btnsCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            [HYTool configTableViewCellDefault:cell];
            cell.contentView.backgroundColor = [UIColor whiteColor];
        }
        for (UIView* subview in cell.contentView.subviews) {
            [subview removeFromSuperview];
        }
        NSArray* dataArray = indexPath.section == 0 ? self.currentArray : self.hotsArray;
        CGFloat width = 75,height = 30;
        CGFloat x = 12,y = 2;
        for (int i=0; i<dataArray.count; i++) {
            UIButton* btn = [HYTool getButtonWithFrame:CGRectMake(x, y, width, height) title:@"未定位" titleSize:15 titleColor:[UIColor hyBlackTextColor] backgroundColor:nil blockForClick:nil];
            [HYTool configViewLayerFrame:btn WithColor:[UIColor hySeparatorColor]];
            [cell.contentView addSubview:btn];
            [btn setTitle:dataArray[i] forState:(UIControlStateNormal)];
            if ([self.selectedCity isEqualToString:dataArray[i]]) {
                [btn setTitleColor:[UIColor hyBlueTextColor] forState:UIControlStateNormal];
                btn.layer.borderColor = [UIColor hyBlueTextColor].CGColor;
            }
            [btn bk_whenTapped:^{
                if (self.selectCity) {
                    self.selectCity(dataArray[i]);
                }
            }];

            x = x+width+12;
            if (x-12 >= kScreen_Width) {
                x = 12;
                y = y+height+12;
                btn.frame = CGRectMake(x, y, width, height);
            }
        }
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 40;
    }else{
        NSArray* dataArray = indexPath.section == 0 ? self.currentArray : self.hotsArray;
        return (dataArray.count/4+(dataArray.count%4==0 ? 0 : 1))*(12+30);
    }
}

#pragma mark - private methods
-(NSArray *)currentArray {
    if (!_currentArray) {
        if (kGetObjectFromUserDefaults(@"currentLocation")) {
            _currentArray = [NSArray arrayWithObject:[[NSUserDefaults standardUserDefaults] stringForKey:@"currentLocation"]];
        }else{
            _currentArray = [NSArray arrayWithObject:@"未定位"];
        }
    }
   
    return _currentArray;
}

-(NSMutableArray *)hotsArray {
    if (!_hotsArray) {
        _hotsArray = [NSMutableArray array];
    }
    return _hotsArray;
}

-(void)fetchData {
    
    [APIHELPER theaterHotCitysComplete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
        if (isSuccess) {
            [self.hotsArray addObjectsFromArray:responseObject[@"data"]];
            [self.tableView reloadData];
        }else{
            [MBProgressHUD hy_showMessage:error.userInfo[NSLocalizedDescriptionKey] inView:self.view];
        }
    }];
    [self.tableView reloadData];
}


@end
