//
//  OpenRoutesManager.m
//  Base
//
//  Created by admin on 17/1/16.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "OpenRoutesManager.h"

NSString* const kLoginViewController = @"LoginViewController";
NSString* const kCodeScanController = @"CodeScanController";
NSString* const kCodeInputController = @"CodeInputController";
NSString* const kScanResultController = @"ScanResultController";

@implementation OpenRoutesManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

+(id)shareInstance {
    static OpenRoutesManager* manager = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        if (manager == nil) {
            manager = [[OpenRoutesManager alloc] init];
        }
    });
    return manager;
}

-(NSArray*)routeConfigs {
    NSArray *routes = @[
                        @{@"cls":kLoginViewController,@"sb":@"Login",@"method":@"push"},
                        @{@"cls":kCodeScanController,@"sb":@"Login",@"method":@"push"},
                        @{@"cls":kCodeInputController,@"sb":@"Login",@"method":@"push"},
                        @{@"cls":kScanResultController,@"sb":@"Login",@"method":@"push"}
                        ];
    return routes;
}



-(void)registSchema {
    NSArray * arr = [self routeConfigs];
    for (NSDictionary *item in arr) {
        NSString* cls = [item objectForKey:@"cls"];
        NSString* sb = [item objectForKey:@"sb"];
        NSString* method = [item objectForKey:@"method"];
        if ([method isEqualToString:@"push"]) {
            [JLRoutes addRoute:cls handler:^BOOL(NSDictionary<NSString *,id> * _Nonnull parameters) {
                [self navigationToViewControler:cls argu:parameters storyboard:sb];
                return YES;
            }];
        }else{
            [JLRoutes addRoute:cls handler:^BOOL(NSDictionary<NSString *,id> * _Nonnull parameters) {
                [self presentToViewControler:cls argu:parameters storyboard:sb];
                return NO;
            }];
        }
    }
}

-(void)routeSchemaByURL:(NSURL*)url {
    if ([url.scheme isEqualToString:@"http"]) {
        // to webview
        return;
    }
    [JLRoutes routeURL:url];
}

-(void)routeSchemaByString:(NSString*)urlstr {
    NSString *encodingString = [urlstr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [self routeSchemaByURL:[NSURL URLWithString:encodingString]];
}

-(void)routeByStoryboardID:(NSString*)sid {
    [self routeSchemaByString:[NSString stringWithFormat:@"Base://%@",sid]];
}

-(void)routeByStoryboardID:(NSString*)sid withParam:(NSDictionary*)param {
    //参数序列号
    NSMutableString *str = [[NSMutableString alloc] init];
    for (NSString *key in param.allKeys) {
        NSString *args = [NSString stringWithFormat:@"%@=%@&",key,[param objectForKey:key]];
        [str appendString:args];
    }
    NSString *p = [NSString stringWithFormat:@"%@?%@",sid,str];
    [self routeByStoryboardID:p];
}

-(UIViewController *)viewControllerForStoryboardID:(NSString*)storyboardID {
    NSArray *arr = [self routeConfigs];
    for (NSDictionary *item in arr) {
        NSString *cls = [item objectForKey:@"cls"];
        NSString *sb = [item objectForKey:@"sb"];
        if ([storyboardID isEqualToString:cls]) {
            UIStoryboard *m = [UIStoryboard storyboardWithName:sb bundle:nil];
            UIViewController *tarvc = [m instantiateViewControllerWithIdentifier:storyboardID];
            return tarvc;
        }
    }
    return nil;
}


#pragma mark - help
-(UIViewController*)getCurrentRootViewController {
    
    UIViewController *result;
    UIWindow *topWindow = [[[UIApplication sharedApplication] windows] firstObject];
    
    if (topWindow.windowLevel != UIWindowLevelNormal){
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(topWindow in windows){
            if (topWindow.windowLevel == UIWindowLevelNormal)
                break;
        }
    }
    
    UIView *rootView = [[topWindow subviews] objectAtIndex:0];
    id nextResponder = [rootView nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else if ([topWindow respondsToSelector:@selector(rootViewController)] && topWindow.rootViewController != nil)
        result = topWindow.rootViewController;
    else
        NSAssert(NO, @"ShareKit: Could not find a root view controller.  You can assign one manually by calling [[SHK currentHelper] setRootViewController:YOURROOTVIEWCONTROLLER].");
    return result;
}

-(void)presentToViewControler:(NSString*)vcIdentifier argu:(NSDictionary*)argu storyboard:(NSString*)sb
{
    UITabBarController *tab = (UITabBarController*)[self getCurrentRootViewController];
    UINavigationController *nav = tab.viewControllers[tab.selectedIndex];
    UIViewController *tarvc = nil;
    if (sb && sb.length) {
        UIStoryboard *m = [UIStoryboard storyboardWithName:sb bundle:[NSBundle mainBundle]];
        tarvc = [m instantiateViewControllerWithIdentifier:vcIdentifier];
    }else{
        tarvc = [NSClassFromString(vcIdentifier) new];
    }
    UINavigationController *navtar = [[UINavigationController alloc] initWithRootViewController:tarvc];
    tarvc.schemaArgu = argu;
    [tarvc setHidesBottomBarWhenPushed:YES];
    UIViewController *vis = [nav visibleViewController];
    if (vis) {
        [vis presentViewController:navtar animated:YES completion:nil];
    }else{
        [nav presentViewController:navtar animated:YES completion:nil];
    }
}

-(void)navigationToViewControler:(NSString*)vcIdentifier argu:(NSDictionary*)argu storyboard:(NSString*)sb
{
    UITabBarController *tab = (UITabBarController*)[self getCurrentRootViewController];
    UINavigationController *nav = tab.viewControllers[tab.selectedIndex];
    UIViewController *tarvc = nil;
    if (sb && sb.length) {
        UIStoryboard *m = [UIStoryboard storyboardWithName:sb bundle:[NSBundle mainBundle]];
        tarvc = [m instantiateViewControllerWithIdentifier:vcIdentifier];
    }else{
        tarvc = [NSClassFromString(vcIdentifier) new];
    }
    tarvc.schemaArgu = argu;
    [tarvc setHidesBottomBarWhenPushed:YES];
    UIViewController *vis = [nav visibleViewController];
    if (vis) {
        [vis.navigationController pushViewController:tarvc animated:YES];
    }else{
        [nav pushViewController:tarvc animated:YES];
    }
    if ([nav respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        nav.interactivePopGestureRecognizer.delegate = nil;
    }
}

@end
