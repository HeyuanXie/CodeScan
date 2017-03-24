//
//  Global.m
//  Base
//
//  Created by admin on 17/1/16.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "Global.h"
#import "LTKeyChain.h"

@implementation Global

+(long long)cacheSize {
    SDImageCache * sdCache = [SDImageCache sharedImageCache];
    long long size = sdCache.getSize;
    SDWebImageManager * manager = [SDWebImageManager sharedManager];
    size += manager.imageCache.getSize;
    return size;
}

+ (void)clearCacheWithCompletionHandler:(void(^)())completionHandler {

    SDImageCache* sdCache = [SDImageCache sharedImageCache];
    [sdCache clearMemory];
    [sdCache cleanDisk];
    
    //SDWebImageManager图片清除
    SDWebImageManager * manager = [SDWebImageManager sharedManager];
    [manager.imageCache clearMemory];
    [manager.imageCache clearDiskOnCompletion:completionHandler];
}

#define kUDIDKeyChain   @"identifierVendorKeyChainKey"
+ (NSString *)IDFV
{
    //ios 7 禁用网卡地址,所以改为UDID ＋ keychain
    NSString *passWord =  [LTKeyChain load:kUDIDKeyChain];
    
    if (passWord && ![passWord isEqualToString:@"(null)"] && ![passWord isEqualToString:@"-1"]) {
        return passWord;
    }
    else{
        NSString *identifierVendor = [[UIDevice currentDevice] identifierForVendor].UUIDString;
        [LTKeyChain save:kUDIDKeyChain data:identifierVendor];
        return identifierVendor;
    }
}

+(NSString *)userAuth {
    return kGetObjectFromUserDefaults(@"userAuth");
}

+(void)setUserAuth:(NSString *)auth {
    [kNotificationCenter postNotificationName:kUserLogoutNotification object:nil];
    kSaveObjectToUserDefaults(@"userAuth", auth);
}

@end
