//
//  HYTool.m
//  Base
//
//  Created by admin on 2017/1/18.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "HYTool.h"
#import <UIControl+BlocksKit.h>

@implementation HYTool

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

+(instancetype)shareHYTool {
    static HYTool* tool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (tool == nil) {
            tool = [[HYTool alloc] init];
        }
    });
    return tool;
}

#pragma mark - CreateUI
+(UITextField *)getTextFieldWithFrame:(CGRect)frame placeHolder:(NSString *)holder fontSize:(CGFloat)size textColor:(UIColor *)color {
    
    UITextField* field = [[UITextField alloc] initWithFrame:frame];
    field.font = [UIFont systemFontOfSize:size];
    field.placeholder = holder;
    if (color) {
        field.textColor = color;
    }else{
        field.textColor = [UIColor hyBlackTextColor];
    }
    return field;
}

+(UITextView*)getTextViewWithFrame:(CGRect)frame placeHolder:(NSString*)holder placeHolderColor:(UIColor*)holdColor fontSize:(CGFloat)size textColor:(UIColor*)color {

    UITextView* textView = [[UITextView alloc] initWithFrame:frame];
    textView.font = [UIFont systemFontOfSize:size];
    if (color) {
        textView.textColor = color;
    }else{
        textView.textColor = [UIColor hyBlackTextColor];
    }
    UILabel* label = [self getLabelWithFrame:CGRectMake(5, 5, frame.size.width, 20) text:holder fontSize:size textColor:nil textAlignment:NSTextAlignmentLeft];
    if (holdColor) {
        label.textColor = holdColor;
    }else{
        label.textColor = [UIColor hyGrayTextColor];
    }
    label.tag = 10000;
    [textView addSubview:label];
    return textView;
}

+(UILabel *)getLabelWithFrame:(CGRect)frame text:(NSString *)text fontSize:(CGFloat)size textColor:(UIColor *)color textAlignment:(NSTextAlignment)alignment {

    UILabel* label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = color == nil ? [UIColor hyBlackTextColor] : color;
    label.font = [UIFont systemFontOfSize:size];
    label.textAlignment = alignment;
    label.text = text;
    return label;
}

+(UIView *)getLineWithFrame:(CGRect)frame lineColor:(UIColor *)color {
    UIView* view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = color == nil ? [UIColor hySeparatorColor] : color;
    return view;
}

/// 不设置选中颜色
+(UIButton*)getButtonWithFrame:(CGRect)frame title:(NSString*)title titleSize:(CGFloat)size titleColor:(UIColor*)titleColor backgroundColor:(UIColor*)backgroundColor blockForClick:(void (^)(id sender))block {
    return [self getButtonWithFrame:frame title:title titleSize:size titleColorForNormal:titleColor titleColorForSelect:titleColor backgroundColor:backgroundColor blockForClick:block];
}

/// 设置选中文字颜色
+(UIButton*)getButtonWithFrame:(CGRect)frame title:(NSString*)title titleSize:(CGFloat)size titleColorForNormal:(UIColor*)titleColor titleColorForSelect:(UIColor*)selectColor backgroundColor:(UIColor*)backgroundColor blockForClick:(void(^)(id sender))block {
    UIButton* btn = [[UIButton alloc] initWithFrame:frame];
    btn.backgroundColor = backgroundColor;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    [btn setTitleColor:selectColor forState:UIControlStateSelected];
    btn.titleLabel.font = defaultSysFontWithSize(size);
    [btn bk_addEventHandler:^(id sender) {
        if (block != nil) {
            block(sender);
        }
    } forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

/// 搜索框
+(UITextField*)getSearchBarWithFrame:(CGRect)frame placeholder:(NSString *)placeholder {
    UITextField* textField = [[UITextField alloc] initWithFrame:frame];
    textField.placeholder = placeholder;
    [self configViewLayer:textField size:frame.size.height/2];
    
    UIImageView* imgView = [[UIImageView alloc] init];
    textField.leftView = imgView;
    
    return textField;
}


#pragma mark - ConfigUI
+ (void)configTableViewCellDefault:(UITableViewCell*)cell {
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = tableViewCellDefaultTextFont;
    cell.textLabel.textColor = tableViewCellDefaultTextColor;
    cell.contentView.backgroundColor = tableViewCellDefaultBackgroundColor;
    cell.detailTextLabel.font = tableViewCellDefaultDetailTextFont;
    cell.detailTextLabel.textColor = tableViewCellDefaultDetailTextColor;
}

+(void)configViewLayer:(UIView*)view {
    [self configViewLayer:view size:5];
}

+(void)configViewLayer:(UIView*)view size:(CGFloat)size {
    view.layer.cornerRadius = size;
    view.layer.masksToBounds = YES;
}

+(void)configViewLayerFrame:(UIView*)view {
    [self configViewLayerFrame:view WithColor:defaultLineColor];
}


/**
 设置UIView的borderColor、borderWidth
 
 @param view 设置的对象
 @param color borderColor
 @param width borderWidth
 */
+(void)configViewLayerFrame:(UIView *)view WithColor:(UIColor*)color borderWidth:(CGFloat)width {
    view.layer.borderWidth = width;
    view.layer.borderColor = color.CGColor;
}

+(void)configViewLayerFrame:(UIView*)view WithColor:(UIColor*)color {
    view.layer.borderWidth = 0.5;
    view.layer.borderColor = color.CGColor;
}

+(void)configViewLayerRound:(UIView*)view {
    view.layer.cornerRadius = view.bounds.size.height/2;
    view.layer.masksToBounds = YES;
}


/**
 设置UIView的圆角、borderColor(borderWidth默认为0.5)

 @param view 设置的对象
 @param color borderColor
 */
+(void)configViewLayer:(UIView *)view withColor:(UIColor*)color {
    [self configViewLayer:view];
    [self configViewLayerFrame:view WithColor:color];
}



#pragma mark - Convenient
/// 得到指定date的dateString(formatter格式)
+(NSString*)dateStringWithDate:(NSDate*)date andFormatter:(NSString*)formatter {
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatter];
    NSString* dateStr = [dateFormatter stringFromDate:date];
    return dateStr;
}
/// 得到今天的dateString(formatter格式)
+(NSString*)dateStringWithFormatter:(NSString*)formatter {
    NSDate* currentDate = [NSDate date];
    return [self dateStringWithDate:currentDate andFormatter:formatter];
}
/// 指定date是周几
+(NSString*)weekStirngWithDate:(NSDate*)date {
    NSCalendar* gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents* weekdayComponents = [gregorian components:NSCalendarUnitWeekday fromDate:date];
    NSInteger weekday = [weekdayComponents weekday];
    NSArray* weeks = @[@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六"];
    return weeks[weekday-1];
}
/// 今天是周几
+(NSString*)weekString {
    NSDate* currentDate = [NSDate date];
    return [self weekStirngWithDate:currentDate];
}

@end
