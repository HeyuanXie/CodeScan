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
 是否自动加载(YES:无需调用loadWebView自动加载数据)
 */
@property(nonatomic,assign)BOOL autoLoad;


/**
 webview UI-init
 */
-(void)webViewInit;

/**
 webview Data-load
 */
-(void)loadWebView;

@end
