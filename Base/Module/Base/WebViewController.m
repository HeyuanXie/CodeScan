//
//  WebViewController.m
//  Base
//
//  Created by admin on 17/1/16.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "WebViewController.h"
#import <WebKit/WebKit.h>
#import "HYCacheURLProtocol.h"

@interface WebViewController () <UIWebViewDelegate>


@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self webViewStyle];
    /**在子控制器中调用父控制器WebViewController中的这个方法
     [self loadWebView];
     */
    // Do any additional setup after loading the view.
}



-(void)webViewStyle {
    
    [HYCacheURLProtocol startListeningNetworking];
    [HYCacheURLProtocol setUpdateInterval:60];
    
    self.webView = [[UIWebView alloc] init];
    self.webView.delegate = self;
    self.webView.scrollView.showsVerticalScrollIndicator = NO;
    self.webView.scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.webView];
    [self.webView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
}

-(void)loadWebView {
    if (self.url != nil) {
        NSURL *url = [NSURL URLWithString:self.url];
        NSMutableURLRequest* urlReq = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20];
//        [urlReq setValue:@"" forHTTPHeaderField:@""];   //定制请求头
        [self.webView loadRequest:urlReq];
        [self showLoadingAnimation];
    }
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [self hideLoadingAnimation];
    
    if ([webView stringByEvaluatingJavaScriptFromString:@"document.title"]) {
        self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    }
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    [self hideLoadingAnimation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    [HYCacheURLProtocol clearUrlDic];
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
