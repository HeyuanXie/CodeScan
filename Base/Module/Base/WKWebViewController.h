//
//  WKWebViewController.h
//  Base
//
//  Created by admin on 17/1/16.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "BaseViewController.h"
#import <WebKit/WebKit.h>

@interface WKWebViewController : BaseViewController

@property(nonatomic,copy)NSString* url;
@property(nonatomic,strong)WKWebView* webView;

/**
 viewDidLoad时，是否自动加载
 */
@property(nonatomic,assign)BOOL autoLoad;

-(void)webViewInit;
-(void)loadWebView;

@end
