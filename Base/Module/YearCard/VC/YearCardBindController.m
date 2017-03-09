//
//  YearCardBindController.m
//  Base
//
//  Created by admin on 2017/3/9.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "YearCardBindController.h"

@interface YearCardBindController ()
@property (weak, nonatomic) IBOutlet UILabel *accountLbl;
@property (weak, nonatomic) IBOutlet UITextField *cardTf;
@property (weak, nonatomic) IBOutlet UITextField *passwordTf;

@end

@implementation YearCardBindController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self subviewStyle];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions
- (IBAction)bind:(id)sender {
    if ([self.cardTf.text isEmpty]) {
        [self showMessage:@"请输入年卡卡号"];
        return;
    }
    if ([self.passwordTf.text isEmpty]) {
        [self showMessage:@"请输入年卡密码"];
        return;
    }
    //TODO:绑定
}

#pragma mark - private methods
-(void)subviewStyle {
    self.cardTf.keyboardType = UIKeyboardTypeNumberPad;
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
