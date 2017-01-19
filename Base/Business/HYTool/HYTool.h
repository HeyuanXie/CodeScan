//
//  HYTool.h
//  Base
//
//  Created by admin on 2017/1/18.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa.h>
@interface HYTool : NSObject

+(instancetype)shareHYTool;

#pragma mark createUI
+(UITextField*)getTextFieldWithFrame:(CGRect)frame placeHolder:(NSString*)holder fontSize:(CGFloat)size textColor:(UIColor*)color;

+(UITextView*)getTextViewWithFrame:(CGRect)frame placeHolder:(NSString*)holder fontSize:(CGFloat)size textColor:(UIColor*)color;

+(UILabel*)getLabelWithFrame:(CGRect)frame text:(NSString*)text fontSize:(CGFloat)size textColor:(UIColor*)color textAlignment:(NSTextAlignment)alignment;

+(UIView*)getLineWithFrame:(CGRect)frame lineColor:(UIColor*)color;

+(UIButton*)getButtonWithFrame:(CGRect)frame title:(NSString*)title titleSize:(CGFloat)size titleColor:(UIColor*)titleColor backgroundColor:(UIColor*)backgroundColor blockForClick:(void (^)())block;

+(UIButton*)getButtonWithFrame:(CGRect)frame title:(NSString*)title titleSize:(CGFloat)size titleColorForNormal:(UIColor*)titleColor titleColorForSelect:(UIColor*)selectColor backgroundColor:(UIColor*)backgroundColor blockForClick:(void(^)())block;

//MARK:configUI
+(void)configTableViewCellDefault:(UITableViewCell*)cell;

+(void)configViewLayer:(UIView*)view;

+(void)configViewLayer:(UIView*)view size:(CGFloat)size;

+(void)configViewLayerFrame:(UIView*)view;

+(void)configViewLayerFrame:(UIView*)view WithColor:(UIColor*)color;

+(void)configViewLayerRound:(UIView*)view;

+(void)configViewLayer:(UIView *)view withColor:(UIColor*)color;

@end
