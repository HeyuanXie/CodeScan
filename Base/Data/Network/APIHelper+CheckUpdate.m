//
//  APIHelper+CheckUpdate.m
//  Base
//
//  Created by admin on 2017/4/27.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "APIHelper+CheckUpdate.h"
#import "HYAlertView.h"

@implementation APIHelper (CheckUpdate)

-(void)checkUpdate {
    __block NSString* version = @"0.0.0";
    [APIHELPER postWithURL:APP_URL_DETAIL param:nil complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
        if (isSuccess) {
            if ([responseObject[@"resultCount"] integerValue] == 0) {
                return ;
            }
            NSDictionary* dict = responseObject[@"results"][0];
            if (dict[@"version"] != nil) {
                version = dict[@"version"];
            }
            kSaveObjectToUserDefaults(@"appStoreVersion", version);
            [self compareTheVersion];
        }
    }];
}

- (void)compareTheVersion {
    NSString* appStoreVersion = kGetObjectFromUserDefaults(@"appStoreVersion");
    if ([appStoreVersion isEqualToString:@"0.0.0"]) {
        return;
    }
    NSComparisonResult result = [self compareVersionWithVersion1:APP_VERSION version2:appStoreVersion];
    if (result == NSOrderedAscending) {
        HYAlertView* alert = [HYAlertView sharedInstance];
        [alert showAlertView:@"版本更新" message:[NSString stringWithFormat:@"检测到新版本%@,是否立即更新?",appStoreVersion] subBottonTitle:@"确定" cancelButtonTitle:@"下次" handler:^(AlertViewClickBottonType bottonType) {
            if (bottonType == AlertViewClickBottonTypeSubBotton) {
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:APP_URL_IN_ITUNE]];
                });
            }
        }];
    }
}

/// 版本比较(无法进行比较会返回nil)（version1为本地版本）
- (NSComparisonResult)compareVersionWithVersion1:(NSString*)version1 version2:(NSString*)version2 {
    NSArray* version1Array = [version1 componentsSeparatedByString:@"."];
    NSArray* version2Array = [version2 componentsSeparatedByString:@"."];
    
    NSInteger iCount = MIN(version1Array.count, version2Array.count);
    if (iCount == 0) {
        return NSOrderedSame; //无法比较，version格式错误
    }
    
    for (int i=0; i<iCount; i++) {
        if (version1Array[i] != nil && version2Array[i] != nil ) {
            NSInteger iVersion1Sub = [version1Array[i] integerValue];
            NSInteger iVersion2Sub = [version2Array[i] integerValue];
            if (iVersion1Sub == iVersion2Sub) {
                continue; // 相同，则去判断下一个位置
            }
            else if (iVersion1Sub > iVersion2Sub) {
                return NSOrderedDescending;      //基本不会有这种情况
            }
            else{
                return NSOrderedAscending;  //本地比appStore小
            }
        }else{
            return NSOrderedSame; //无法比较, version格式错误
        }
    }
    
    if (version1Array.count == version2Array.count) {
        return NSOrderedSame;
    }
    else if (version1Array.count > version2Array.count) {
        return NSOrderedDescending;
    }
    else {
        return NSOrderedAscending;
    }
}

@end
