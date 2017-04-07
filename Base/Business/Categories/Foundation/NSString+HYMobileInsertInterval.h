//
//  NSString+HYMobileInsertInterval.h
//  Base
//
//  Created by admin on 17/1/16.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (HYMobileInsertInterval)

/**
 *  电话 分割   例如 18520374303 返回 185-2037-4303
 *
 *  @return 185-2037-4303
 */
- (NSString *)HTMobileInsertInterval;


/**
 电话 中间四位数变密文 例如 15377679514 返回 153****9514

 @return 153****9514
 */
- (NSString *)HTMobileInsertSecurity;

- (NSString *)HtIdCardNumInsertInterval;

- (NSMutableAttributedString *)htPriceUnitTreatment;

- (NSAttributedString *)fetchSpaceLineWithFont:(UIFont *) font WithLineSpace:(CGFloat ) lineSpace;

@end
