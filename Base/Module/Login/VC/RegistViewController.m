//
//  RegistViewController.m
//  Base
//
//  Created by admin on 2017/3/2.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "RegistViewController.h"
#import "APIHelper+User.h"

@interface RegistViewController ()

@property (weak, nonatomic) IBOutlet UIView *phoneView;
@property (weak, nonatomic) IBOutlet UIView *codeView;
@property (weak, nonatomic) IBOutlet UIView *passwordView;
@property (weak, nonatomic) IBOutlet UITextField *phoneTf;
@property (weak, nonatomic) IBOutlet UITextField *codeTf;
@property (weak, nonatomic) IBOutlet UITextField *passwordTf;


@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *eyeBtn;

@property (weak, nonatomic) IBOutlet UIView *otherLoginView;
@property (weak, nonatomic) IBOutlet UIView *weixinView;
@property (weak, nonatomic) IBOutlet UIImageView *qqView;
@property (weak, nonatomic) IBOutlet UIImageView *weiboView;

@end

@implementation RegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)awakeFromNib {
    [super awakeFromNib];
    for (UIView* view in @[self.phoneView,self.codeView,self.passwordView]) {
        UIView* line = [HYTool getLineWithFrame:CGRectZero lineColor:[UIColor whiteColor]];
        [view addSubview:line];
        [line autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 35, 0, 0) excludingEdge:ALEdgeTop];
        [line autoSetDimension:ALDimensionHeight toSize:0.5];
    }
    
    self.otherLoginView.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)regiest:(id)sender {
    if ([self.phoneTf.text isEqualToString:@""]) {
        [MBProgressHUD hy_showMessage:@"请输入手机号" inView:self.view];
        return;
    }
    if ([self.codeTf.text isEqualToString:@""]) {
        [MBProgressHUD hy_showMessage:@"请输入验证码" inView:self.view];
        return;
    }
    if ([self.passwordTf.text isEqualToString:@""]) {
        [MBProgressHUD hy_showMessage:@"请输入密码" inView:self.view];
        return;
    }
    [MBProgressHUD hy_showLoadingHUDAddedTo:self.view animated:YES];
    //TODO:注册
//    [APIHELPER ]
}
- (IBAction)login:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
