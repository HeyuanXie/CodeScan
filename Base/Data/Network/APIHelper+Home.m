//
//  APIHelper+Home.m
//  Base
//
//  Created by admin on 2017/2/6.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "APIHelper+Home.h"

@implementation APIHelper (Home)

-(void)fetchHomePageData:(ApiRequestCompleteBlock)complete {
    [APIHELPER getWithURL:@"/api/article/home" param:nil complete:complete];
}

@end
