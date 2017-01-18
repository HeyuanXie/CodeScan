//
//  APIHelper+User.h
//  Base
//
//  Created by admin on 2017/1/17.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "APIHelper.h"

@interface APIHelper (User)

-(void)login:(NSString*) account password:(NSString*) pw complete:(ApiRequestCompleteBlock)complete;

@end
