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

//MARK:CreateUI
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

+(UITextView *)getTextViewWithFrame:(CGRect)frame placeHolder:(NSString *)holder fontSize:(CGFloat)size textColor:(UIColor *)color {

    UITextView* textView = [[UITextView alloc] initWithFrame:frame];
    textView.font = [UIFont systemFontOfSize:size];
    if (color) {
        textView.textColor = color;
    }else{
        textView.textColor = [UIColor hyBlackTextColor];
    }
    UILabel* label = [self getLabelWithFrame:CGRectMake(5, 5, frame.size.width, frame.size.height) text:holder fontSize:size textColor:[UIColor hyGrayTextColor] textAlignment:NSTextAlignmentLeft];
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
+(UIButton*)getButtonWithFrame:(CGRect)frame title:(NSString*)title titleSize:(CGFloat)size titleColor:(UIColor*)titleColor backgroundColor:(UIColor*)backgroundColor blockForClick:(void (^)())block {
    return [self getButtonWithFrame:frame title:title titleSize:size titleColorForNormal:titleColor titleColorForSelect:titleColor backgroundColor:backgroundColor blockForClick:block];
}

/// 设置选中文字颜色
+(UIButton*)getButtonWithFrame:(CGRect)frame title:(NSString*)title titleSize:(CGFloat)size titleColorForNormal:(UIColor*)titleColor titleColorForSelect:(UIColor*)selectColor backgroundColor:(UIColor*)backgroundColor blockForClick:(void(^)())block {
    UIButton* btn = [[UIButton alloc] initWithFrame:frame];
    btn.backgroundColor = backgroundColor;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    [btn setTitleColor:selectColor forState:UIControlStateSelected];
    btn.titleLabel.font = defaultSysFontWithSize(size);
    [btn bk_addEventHandler:^(id sender) {
        if (block != nil) {
            block();
        }
    } forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

//MARK:ConfigUI
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

+(void)configViewLayerFrame:(UIView*)view WithColor:(UIColor*)color {
    view.layer.borderWidth = 0.5;
    view.layer.borderColor = color.CGColor;
}

+(void)configViewLayerRound:(UIView*)view {
    view.layer.cornerRadius = view.bounds.size.width/2;
    view.layer.masksToBounds = YES;
}

+(void)configViewLayer:(UIView *)view withColor:(UIColor*)color {
    [self configViewLayer:view];
    [self configViewLayerFrame:view WithColor:color];
}


@end
