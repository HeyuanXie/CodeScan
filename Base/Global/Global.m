//
//  Global.m
//  Base
//
//  Created by admin on 17/1/16.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "Global.h"

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

+(NSString *)userAuth {
    return kGetObjectFromUserDefaults(@"userAuth");
}

+(void)setUserAuth:(NSString *)auth {
    [kNotificationCenter postNotificationName:kUserLogoutNotification object:nil];
    kSaveObjectToUserDefaults(@"userAuth", auth);
}

@end
