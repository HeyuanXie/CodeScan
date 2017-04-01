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

-(void)bindYearCard:(NSString *)cardSn password:(NSString *)password complete:(ApiRequestCompleteBlock)complete {
    
    NSMutableDictionary* param = [NSMutableDictionary dictionary];
    [param safe_setValue:cardSn forKey:@"card_sn"];
    [param safe_setValue:password forKey:@"card_password"];
    [APIHELPER postWithURL:@"card/bind" param:param complete:complete];
}

@end
