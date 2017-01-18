//
//  LoginViewController.m
//  Base
//
//  Created by admin on 2017/1/17.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "LoginViewController.h"
#import "APIHelper+User.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *accountTf;

@property (weak, nonatomic) IBOutlet UITextField *passwordTf;

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self subviewBind];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)subviewBind {
    self.loginBtn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [APIHELPER login:self.accountTf.text password:self.passwordTf.text complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
            if (isSuccess) {
                NSLog(@"登陆成功,user=%@",responseObject);
            }else{
                NSLog(@"登陆失败");
                NSLog(@"%@",responseObject);
            }
        }];
        return [RACSignal empty];
    }];
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
