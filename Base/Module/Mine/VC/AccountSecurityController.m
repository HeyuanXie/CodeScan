//
//  AccountSecurityController.m
//  Base
//
//  Created by admin on 2017/3/17.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "AccountSecurityController.h"

@interface AccountSecurityController ()

@end

@implementation AccountSecurityController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self baseSetupTableView:UITableViewStylePlain InSets:UIEdgeInsetsMake(0, 0, 0, 0)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* cellId = @"commonCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        [HYTool configTableViewCellDefault:cell];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.contentView.backgroundColor = [UIColor whiteColor];
    }
    
    cell.textLabel.text = indexPath.row == 0 ? @"修改登陆密码" : @"绑定手机号";
    cell.textLabel.textColor = [UIColor hyBlackTextColor];
    
    cell.detailTextLabel.text = indexPath.row == 0 ? @"" : APIHELPER.userInfo.phone;// @"153****9415";
    cell.detailTextLabel.textColor = [UIColor hyGrayTextColor];

    return cell;
}

#pragma mark - table delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return zoom(50);
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* router = indexPath.row == 0 ? kChangePasswordController : kBindPhoneController;
    APPROUTE(router);
}

#pragma mark - subviewStyle 
-(void)subviewStyle {
    UIView* footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 200)];
    footerView.backgroundColor = [UIColor hyViewBackgroundColor];
    self.tableView.tableFooterView = footerView;
}

@end
