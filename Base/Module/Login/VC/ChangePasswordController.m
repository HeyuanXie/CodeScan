//
//  ChangePasswordController.m
//  Base
//
//  Created by admin on 2017/3/17.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "ChangePasswordController.h"

typedef enum : NSUInteger {
    TypeReset,  //修改密码
    TypeForget, //找回密码
} ContentType;

@interface ChangePasswordController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *firstTf;
@property (weak, nonatomic) IBOutlet UITextField *secondTf;
@property (weak, nonatomic) IBOutlet UIView *eyeView;
@property (weak, nonatomic) IBOutlet UIImageView *eyeImgV;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet UIImageView *imgV;
@property (weak, nonatomic) IBOutlet UIButton *otherBtn;

@property (assign, nonatomic) BOOL canSee;
@property (assign, nonatomic) ContentType contentType;
@property (strong, nonatomic) NSString *phone;  //typeForget用

@end

@implementation ChangePasswordController

- (void)viewDidLoad {
    [super viewDidLoad];

    if (self.schemaArgu[@"contentType"]) {
        self.contentType = [[self.schemaArgu objectForKey:@"contentType"] integerValue];
    }
    if (self.schemaArgu[@"phone"]) {
        self.phone = [self.schemaArgu objectForKey:@"phone"];
    }
    [self subviewStyle];
    [self subviewBind];
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


#pragma mark - subviewStyle
-(void)subviewStyle {

    self.firstTf.secureTextEntry = YES;
    UIView* footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 200)];
    footerView.backgroundColor = [UIColor hyViewBackgroundColor];
    self.tableView.tableFooterView = footerView;
    [self.firstTf addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.secondTf addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
    
    [self.imgV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://api.xfx.zhimadi.cn/captcha/%@.html",[Global IDFV]]] placeholderImage:nil];
    if (self.contentType==TypeForget) {
        self.title = @"找回密码";
    }
}

-(void)textFieldDidChanged:(UITextField*)textField {
    if (![self.firstTf.text isEmpty] && ![self.secondTf.text isEmpty]) {
        self.submitBtn.backgroundColor = [UIColor hyBarTintColor];
    }else{
        self.submitBtn.backgroundColor = RGB(211, 211, 211, 1.0);
    }
}

#pragma mark - subviewBind
-(void)subviewBind {
    
    [self.eyeView bk_whenTapped:^{
        
        self.canSee = !self.canSee;
        NSString* imageName = self.canSee ? @"密码不可见_灰" : @"密码可见_灰";
        self.eyeImgV.image = ImageNamed(imageName);
        self.firstTf.secureTextEntry = !self.canSee;
    }];
    
    [self.otherBtn addTarget:self action:@selector(otherImage) forControlEvents:UIControlEventTouchUpInside];
    
    [self.submitBtn addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
}

-(void)otherImage {
    //TODO:另一张
//    [[SDImageCache sharedImageCache] removeImageForKey:@"http://api.xfx.zhimadi.cn/captcha.html"];
//    [self.imgV sd_setImageWithURL:[NSURL URLWithString:@"http://api.xfx.zhimadi.cn/captcha.html"] placeholderImage:nil];
    [self.imgV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://api.xfx.zhimadi.cn/captcha/%@.html",[Global IDFV]]] placeholderImage:nil options:SDWebImageRefreshCached];

}

-(void)submit {
    if ([self.firstTf.text isEmpty]) {
        [self showMessage:@"请输入新密码"];
        return;
    }
    if ([self.secondTf.text isEmpty]) {
        [self showMessage:@"请输入图中文字"];
        return;
    }
    
    if (self.contentType == TypeForget) {
        //忘记密码重置
        [APIHELPER resetPW:self.phone code:self.secondTf.text password:self.firstTf.text complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
            if (isSuccess) {
                [self showMessage:@"重置密码成功"];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }else{
                [self showMessage:error.userInfo[NSLocalizedDescriptionKey]];
            }
        }];
    }else{
        //修改密码
        [APIHELPER changePassword:self.firstTf.text captcha:self.secondTf.text complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
            if (isSuccess) {
                [self showMessage:@"修改密码成功"];
                [APIHELPER logout];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }else{
                [self showMessage:error.userInfo[NSLocalizedDescriptionKey]];
            }
        }];
    }

}

@end
