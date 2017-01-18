//
//  Global.m
//  Base
//
//  Created by admin on 17/1/16.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "Global.h"
#import "LTKeyChain.h"

#define kUserDefaults [NSUserDefaults standardUserDefaults]
// 从 [NSUserDefaults standardUserDefaults] 中获取数据
#define kGetObjectFromUserDefaults(key) [kUserDefaults objectForKey:key]
// 保存 obj 到 [NSUserDefaults standardUserDefaults] 中
#define kSaveObjectToUserDefaults(key, object) {\
NSData *myEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:object];\
[kUserDefaults setObject:myEncodedObject forKey:key]; \
[kUserDefaults synchronize]; }

#define kGetCustomObject(key, value) \
NSData *serialized = [[NSUserDefaults standardUserDefaults] objectForKey:key]; \
if(serialized){ \
value = [NSKeyedUnarchiver unarchiveObjectWithData:serialized];\
}\
else{ \
value = nil; \
}

// 保存 obj 到 [NSUserDefaults standardUserDefaults] 中
#define HSaveObjectToUserDefaults(key,object){\
[kUserDefaults setObject:object forKey:key]; \
[kUserDefaults synchronize]; }

// 从 [NSUserDefaults standardUserDefaults] 中获取数据
#define kGetObjectFromUserDefaults(key) [kUserDefaults objectForKey:key]


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

+(NSString *)userauth {
    return kGetObjectFromUserDefaults(@"userauth");
}
-(void)setUserauth:(NSString *)userauth {
    [kNotificationCenter postNotificationName:kUserLogoutNotification object:nil];
    HSaveObjectToUserDefaults(@"userauth", userauth);
}

@end
