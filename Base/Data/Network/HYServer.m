//
//  HYServer.m
//  Base
//
//  Created by admin on 2017/1/17.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "HYServer.h"

@implementation HYServer

#pragma mark - Properties

- (NSURL*)APIEndpoint {
    NSURL* url = [self.baseURL URLByAppendingPathComponent:self.endPointPathComponent];
    return url;
}

#pragma mark - LifeCircle

- (instancetype)initWithBaseURL:(NSURL *)baseURL pathComponent:(NSString *)pathComp {
    self = [super init];
    if (self == nil) {
        return nil;
    }
    _baseURL = baseURL;
    _endPointPathComponent = pathComp;
    return self;
}

//+ (instancetype)defaultHttpsServer {
//    return nil;
//}

+ (instancetype)defaultServer {
    return [HYServer serverWithBaseURL:[NSURL URLWithString:DEFAULT_SERVER] pathComponent:DEFAULT_PATH];
}

+ (instancetype)serverWithBaseURL:(NSURL *)baseURL {
    return [HYServer serverWithBaseURL:baseURL pathComponent:nil];
}

+ (instancetype)serverWithBaseURL:(NSURL *)baseURL pathComponent:(NSString *)pathComp {
    return [[HYServer alloc] initWithBaseURL:baseURL pathComponent:pathComp];
}

-(NSURL *)urlWithPath:(NSString *)path {
    NSURL *url = [self.baseURL URLByAppendingPathComponent:path];
    return url;
}

@end
