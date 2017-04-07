//
//  ChangePasswordController.m
//  Base
//
//  Created by admin on 2017/3/17.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "ChangePasswordController.h"

@interface ChangePasswordController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *firstTf;
@property (weak, nonatomic) IBOutlet UITextField *secondTf;
@property (weak, nonatomic) IBOutlet UIView *eyeView;
@property (weak, nonatomic) IBOutlet UIImageView *eyeImgV;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet UIImageView *imgV;
@property (weak, nonatomic) IBOutlet UIButton *otherBtn;

@property (assign, nonatomic) BOOL canSee;

@end

@implementation ChangePasswordController

- (void)viewDidLoad {
    [super viewDidLoad];

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

    UIView* footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 200)];
    footerView.backgroundColor = [UIColor hyViewBackgroundColor];
    self.tableView.tableFooterView = footerView;
    [self.firstTf addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.secondTf addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
    
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
    //TODO:修改密码
}

@end
