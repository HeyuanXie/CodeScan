//
//  SkillCompetitorController.m
//  Base
//
//  Created by admin on 2017/3/13.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "SkillCompetitorController.h"

@interface SkillCompetitorController ()

@property(nonatomic,strong)NSString* Id;

@end

@implementation SkillCompetitorController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.schemaArgu[@"Id"]) {
        self.Id = [self.schemaArgu objectForKey:@"Id"];
    }

    [self webViewStyle];
    //TODO:LoadWebView
//    self.url = @"";
//    [self loadWebView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - IBActions
- (IBAction)allCompetitor:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)support:(id)sender {
    
}


#pragma mark - override methods
-(void)webViewStyle {
    [super webViewStyle];
    
    [self.webView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, zoom(60), 0)];
}

@end
