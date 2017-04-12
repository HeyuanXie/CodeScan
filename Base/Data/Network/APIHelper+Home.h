//
//  APIHelper+Home.h
//  Base
//
//  Created by admin on 2017/2/6.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "APIHelper.h"

@interface APIHelper (Home)

-(void)fetchHomePageData:(NSString*)city
                complete:(ApiRequestCompleteBlock)complete;

-(void)homeSearch:(NSInteger)start
            limit:(NSInteger)limit
          keyword:(NSString*)keyword
             type:(NSString*)type
         complete:(ApiRequestCompleteBlock)complete;

@end
