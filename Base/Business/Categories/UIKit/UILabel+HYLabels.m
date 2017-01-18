//
//  UILabel+HYLabels.m
//  Base
//
//  Created by admin on 17/1/16.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "UILabel+HYLabels.h"

@implementation UILabel (HYLabels)

+ (NSDictionary*) orderStatusMapping{
    static NSDictionary *mapping;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"OrderStatus" ofType:@"plist"];
        mapping = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    });
    return mapping;
}

- (void)setMultiLineText:(NSString *)text {
    NSMutableAttributedString * attrString = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle * pStyle = [[NSMutableParagraphStyle alloc] init];
    [pStyle setLineSpacing:5];
    [attrString addAttribute:NSParagraphStyleAttributeName value:pStyle range:NSMakeRange(0, [text length])];
    [self setAttributedText:attrString];
}

- (void)setMultiLineAttributedText:(NSAttributedString *)text{
    NSMutableAttributedString * attrString = [[NSMutableAttributedString alloc] initWithAttributedString:text];
    NSMutableParagraphStyle * pStyle = [[NSMutableParagraphStyle alloc] init];
    [pStyle setLineSpacing:5];
    [attrString addAttribute:NSParagraphStyleAttributeName value:pStyle range:NSMakeRange(0, [text length])];
    [self setAttributedText:attrString];
}

- (void)setOrderStatus:(NSString *)statusCode {
    NSDictionary *status = [[UILabel orderStatusMapping] objectForKey:statusCode];
    if (status) {
        self.text = [status objectForKey:@"desc"];
        self.textColor = [UIColor colorWithString:[status objectForKey:@"color"]];
    } else {
        self.text = @"";
        self.textColor = [UIColor blackColor];
    }
}

/**
 *状态码： 0：订单未提交。10：订单已提交；11：订单已取消；12：订单取消中；20：订单已支付；21：待认证 ；22：认证失败 ； 23：认证成功；24：待报关；25：报关失败；26：报关成功； 30：订单已审核。40：订单已进入配货；50：订单已出库；
 60：订单已送达；61：订单已拒收；70：订单已全部退货；100：订单交易成功（过了包退期未全部退货）
 */
- (void)setDetailedOrderStatus:(NSString *)statusCode {
    NSDictionary *status = [[UILabel orderStatusMapping] objectForKey:statusCode];
    if (status) {
        self.text = [status objectForKey:@"detail"];
        self.textColor = [UIColor colorWithString:[status objectForKey:@"color"]];
    } else {
        self.text = @"";
        self.textColor = [UIColor blackColor];
    }
}

//- (void)setStrikeOutPrice:(double)price {
//    NSMutableAttributedString *titleString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%@", [@(price) priceString]]];
//
//    [titleString addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [titleString length])];
//    [self  setAttributedText:titleString];
//}

@end
