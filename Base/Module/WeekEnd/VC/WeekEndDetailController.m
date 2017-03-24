//
//  WeekEndDetailController.m
//  Base
//
//  Created by admin on 2017/3/21.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "WeekEndDetailController.h"
#import "UIViewController+Extension.h"

@interface WeekEndDetailController ()

@property (weak, nonatomic) IBOutlet UITextField *commentTf;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;


@end

@implementation WeekEndDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.schemaArgu[@"Id"]) {
        self.url = [self.schemaArgu objectForKey:@"Id"];
    }
    [self subviewStyle];
//    [self loadWebView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//MARK: - override method
-(void)webViewStyle {
    [super webViewStyle];
    [self.webView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 50, 0)];
}

//MARK: - private methods
-(void)subviewStyle {
    
    [self addDoubleNavigationItemsWithImages:@[@"collect01",@"share"] firstBlock:^{
        //TODO:收藏
        
    } secondBlock:^{
        //TODO:分享
    }];

    [HYTool configViewLayer:self.commentTf withColor:RGB(238, 238, 238, 1.0)];
    [HYTool configViewLayer:self.commentTf size:16];
    
    UIView* leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 20)];
    UIImageView* imgV = [[UIImageView alloc] initWithImage:ImageNamed(@"write")];
    imgV.frame = CGRectMake(10, 0, 20, 20);
    [leftView addSubview:imgV];
    self.commentTf.leftView = leftView;
    self.commentTf.leftViewMode = UITextFieldViewModeAlways;
    
    [HYTool configViewLayer:self.commentBtn withColor:RGB(238, 238, 238, 1.0)];
    [HYTool configViewLayerRound:self.commentBtn];
}
@end
