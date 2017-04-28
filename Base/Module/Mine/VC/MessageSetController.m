//
//  MessageSetController.m
//  Base
//
//  Created by admin on 2017/4/27.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "MessageSetController.h"

@interface MessageSetController ()

@property (weak, nonatomic) IBOutlet UILabel *messageLbl;
@property (weak, nonatomic) IBOutlet UILabel *detailLbl;

@end

@implementation MessageSetController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self subviewStyle];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(canReceive) name:@"canReceiveNotification" object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//TODO:跳到系统设置
- (IBAction)messageSet:(id)sender {
    
    NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if([[UIApplication sharedApplication] canOpenURL:url]) {
        NSURL *url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:url];
    }
}




#pragma mark - private methods
- (void)subviewStyle {
    
    NSMutableAttributedString* mAttr = [[NSMutableAttributedString alloc] initWithString:self.detailLbl.text];
    NSMutableParagraphStyle* style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:4.0];
    [mAttr addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, self.detailLbl.text.length)];
    self.detailLbl.attributedText = mAttr;
}

- (void)loadData {
    
    UIUserNotificationSettings *settings = [[UIApplication sharedApplication]currentUserNotificationSettings];
    if (settings.types==UIUserNotificationTypeNone) {
        self.messageLbl.text = @"不接收";
    }else{
        self.messageLbl.text = @"接收";
    }
}

- (void)canReceive {
    
    UIUserNotificationSettings *settings = [[UIApplication sharedApplication]currentUserNotificationSettings];
    if (settings.types==UIUserNotificationTypeNone) {
        self.messageLbl.text = @"不接收";
    }else{
        self.messageLbl.text = @"接收";
    }
}

@end
