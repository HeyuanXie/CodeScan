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

-(void)webViewInit;
-(void)loadWebView;

@end
