//
//  TheaterCommitOrderController.m
//  Base
//
//  Created by admin on 2017/3/24.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "TheaterCommitOrderController.h"

@interface TheaterCommitOrderController ()

@property (weak, nonatomic) IBOutlet UILabel *totalLbl;

@property (strong, nonatomic) NSArray* selectArray; //选择的座位的array
@property (strong, nonatomic) NSMutableArray* payMethods;  //支付方法array

@end

@implementation TheaterCommitOrderController


- (IBAction)commit:(id)sender {
    //TODO:提交选座订单
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.schemaArgu[@"selectArray"]) {
        self.selectArray = [NSArray arrayWithArray:[self.schemaArgu objectForKey:@"selectArray"]];
    }
    [self baseSetupTableView:UITableViewStylePlain InSets:UIEdgeInsetsMake(0, 0, zoom(60), 0)];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - talbeView dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 2+self.selectArray.count;
        case 1:
            return 1;
        case 2:
            return 1;
        default:
            return self.payMethods.count;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - tableView delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 185;
    }
    if (indexPath.section == 3 && indexPath.row != 0) {
        return 68;
    }
    return 50;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - private methods
-(NSMutableArray *)payMethods {
    if (!_payMethods) {
        //        _payMethods = [NSMutableArray array];
        _payMethods = [@[@{@"title":@"支付方式",@"image":@""},@{@"title":@"微信支付",@"image":@"支付方式_微信"},@{@"title":@"支付宝支付",@"image":@"支付方式_支付宝"}] mutableCopy];
    }
    return _payMethods;
}



@end
