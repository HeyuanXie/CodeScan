//
//  OpenRoutesManager.m
//  Base
//
//  Created by admin on 17/1/16.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "OpenRoutesManager.h"

NSString* const kHomeViewController = @"HomeViewController";
NSString* const kCollectViewController = @"CollectViewController";
NSString* const kOrderHomeController = @"OrderHomeController";
NSString* const kMineHomeViewController = @"MineHomeViewController";

NSString* const kTheaterListViewController = @"TheaterListViewController";
NSString* const kTheaterDetailViewController = @"TheaterDetailViewController";
NSString* const kTheaterTicketViewController = @"TheaterTicketViewController";
NSString* const kFilterAddressController = @"FilterAddressController";
NSString* const kFilterTableViewController = @"FilterTableViewController";
NSString* const kCommentViewController = @"CommentViewController";
NSString* const kCommentListController = @"CommentListController";
NSString* const kTheaterSeatPreviewController = @"TheaterSeatPreviewController";
NSString* const kTheaterSeatSelectController = @"TheaterSeatSelectController";
NSString* const kTheaterCommitOrderController = @"TheaterCommitOrderController";
NSString* const kTheaterCommitOrderSuccessController = @"TheaterCommitOrderSuccessController";
NSString* const kSelectCouponController = @"SelectCouponController";

NSString* const kLectureListController = @"LectureListController";
NSString* const kLectureDetailController = @"LectureDetailController";
NSString* const kLectureApplyController = @"LectureApplyController";

NSString* const kYearCardHomeController = @"YearCardHomeController";
NSString* const kYearCardCommitOrderController = @"YearCardCommitOrderController";
NSString* const kYearCardBindController = @"YearCardBindController";
NSString* const kYearCardBindSuccessController = @"YearCardBindSuccessController";
NSString* const kYearCardOrderController = @"YearCardOrderController";

NSString* const kDeriveListController = @"DeriveListController";
NSString* const kDeriveDetailController = @"DeriveDetailController";
NSString* const kDeriveOrderController = @"DeriveOrderController";
NSString* const kDeriveRecordController = @"DeriveRecordController";
NSString* const kDeriveExchangeSuccessController = @"DeriveExchangeSuccessControlelr";

NSString* const kOrderDetailController = @"OrderDetailController";
NSString* const kOrderCodeController = @"OrderCodeController";
NSString* const kOrderRefundController = @"OrderRefundController";
NSString* const kOrderRefundDetailController = @"OrderRefundDetailController";
NSString* const kOrderRefundSuccessController = @"OrderRefundSuccessController";

NSString* const kSkillListViewController = @"SkillListViewController";
NSString* const kSkillDetailController = @"SkillDetailController";
NSString* const kSkillSituationController = @"SkillSituationController";
NSString* const kSkillCompetitorController = @"SkillCompetitorController";
NSString* const kMineSupportViewController = @"MineSupportViewController";
NSString* const kSkillApplyViewController = @"SkillApplyViewController";
NSString* const kSkillUploadViewController = @"SkillUploadViewController";
NSString* const kSkillApplySucceedController = @"SkillApplySucceedController";

NSString* const kVideoListViewController = @"VideoListViewController";
NSString* const kVideoPlayViewController = @"VideoPlayViewController";

NSString* const kWeekEndListController = @"WeekEndListController";
NSString* const kWeekEndDetailController = @"WeekEndDetailController";

//Mine
NSString* const kSettingViewController = @"SettingViewController";
NSString* const kMessageHomeController = @"MessageHomeController";
NSString* const kMessageListController = @"MessageListController";
NSString* const kUserInfoViewController = @"UserInfoViewController";
NSString* const kFeedbackController = @"FeedbackController";
NSString* const kAboutUsViewController = @"AboutUsViewController";
NSString* const kAccountSecurityController = @"AccountSecurityController";

NSString* const kMineYearCardController = @"MineYearCardController";
NSString* const kYearCardDetailController = @"YearCardDetailController";
NSString* const kYearCardRecordController = @"YearCardRecordController";
NSString* const kMineApplyController = @"MineApplyController";
NSString* const kPointManageController = @"PointManageController";
NSString* const kPointDetailController = @"PointDetailController";
NSString* const kPointDescController = @"PointDescController";
NSString* const kMineCouponController = @"MineCouponController";
NSString* const kMineCommentController = @"MineCommentController";


