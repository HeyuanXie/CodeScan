//
//  UILabel+HYLabels.h
//  Base
//
//  Created by admin on 17/1/16.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (HYLabels)

- (void)setMultiLineText:(NSString *)text;

- (void)setMultiLineAttributedText:(NSAttributedString *)text;

- (void)setOrderStatus:(NSString *)statusCode;

- (void)setDetailedOrderStatus:(NSString *)statusCode;

//- (void)setStrikeOutPrice:(double)price;

@end
