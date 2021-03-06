//
//  Global.h
//  Base
//
//  Created by admin on 17/1/16.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Global : NSObject

+ (long long)cacheSize;

+ (void)clearCacheWithCompletionHandler:(void(^)())completionHandler;

+ (NSString*)userAuth;
+ (void)setUserAuth:(NSString *)auth;

@end
