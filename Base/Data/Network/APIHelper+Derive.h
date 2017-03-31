//
//  APIHelper+Derive.h
//  Base
//
//  Created by admin on 2017/3/29.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "APIHelper.h"

@interface APIHelper (Derive)

-(void)deriveListStart:(NSInteger)start limit:(NSInteger)limit categoryId:(NSInteger)categoryId complete:(ApiRequestCompleteBlock)complete;

-(void)deriveDetail:(NSInteger)goodId complete:(ApiRequestCompleteBlock)complete;

-(void)deriveExchange:(NSInteger)goodId buyNum:(NSInteger)buyNum complete:(ApiRequestCompleteBlock)complete;

-(void)deriveOrderDetail:(NSString*)orderSn complete:(ApiRequestCompleteBlock)complete;

@end
