//
//  OrderCodeController.m
//  Base
//
//  Created by admin on 2017/3/10.
//  Copyright © 2017年 XHY. All rights reserved.
//

//订单查看二维码VC
#import "OrderCodeController.h"
#import "CodeHeadCell.h"

#import "UIViewController+Extension.h"

@interface OrderCodeController ()

@end

@implementation OrderCodeController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self baseSetupTableView:UITableViewStylePlain InSets:UIEdgeInsetsMake(0, 0, 0, 0)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tableView registerNib:[UINib nibWithNibName:[CodeHeadCell identify] bundle:nil] forCellReuseIdentifier:[CodeHeadCell identify]];

    
    [self subviewStyle];
    [self fetchData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - talbeView dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? 2 : 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            if (indexPath.row == 0) {
                CodeHeadCell* cell = [tableView dequeueReusableCellWithIdentifier:[CodeHeadCell identify]];
                [HYTool configTableViewCellDefault:cell];
                cell.contentView.backgroundColor = [UIColor whiteColor];
                
                [cell configCodeHeadCell:nil];
                return cell;
            }else{
                static NSString* cellId = @"addressCell";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
                if (cell == nil) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
                    [HYTool configTableViewCellDefault:cell];
                    cell.contentView.backgroundColor = [UIColor whiteColor];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    
                    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 11.5, 25, 25)];
                    imageView.image = ImageNamed(@"定位");
                    UILabel* lbl = [HYTool getLabelWithFrame:CGRectMake(40, 0, kScreen_Width, 48) text:@"" fontSize:15 textColor:[UIColor hyBlueTextColor] textAlignment:NSTextAlignmentLeft];
                    lbl.tag = 1000;
                    [cell.contentView addSubview:imageView];
                    [cell.contentView addSubview:lbl];
                }
                UILabel* lbl = [cell.contentView viewWithTag:1000];
                lbl.text = @"东莞玉兰大剧场";
                return cell;
            }
            
        default:
        {
            static NSString* cellId = @"codeCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
                [HYTool configTableViewCellDefault:cell];
                cell.contentView.backgroundColor = [UIColor whiteColor];
                
                UILabel* passwordLbl = [HYTool getLabelWithFrame:CGRectMake(12, 12, kScreen_Width-24, 21) text:@"" fontSize:15 textColor:[UIColor hyBlackTextColor] textAlignment:NSTextAlignmentLeft];
                passwordLbl.tag = 1000;
                [cell.contentView addSubview:passwordLbl];
                
                UILabel* seatLbl = [HYTool getLabelWithFrame:CGRectMake(12, 12+21+2, kScreen_Width-24, 21) text:@"" fontSize:15 textColor:RGB(127, 127, 127, 1.0) textAlignment:NSTextAlignmentLeft];
                seatLbl.tag = 1001;
                [cell.contentView addSubview:seatLbl];
                
                UIImageView* codeImgV = [[UIImageView alloc] initWithFrame:CGRectMake((kScreen_Width-zoom(167))/2, 12+21+2+21+12, zoom(167), zoom(167))];
                codeImgV.tag = 1002;
                [cell.contentView addSubview:codeImgV];
            }
            
            UILabel* passwordLbl = [cell.contentView viewWithTag:1000];
            UILabel* seatLbl = [cell.contentView viewWithTag:1001];
            UIImageView* codeImgV = [cell.contentView viewWithTag:1002];

            passwordLbl.text = @"消费密码: 1265466666";
            seatLbl.text = @"一楼20排10号座";
            [codeImgV sd_setImageWithURL:[NSURL URLWithString:@"https://ss0.bdstatic.com/94oJfD_bAAcT8t7mm9GUKT-xh_/timg?image&quality=100&size=b4000_4000&sec=1490001149&di=1336a528fd7efc7386a985dd3c81bf23&src=http://pic1.fangketong.net/app_attach/201507/30/20150730_110_37862_0.jpg"] placeholderImage:nil];
            return cell;
        }
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView* headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, zoom(15))];
    headView.backgroundColor = [UIColor hyViewBackgroundColor];
    return headView;
}

#pragma mark - tableView delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            return indexPath.row == 0 ? 157 : 48;
        default:
            return 258;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? 0 : zoom(15);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section==0 && indexPath.row==1) {
        [self geocoderClick:@"东莞玉兰大剧院"];
        return;
    }
}
#pragma mark - private methods
-(void)subviewStyle {
    UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithImage:[ImageNamed(@"share") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(share)];
    self.navigationItem.rightBarButtonItem = item;
}
-(void)share {
    
}

-(void)fetchData {
    
    [self.tableView reloadData];
}

@end
