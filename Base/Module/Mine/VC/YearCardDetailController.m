//
//  YearCardDetailController.m
//  Base
//
//  Created by admin on 2017/3/16.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "YearCardDetailController.h"

@interface YearCardDetailController ()

@end

@implementation YearCardDetailController

- (void)viewDidLoad {
    [super viewDidLoad];

    if (self.schemaArgu[@"Id"]) {
        NSString* cardId = [self.schemaArgu objectForKey:@"Id"];
        self.url = cardId;
        [self loadWebView];
    }
    
    [self subviewStyle];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - override methods
-(void)webViewStyle {
    [super webViewStyle];
    [self.webView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, zoom(60), 0)];
}

#pragma mark - IBActions
- (IBAction)selectSeat:(id)sender {
    APPROUTE(kTheaterListViewController);
}

#pragma mark - private methods
-(void)subviewStyle {
    UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithImage:[ImageNamed(@"年卡使用记录") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(cardRecord)];
    self.navigationItem.rightBarButtonItem = item;
}

-(void)cardRecord {
    APPROUTE(kYearCardRecordController);
}
@end
