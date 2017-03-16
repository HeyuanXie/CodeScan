#import "SettingViewController.h"
#import <UIControl+BlocksKit.h>
#import <UIActionSheet+BlocksKit.h>
#import <UIAlertView+BlocksKit.h>
#import "WebViewController.h"
#import "APIHelper+User.h"
#import "APIHelper+Common.h"

@interface SettingViewController ()

@property(nonatomic, strong) NSArray *settings;
@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self baseSetupTableView:UITableViewStylePlain InSets:UIEdgeInsetsZero];
    [self dataInit];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tableView reloadData];
    if (!APIHELPER.config) {
        [APIHELPER fetchConfiguration:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
            if (isSuccess) {
                APIHELPER.config = responseObject[@"data"];
            }
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dataInit{
    self.settings = @[
                        @[@{@"title":@"个人资料",@"router":kUserInfoViewController,@"needLogin":@(NO)},@{@"title":@"账户安全",@"router":@"",@"needLogin":@(YES)}],
                        @[@{@"title":@"清理缓存"}, @{@"title":@"意见反馈",@"router":kFeedbackController},@{@"title":@"关于我们"}],
                        @[@{@"title":@"退出登陆"}]
                    ];
}

#pragma mark tableview datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.settings.count;
}// Default is 1 if not implemented

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.settings[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identify = [NSString stringWithFormat:@"%@,%@",@"identify",@((indexPath.section+1)*(indexPath.row+1))];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identify];
    }
    cell.textLabel.text = self.settings[indexPath.section][indexPath.row][@"title"];
    cell.textLabel.font = cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.textColor = cell.detailTextLabel.textColor = [UIColor hyBlackTextColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 1 && indexPath.row == 0) {
        long long cacheSize = [Global cacheSize];
        if (cacheSize > 0) {
            long long compareSizeM = 1024*1024; //比较数：MB
            long long compareSizeK = 1024; //比较熟：KB
            if (cacheSize < compareSizeK) {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%lldB", cacheSize];
            }else if (cacheSize<compareSizeM){
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2fKB", cacheSize/1024.0];
            }else{
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2fMB", cacheSize/(1024.0*1024)];
            }
        }else{
            cell.detailTextLabel.text = @"0KB";
        }
    }
    if (indexPath.section == 2) {
        cell.textLabel.text = @"";
        cell.detailTextLabel.text = @"";
        for (UIView* subView in cell.contentView.subviews) {
            [subView removeFromSuperview];
        }
        UIButton* quitBtn = [HYTool getButtonWithFrame:CGRectZero title:@"登陆" titleSize:16 titleColor:[UIColor hyBlackTextColor] backgroundColor:nil blockForClick:nil];
        if ([Global userAuth]) {
            [quitBtn setTitle:@"退出登陆" forState:UIControlStateNormal];
            [quitBtn addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
        }else{
            [quitBtn bk_whenTapped:^{
                APPROUTE(kLoginViewController);
            }];
        }
        
        [cell.contentView addSubview:quitBtn];
        [quitBtn autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    }
    return cell;
}

#pragma mark tableview delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return section == self.settings.count-1 ? 0 : 8.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1 && indexPath.row == 0) {
        if ([Global cacheSize] > 0) {
            [UIAlertView bk_showAlertViewWithTitle:@"确定消除缓存？" message:nil cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    [Global clearCacheWithCompletionHandler:nil];
                }
                [self.tableView reloadData];
            }];
        }
        return;
    }
    if (indexPath.section == 1 && indexPath.row == 2) {
        WebViewController *webvc = [[WebViewController alloc] init];
        webvc.url = APIHELPER.config[@"aboutus_url"];
        [self.navigationController pushViewController:webvc animated:YES];
        return;
    }
    
    NSDictionary* info = self.settings[indexPath.section][indexPath.row];
    if ([info[@"needLogin"] boolValue] && ![Global userAuth]) {
        APPROUTE(kLoginViewController);
        return;
    }
    APPROUTE(info[@"router"]);

}


#pragma mark - private methods
-(void)logout {
    [APIHELPER logout];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
