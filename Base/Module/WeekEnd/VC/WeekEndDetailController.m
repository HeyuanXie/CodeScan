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

@property (strong, nonatomic) NSString* collectImg; //navigationBar收藏按钮图片

@property (assign, nonatomic) BOOL isFav;
@property (assign, nonatomic) NSInteger articleId;
@property (assign, nonatomic) NSInteger type;   //2:资讯; 3:周末
@property (weak, nonatomic) IBOutlet UITextField *commentTf;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;

@end

@implementation WeekEndDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.schemaArgu[@"isFav"]) {
        self.isFav = [[self.schemaArgu objectForKey:@"isFav"] boolValue];
    }
    if (self.schemaArgu[@"articleId"]) {
        self.articleId = [[self.schemaArgu objectForKey:@"articleId"] integerValue];
    }
    if (self.schemaArgu[@"type"]) {
        self.type = [[self.schemaArgu objectForKey:@"type"] integerValue];
    }
    if (self.type == 2) {
        self.url = [NSString stringWithFormat:@"http://xfx.zhimadi.cn/seek?seek_id=%ld",self.articleId];
    }else{
        self.url = [NSString stringWithFormat:@"http://xfx.zhimadi.cn/article?article_id=%ld",self.articleId];
    }
    
    [self subviewStyle];
    [self loadWebView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//MARK: - override method

-(void)webViewInit {
    [super webViewInit];
    
    [self.webView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(-44, 0, -50, 0)];
    self.webView.scrollView.maximumZoomScale = 1.0;
    [self.view sendSubviewToBack:self.webView];
}

//MARK: - private methods
-(void)subviewStyle {
    
    NSArray* images = self.isFav ? @[@"collect02",@"share"] : @[@"collect01",@"share"];
    @weakify(self);
    [self addDoubleNavigationItemsWithImages:images firstBlock:^{
        @strongify(self);
        //TODO:收藏 & 取消收藏
        if (self.isFav) {
            [APIHELPER cancelCollect:self.articleId type:self.type complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
                if (isSuccess) {
                    [self showMessage:@"取消收藏成功"];
                    self.isFav = NO;
                    [self subviewStyle];
                }else{
                    [self showMessage:error.userInfo[NSLocalizedDescriptionKey]];
                }
            }];
        }else{
            [APIHELPER collect:self.articleId type:self.type complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
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
    
    [self.commentBtn bk_whenTapped:^{
        if ([self.commentTf.text isEmpty]) {
            [self showMessage:@"请填写评论内容!"];
            return ;
        }
        switch (self.type) {
            case 2:{
                [APIHELPER informationComment:self.articleId content:self.commentTf.text becommenId:0 complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
                    if (isSuccess) {
                        [self showMessage:@"评论成功"];
                        self.commentTf.text = @"";
                        [self.webView reload];
                    }else{
                        [self showMessage:error.userInfo[NSLocalizedDescriptionKey]];
                    }
                }];
                break;
            }
            default:{
                [APIHELPER weekEndComment:self.articleId content:self.commentTf.text becommenId:0 complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
                    if (isSuccess) {
                        [self showMessage:@"评论成功"];
                        self.commentTf.text = @"";
                        [self.webView reload];
                    }else{
                        [self showMessage:error.userInfo[NSLocalizedDescriptionKey]];
                    }
                }];
                break;
            }
        }
    }];
}
@end
