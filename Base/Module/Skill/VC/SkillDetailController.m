//
//  SkillDetailController.m
//  Base
//
//  Created by admin on 2017/3/13.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "SkillDetailController.h"
#import "UIViewController+Extension.h"

@interface SkillDetailController ()

@property (weak, nonatomic) IBOutlet UILabel *priceLbl;
@property(strong,nonatomic)NSString* skillId;

@end

@implementation SkillDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.schemaArgu[@"skillId"]) {
        self.skillId = [self.schemaArgu objectForKey:@"skillId"];
    }
    //TODO:loadWEbViwe
//    self.url = @"";
//    [self loadWebView];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions
- (IBAction)skillSituation:(id)sender {
    APPROUTE(kSkillSituationController);
}
- (IBAction)skillApply:(id)sender {
    
}


#pragma mark - private methods
-(void)configNavigationItem {
    //TODO:rightItems
     [self addDoubleNavigationItemsWithImages:@[@"search02",@"search02"] firstBlock:^{
        //TODO:收藏
        DLog(@"收藏");
    } secondBlock:^{
        //TODO:分享
        DLog(@"分享");
    }];
}

-(void)webViewStyle {
    [super webViewStyle];
    
    [self configNavigationItem];
    [self.webView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, zoom(60), 0)];
}

@end
