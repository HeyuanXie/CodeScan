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
    
    [self bindCard:self.cardTf.text password:self.passwordTf.text];
}

#pragma mark - private methods
-(void)subviewStyle {
    self.cardTf.keyboardType = UIKeyboardTypeNumberPad;
    self.passwordTf.keyboardType = UIKeyboardTypeNumberPad;
    
    self.accountLbl.text = [NSString stringWithFormat:@"绑定账号: %@",APIHELPER.userInfo.phone];
}

-(void)bindCard:(NSString*)num password:(NSString*)password {

    [APIHELPER bindYearCard:num password:password complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
        if (isSuccess) {
//            NSString* deadline = responseObject[@"data"][@""];
            APPROUTE(([NSString stringWithFormat:@"%@?deadline=%@",kYearCardBindSuccessController,@"2017-12-30"]));
        }else{
            [self showMessage:error.userInfo[NSLocalizedDescriptionKey]];
        }
    }];
}


@end
