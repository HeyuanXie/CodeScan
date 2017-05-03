//
//  WebViewController.h
//  Base
//
//  Created by admin on 17/1/16.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "BaseViewController.h"

@interface WebViewController : BaseViewController

@property(nonatomic,strong)UIWebView* webView;
@property(nonatomic,copy)NSString* url;


/**
 webview UI-init
 */
- (void)webViewStyle;

/**
 webview Data-load
 */
- (void)loadWebView;

@end
