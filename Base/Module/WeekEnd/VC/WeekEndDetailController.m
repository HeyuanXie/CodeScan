//
//  WeekEndDetailController.m
//  Base
//
//  Created by admin on 2017/3/21.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "WeekEndDetailController.h"
#import "UIViewController+Extension.h"
#import "APIHelper+User.h"

@interface WeekEndDetailController ()

@property (assign, nonatomic) NSInteger articleId;  //资讯或者周末去哪儿文章Id
@property (strong, nonatomic) NSString* collectImg; //navigationBar收藏按钮图片

@property (weak, nonatomic) IBOutlet UITextField *commentTf;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;


@end

@implementation WeekEndDetailController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.articleId = self.data.articleType.integerValue == 0 ? self.data.seekId.integerValue : self.data.articleId.integerValue;
    self.collectImg = self.data.isFav.boolValue ? @"collect02" : @"collect01";
    [self subviewStyle];
//    [self loadWebView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//MARK: - override method
-(void)webViewStyle {
    [super webViewStyle];
    [self.webView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 50, 0)];
}

//MARK: - private methods
-(void)subviewStyle {
    
    @weakify(self);
    [self addDoubleNavigationItemsWithImages:@[self.collectImg,@"share"] firstBlock:^{
        @strongify(self);
        //TODO:收藏 & 取消收藏
        if (self.data.isFav.boolValue) {
            [APIHELPER cancelCollect:self.articleId type:self.data.articleType.integerValue+1 complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
                if (isSuccess) {
                    [self showMessage:@"取消收藏成功"];
                    self.collectImg = @"collect01";
                    [self subviewStyle];
                }else{
                    [self showMessage:error.userInfo[NSLocalizedDescriptionKey]];
                }
            }];
        }else{
            [APIHELPER collect:self.articleId type:self.data.articleType.integerValue+1 complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
                if (isSuccess) {
                    [self showMessage:@"收藏成功"];
                    self.collectImg = @"collect02";
                    [self subviewStyle];
                }else{
                    [self showMessage:error.userInfo[NSLocalizedDescriptionKey]];
                }
            }];
        }
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
