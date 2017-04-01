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

@property (strong, nonatomic) NSString* collectImg; //navigationBar收藏按钮图片

@property (weak, nonatomic) IBOutlet UITextField *commentTf;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;


@end

@implementation WeekEndDetailController

- (void)viewDidLoad {
    [super viewDidLoad];

    if (!self.isFav) {
        //从收藏列表进来直接就不为0，从文章列表进来就要从self.data中获取
        self.articleId = self.data.articleType.integerValue == 0 ? self.data.seekId.integerValue : self.data.articleId.integerValue;
        //从收藏列表进来直接是YES，从文章列表进来就要从self.data中获取
        self.isFav = self.data.isFav.boolValue;
        //从收藏列表进来直接有值，从文章列表进来就要从self.data中获取
        self.articleType = self.data.articleType.integerValue+2;
    }

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
    
    self.collectImg = self.isFav ? @"collect02" : @"collect01";
    @weakify(self);
    [self addDoubleNavigationItemsWithImages:@[self.collectImg,@"share"] firstBlock:^{
        @strongify(self);
        //TODO:收藏 & 取消收藏
        if (self.isFav) {
            [APIHELPER cancelCollect:self.articleId type:self.articleType complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
                if (isSuccess) {
                    [self showMessage:@"取消收藏成功"];
                    self.isFav = NO;
                    [self subviewStyle];
                }else{
                    [self showMessage:error.userInfo[NSLocalizedDescriptionKey]];
                }
            }];
        }else{
            [APIHELPER collect:self.articleId type:self.articleType complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
                if (isSuccess) {
                    [self showMessage:@"收藏成功"];
                    self.isFav = YES;
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
