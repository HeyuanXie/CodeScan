//
//  APIHelper+YearCard.h
//  Base
//
//  Created by admin on 2017/3/28.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "APIHelper.h"

@interface APIHelper (YearCard)

-(void)fetchYearCardInfoComplete:(ApiRequestCompleteBlock)complete;

-(void)bindYearCard:(NSString*)cardSn password:(NSString*)password complete:(ApiRequestCompleteBlock)complete;

@end
