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
/**
 将时间字符串转成时间戳对象
 
 @param dateStr 输入的时间字符串
 @param formatStr 输入的时间字符串的格式
 @return 返回的时间戳对象
 */
+ (NSDate *)dateWithString:(NSString *)dateStr format:(NSString *)formatStr {
    if (formatStr == nil) {
        formatStr = defaultInputFormat;
    }
    NSDateFormatter* format = [[NSDateFormatter alloc] init];
    format.dateFormat = formatStr;
    return [format dateFromString:dateStr];
}

/**
 将时间戳对象以某种格式转成字符串
 
 @param date 输入的时间戳对象
 @param formatStr 输出时间字符串格式
 @return 返回的时间字符串
 */
+ (NSString *)dateStringWithDate:(NSDate *)date format:(NSString *)formatStr {
    if (formatStr == nil) {
        formatStr = defaultOutputFormat;
    }
    NSDateFormatter* format = [[NSDateFormatter alloc] init];
    format.dateFormat = formatStr;
    return [format stringFromDate:date];
}

/// 得到今天的dateString(formatter格式)
+(NSString*)dateStringWithFormatter:(NSString*)formatter {
    NSDate* currentDate = [NSDate date];
    return [self dateStringWithDate:currentDate format:formatter];
}

/**
 将某种格式时间字符串，转成另一种格式的时间字符串
 
 @param dateStr 时间字符串
 @param inputFormatStr 输入的时间戳格式
 @param outputFormatStr 输出的时间戳格式
 @return 返回的指定格式的时间字符串
 */
+ (NSString *)dateStringWithString:(NSString *)dateStr inputFormat:(NSString*)inputFormatStr outputFormat:(NSString *)outputFormatStr {
    if (outputFormatStr == nil) {
        outputFormatStr = defaultOutputFormat;
    }
    if (inputFormatStr == nil) {
        inputFormatStr = defaultInputFormat;
    }
    NSDateFormatter* format = [[NSDateFormatter alloc] init];
    format.dateFormat = outputFormatStr;
    return [format stringFromDate:[self dateWithString:dateStr format:inputFormatStr]];
}

+ (NSDate *)dateAfterMonths:(NSDate *)fromDate gapMonth:(NSInteger)gapMonthCount {
    //获取当年的月份，当月的总天数
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitCalendar fromDate:fromDate];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateStyle:NSDateFormatterFullStyle];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    //    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    //    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    
    NSString *dateStr = @"";
    NSInteger endDay = 0;//天
    NSDate *newDate = [NSDate date];//新的年&月
    //判断是否是下一年
    if (components.month+gapMonthCount > 12) {
        //是下一年
        dateStr = [NSString stringWithFormat:@"%zd-%zd-01",components.year+(components.month+gapMonthCount)/12,(components.month+gapMonthCount)%12];
        newDate = [formatter dateFromString:dateStr];
        //新月份的天数
        NSInteger newDays = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:newDate].length;
        if ([self isEndOfTheMonth:fromDate]) {//当前日期处于月末
            endDay = newDays;
        } else {
            endDay = newDays < components.day?newDays:components.day;
        }
        dateStr = [NSString stringWithFormat:@"%zd-%zd-%zd",components.year+(components.month+gapMonthCount)/12,(components.month+gapMonthCount)%12,endDay];
    } else {
        //依然是当前年份
        dateStr = [NSString stringWithFormat:@"%zd-%zd-01",components.year,components.month+gapMonthCount];
        newDate = [formatter dateFromString:dateStr];
        //新月份的天数
        NSInteger newDays = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:newDate].length;
        if ([HYTool isEndOfTheMonth:fromDate]) {//当前日期处于月末
            endDay = newDays;
        } else {
            endDay = newDays < components.day?newDays:components.day;
        }
        
        dateStr = [NSString stringWithFormat:@"%zd-%zd-%zd",components.year,components.month+gapMonthCount,endDay];
    }
    
    newDate = [formatter dateFromString:dateStr];
    return newDate;
}

//判断是否是月末
+ (BOOL)isEndOfTheMonth:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSInteger daysInMonth = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date].length;
    NSDateComponents *componets = [calendar components:NSCalendarUnitDay fromDate:date];
    if (componets.day >= daysInMonth) {
        return YES;
    }
    return NO;
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
