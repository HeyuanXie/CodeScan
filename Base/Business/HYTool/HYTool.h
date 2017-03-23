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

#pragma mark - CreateUI
+(UITextField*)getTextFieldWithFrame:(CGRect)frame placeHolder:(NSString*)holder fontSize:(CGFloat)size textColor:(UIColor*)color;

+(UITextView*)getTextViewWithFrame:(CGRect)frame placeHolder:(NSString*)holder placeHolderColor:(UIColor*)holdColor fontSize:(CGFloat)size textColor:(UIColor*)color;

+(UILabel*)getLabelWithFrame:(CGRect)frame text:(NSString*)text fontSize:(CGFloat)size textColor:(UIColor*)color textAlignment:(NSTextAlignment)alignment;

+(UIView*)getLineWithFrame:(CGRect)frame lineColor:(UIColor*)color;

+(UIButton*)getButtonWithFrame:(CGRect)frame title:(NSString*)title titleSize:(CGFloat)size titleColor:(UIColor*)titleColor backgroundColor:(UIColor*)backgroundColor blockForClick:(void (^)(id sender))block;

+(UIButton*)getButtonWithFrame:(CGRect)frame title:(NSString*)title titleSize:(CGFloat)size titleColorForNormal:(UIColor*)titleColor titleColorForSelect:(UIColor*)selectColor backgroundColor:(UIColor*)backgroundColor blockForClick:(void(^)(id sender))block;

+(UITextField*)getSearchBarWithFrame:(CGRect)frame laceholder:(NSString *)placeholder;


#pragma mark - ConfigUI
+(void)configTableViewCellDefault:(UITableViewCell*)cell;

+(void)configViewLayer:(UIView*)view;

+(void)configViewLayer:(UIView*)view size:(CGFloat)size;

+(void)configViewLayerFrame:(UIView*)view;

+(void)configViewLayerFrame:(UIView *)view WithColor:(UIColor*)color borderWidth:(CGFloat)width;

+(void)configViewLayerFrame:(UIView*)view WithColor:(UIColor*)color;

+(void)configViewLayerRound:(UIView*)view;

+(void)configViewLayer:(UIView *)view withColor:(UIColor*)color;


#pragma mark - convenient
//MARK:-NSDate
+(NSString*)dateStringWithDate:(NSDate*)date andFormatter:(NSString*)formatter;
+(NSString*)dateStringWithFormatter:(NSString*)formatter;
+(NSString*)weekStirngWithDate:(NSDate*)date;
+(NSString*)weekString;

@end
