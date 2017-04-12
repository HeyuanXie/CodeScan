//
//  DidBindPhoneController.m
//  Base
//
//  Created by admin on 2017/4/7.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "DidBindPhoneController.h"
#import "NSString+HYMobileInsertInterval.h"

@interface DidBindPhoneController ()

@property (weak, nonatomic) IBOutlet UILabel *phoneLbl;

@end

@implementation DidBindPhoneController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self subviewStyle];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)subviewStyle {
    self.phoneLbl.text = [NSString stringWithFormat:@"已绑定手机号:%@",[APIHELPER.userInfo.phone HTMobileInsertSecurity]];
}

- (IBAction)changeBindPhone:(id)sender {
    APPROUTE(([NSString stringWithFormat:@"%@?contentType=%d",kCheckCodeController,1]));
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
