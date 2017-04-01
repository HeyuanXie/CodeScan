//
//  APIHelper+Order.h
//  Base
//
//  Created by admin on 2017/4/1.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "APIHelper.h"

@interface APIHelper (Order)

- (void)orderListTheater:(NSInteger)start limit:(NSInteger)limit complete:(ApiRequestCompleteBlock)complete;
- (void)orderDetailTheater:(NSString*)orderSn complete:(ApiRequestCompleteBlock)complete;

- (void)orderListLecture:(NSInteger)start limit:(NSInteger)limit complete:(ApiRequestCompleteBlock)complete;
- (void)orderDetailLecture:(NSString*)orderSn complete:(ApiRequestCompleteBlock)complete;

- (void)orderListDerive:(NSInteger)start limit:(NSInteger)limit statu:(NSInteger)statu complete:(ApiRequestCompleteBlock)complete;
- (void)orderDetailDerive:(NSString*)orderSn complete:(ApiRequestCompleteBlock)complete;

- (void)orderListCard:(NSInteger)start limit:(NSInteger)limit statu:(NSInteger)statu complete:(ApiRequestCompleteBlock)complete;
- (void)orderDetailCard:(NSString*)orderSn complete:(ApiRequestCompleteBlock)complete;

@end
