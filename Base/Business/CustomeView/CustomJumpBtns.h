//
//  CustomJumpBtns.h
//  Base
//
//  Created by admin on 2017/3/1.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomJumpBtns : UIView

@property(nonatomic,strong)UIView *botLine; //选中btn底部的线
@property(nonatomic,strong)UIColor *textColorForNormal;
@property(nonatomic,strong)UIColor *textColorForSelect;
@property(nonatomic,strong)UIButton *selectBtn;
@property(nonatomic,assign)NSArray *menuTitles;
@property(nonatomic,copy)void (^finished)(NSInteger index);
@property(nonatomic,copy)void (^setSelectedBtn)(UIButton* btn);
@property(nonatomic,assign)CGFloat btnTextSize;
@property(nonatomic,assign)BOOL isLineAdaptText;    //bottomLine是否随文字宽度改变


/**
 创建一个包换多个水平放置btn的view

 @param frame CustomJumpBtns的frame
 @param menutitles btns的title
 @param normalColor btns正常状态字体颜色
 @param selectedColor btns选中状态字体颜色
 @param isLineAdaptText botLine是否随btn的title的宽度改变
 @return 返回一个CustomJumpBtns
 */
+(CustomJumpBtns*)customBtnsWithFrame:(CGRect)frame menuTitles:(NSArray*)menutitles textColorForNormal:(UIColor*)normalColor textColorForSelect:(UIColor*)selectedColor isLineAdaptText:(BOOL)isLineAdaptText;

- (void)addSeparatedLine:(UIColor*)color;

@end