NSString* const kRegistViewController = @"RegistViewController";
NSString* const kFinishRegisterController = @"FinishRegisterController";
NSString* const kLoginViewController = @"LoginViewController";
NSString* const kChangePasswordController = @"ChangePasswordController";
NSString* const kBindPhoneController = @"BindPhoneController";
NSString* const kBindPhoneChangeController = @"BindPhoneChangeController";
NSString* const kCheckCodeController = @"CheckCodeController";
NSString* const kDidBindPhoneController = @"DidBindPhoneController";

NSString* const kSearchGuideController = @"SearchGuideController";
NSString* const kSearchResultController = @"SearchResultController";
NSString* const kFilterClassTableViewController = @"FilterClassTableViewController";
NSString* const kAddressController = @"HYAddressController";

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
                        @{@"cls":kHomeViewController,@"sb":@"Main",@"method":@"push"},
                        @{@"cls":kCollectViewController,@"sb":@"Collect",@"method":@"push"},
                        @{@"cls":kOrderHomeController,@"sb":@"Order",@"method":@"push"},
                        @{@"cls":kMineHomeViewController,@"sb":@"Mine",@"method":@"push"},
                        
                        @{@"cls":kTheaterListViewController,@"sb":@"Main",@"method":@"push"},
                        @{@"cls":kTheaterDetailViewController,@"sb":@"Main",@"method":@"push"},
                        @{@"cls":kTheaterTicketViewController,@"sb":@"Main",@"method":@"push"},
                        @{@"cls":kFilterAddressController,@"sb":@"Main",@"method":@"push"},
                        @{@"cls":kFilterTableViewController,@"sb":@"Main",@"method":@"push"},
                        @{@"cls":kCommentViewController,@"sb":@"Main",@"method":@"push"},
                        @{@"cls":kCommentListController,@"sb":@"Main",@"method":@"push"},
                        @{@"cls":kTheaterSeatPreviewController,@"sb":@"Main",@"method":@"push"},
                        @{@"cls":kTheaterSeatSelectController,@"sb":@"Main",@"method":@"push"},
                        @{@"cls":kTheaterCommitOrderController,@"sb":@"Main",@"method":@"push"},
                        @{@"cls":kTheaterCommitOrderSuccessController,@"sb":@"Main",@"method":@"push"},
                        @{@"cls":kSelectCouponController,@"sb":@"Main",@"method":@"push"},

                        @{@"cls":kLectureListController,@"sb":@"Main",@"method":@"push"},
                        @{@"cls":kLectureDetailController,@"sb":@"Main",@"method":@"push"},
                        @{@"cls":kLectureApplyController,@"sb":@"Main",@"method":@"push"},

                        @{@"cls":kYearCardHomeController,@"sb":@"Main",@"method":@"push"},
                        @{@"cls":kYearCardCommitOrderController,@"sb":@"Main",@"method":@"push"},
                        @{@"cls":kYearCardBindController,@"sb":@"Main",@"method":@"push"},
                        @{@"cls":kYearCardBindSuccessController,@"sb":@"Main",@"method":@"push"},
                        @{@"cls":kYearCardOrderController,@"sb":@"Main",@"method":@"push"},

                        @{@"cls":kDeriveListController,@"sb":@"Main",@"method":@"push"},
                        @{@"cls":kDeriveDetailController,@"sb":@"Main",@"method":@"push"},
                        @{@"cls":kDeriveOrderController,@"sb":@"Main",@"method":@"push"},
                        @{@"cls":kDeriveRecordController,@"sb":@"Main",@"method":@"push"},
                        @{@"cls":kDeriveExchangeSuccessController,@"sb":@"Main",@"method":@"push"},
                        
                        @{@"cls":kOrderDetailController,@"sb":@"Order",@"method":@"push"},
                        @{@"cls":kOrderCodeController,@"sb":@"Order",@"method":@"push"},
                        @{@"cls":kOrderRefundController,@"sb":@"Order",@"method":@"push"},
                        @{@"cls":kOrderRefundDetailController,@"sb":@"Order",@"method":@"push"},
                        @{@"cls":kOrderRefundSuccessController,@"sb":@"Order",@"method":@"push"},
                        
                        @{@"cls":kSkillListViewController,@"sb":@"Main",@"method":@"push"},
                        @{@"cls":kSkillDetailController,@"sb":@"Main",@"method":@"push"},
                        @{@"cls":kSkillSituationController,@"sb":@"Main",@"method":@"push"},
                        @{@"cls":kSkillCompetitorController,@"sb":@"Main",@"method":@"push"},
                        @{@"cls":kMineSupportViewController,@"sb":@"Main",@"method":@"push"},
                        @{@"cls":kSkillApplyViewController,@"sb":@"Main",@"method":@"push"},
                        @{@"cls":kSkillUploadViewController,@"sb":@"Main",@"method":@"push"},
                        @{@"cls":kSkillApplySucceedController,@"sb":@"Main",@"method":@"push"},
                        
                        @{@"cls":kVideoListViewController,@"sb":@"Main",@"method":@"push"},
                        @{@"cls":kVideoPlayViewController,@"sb":@"Main",@"method":@"push"},
                        
                        @{@"cls":kWeekEndListController,@"sb":@"Main",@"method":@"push"},
                        @{@"cls":kWeekEndDetailController,@"sb":@"Main",@"method":@"push"},
                        
                        @{@"cls":kSettingViewController,@"sb":@"Mine",@"method":@"push"},
                        @{@"cls":kUserInfoViewController,@"sb":@"Mine",@"method":@"push"},
                        @{@"cls":kMessageHomeController,@"sb":@"Mine",@"method":@"push"},
                        @{@"cls":kMessageListController,@"sb":@"Mine",@"method":@"push"},
                        @{@"cls":kFeedbackController,@"sb":@"Mine",@"method":@"push"},
                        @{@"cls":kAboutUsViewController,@"sb":@"Mine",@"method":@"push"},
                        @{@"cls":kAccountSecurityController,@"sb":@"Mine",@"method":@"push"},
                        @{@"cls":kMineYearCardController,@"sb":@"Mine",@"method":@"push"},
                        @{@"cls":kYearCardDetailController,@"sb":@"Mine",@"method":@"push"},
                        @{@"cls":kYearCardRecordController,@"sb":@"Mine",@"method":@"push"},
                        @{@"cls":kMineApplyController,@"sb":@"Mine",@"method":@"push"},
                        @{@"cls":kPointManageController,@"sb":@"Mine",@"method":@"push"},
                        @{@"cls":kPointDetailController,@"sb":@"Mine",@"method":@"push"},
                        @{@"cls":kPointDescController,@"sb":@"Mine",@"method":@"push"},
                        @{@"cls":kMineCouponController,@"sb":@"Mine",@"method":@"push"},
                        @{@"cls":kMineCommentController,@"sb":@"Mine",@"method":@"push"},

                        @{@"cls":kRegistViewController,@"sb":@"Login",@"method":@"push"},
                        @{@"cls":kLoginViewController,@"sb":@"Login",@"method":@"push"},
                        @{@"cls":kFinishRegisterController,@"sb":@"Login",@"method":@"push"},
                        @{@"cls":kChangePasswordController,@"sb":@"Login",@"method":@"push"},
                        @{@"cls":kBindPhoneController,@"sb":@"Login",@"method":@"push"},
                        @{@"cls":kBindPhoneChangeController,@"sb":@"Login",@"method":@"push"},
                        @{@"cls":kCheckCodeController,@"sb":@"Login",@"method":@"push"},
                        @{@"cls":kDidBindPhoneController,@"sb":@"Login",@"method":@"push"},
                        
                        @{@"cls":kSearchGuideController,@"sb":@"Main",@"method":@"push"},
                        @{@"cls":kSearchResultController,@"sb":@"Main",@"method":@"push"},
                        @{@"cls":kFilterClassTableViewController,@"sb":@"Policy",@"method":@"push"},
                        @{@"cls":kAddressController,@"sb":@"Login",@"method":@"push"},
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
