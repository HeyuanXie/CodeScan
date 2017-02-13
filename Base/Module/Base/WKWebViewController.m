//
//  WKWebViewController.m
//  Base
//
//  Created by admin on 17/1/16.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "WKWebViewController.h"
#import <WebKit/WebKit.h>
#import "HYCacheURLProtocol.h"

@interface WKWebViewController ()<WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler>

@property(nonatomic,strong)WKWebView* webView;
@property(nonatomic,strong)WKUserContentController* userCC;

@end

@implementation WKWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self webViewInit];
    [self loadWebView];
}

-(void)viewWillDisappear:(BOOL)animated {
    
    [HYCacheURLProtocol cancelListeningNetworking];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [HYCacheURLProtocol clearUrlDic];
}

#pragma mark - PrivateMethod
-(void)webViewInit {
    self.userCC = [[WKUserContentController alloc] init];
    NSString* jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
    WKUserScript* userScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    [_userCC addUserScript:userScript];
    WKWebViewConfiguration* config = [[WKWebViewConfiguration alloc] init];
    config.preferences.javaScriptCanOpenWindowsAutomatically = YES;
    config.userContentController = _userCC;
    

    
    self.webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:config];
    [self.view addSubview:self.webView];
    [self.webView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    self.webView.scrollView.zoomScale = 0;
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    self.webView.scrollView.showsHorizontalScrollIndicator = NO;
    self.webView.scrollView.showsVerticalScrollIndicator = NO;
    
    [HYCacheURLProtocol startListeningNetworking];
    [HYCacheURLProtocol setUpdateInterval:60];
}

-(void)loadWebView {
    if (self.url && self.url.length > 0) {
        NSURL* url = [NSURL URLWithString:self.url];
        NSURLRequest* urlReq = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20.0f];
        [self.webView loadRequest:urlReq];
        [self showLoadingAnimation];
    }
}

#pragma mark - WKJavaScriptMessageHandler
//注册JS方法
-(void)addScriptMessage:(WKUserContentController*)userCC {
    [userCC addScriptMessageHandler:self name:@""];
}

//JS方法回调
-(void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.name isEqualToString:@""]) {
        //...
    }
}


#pragma mark - WKNavigationDelegate

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self hideLoadingAnimation];
    NSString* webTitle = webView.title;
    self.navigationItem.title = webTitle;
    
    [self addScriptMessage:self.userCC];
}

-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    [self hideLoadingAnimation];
    [self showMessage:@"网络异常,请稍后再试!"];
}

#pragma mark - WKUIDelegate
-(void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    
}

-(void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler {
    
}

-(void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler {
    
}

//重写backAction
-(void)backAction {
    if (self.webView.canGoBack) {
        [self.webView goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}


@end
