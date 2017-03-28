//
//  APIHelper+YearCard.m
//  Base
//
//  Created by admin on 2017/3/28.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "APIHelper+YearCard.h"

@implementation APIHelper (YearCard)

-(void)fetchYearCardInfoComplete:(ApiRequestCompleteBlock)complete {
    
    [APIHELPER getWithURL:@"card/detail" param:nil complete:complete];
}

@end
