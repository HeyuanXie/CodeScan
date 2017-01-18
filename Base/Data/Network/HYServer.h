//
//  HYServer.h
//  Base
//
//  Created by admin on 2017/1/17.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYServer : NSObject

@property(nonatomic, copy, readonly) NSURL *APIEndpoint;

@property(nonatomic, copy, readonly) NSURL *baseURL;

@property(nonatomic, copy, readonly) NSString *endPointPathComponent;

+ (instancetype)defaultServer;

+ (instancetype)defaultHttpsServer;

+ (instancetype)serverWithBaseURL:(NSURL *)baseURL;

+ (instancetype)serverWithBaseURL:(NSURL *)baseURL pathComponent:(NSString *)pathComp;

- (NSURL *)urlWithPath:(NSString *)path;

@end
