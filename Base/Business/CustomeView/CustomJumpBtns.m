//
//  CustomJumpBtns.m
//  Base
//
//  Created by admin on 2017/3/1.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "CustomJumpBtns.h"
#import "NSString+Extension.h"

@implementation CustomJumpBtns

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.btnTextSize = 14;
        self.isLineAdaptText = YES;
    }
    return self;
}

+(CustomJumpBtns*)customBtnsWithFrame:(CGRect)frame menuTitles:(NSArray *)menutitles textColorForNormal:(UIColor *)normalColor textColorForSelect:(UIColor *)selectedColor isLineAdaptText:(BOOL)isLineAdaptText {
    CustomJumpBtns* btns = [[CustomJumpBtns alloc] init];
    btns.frame = frame;
    btns.menuTitles = menutitles;
    btns.textColorForNormal = normalColor;
    btns.textColorForSelect = selectedColor;
    btns.isLineAdaptText = isLineAdaptText;
    [btns updateUI:menutitles];
    return btns;
}

- (void)updateUI:(NSArray*)menuTitles {
    self.botLine = [HYTool getLineWithFrame:CGRectMake(0, CGRectGetHeight(self.frame)-2, kScreen_Width/menuTitles.count, 2) lineColor:_textColorForSelect];
    [self addSubview:self.botLine];

    @weakify(self);
    self.setSelectedBtn = ^(UIButton* btn) {
        @strongify(self);
        self.selectBtn = btn;
        self.selectBtn.selected = YES;
        //点击btn,botLine的动画
        [UIView animateWithDuration:0.2 animations:^{
            CGRect selectBtnFrame = self.selectBtn.frame;
            if (self.isLineAdaptText) {
                CGSize size = [self.selectBtn.titleLabel.text sizeWithFont:[UIFont systemFontOfSize:self.btnTextSize] maxWidth:MAXFLOAT];
                self.botLine.frame = CGRectMake(CGRectGetMinX(selectBtnFrame) + (CGRectGetWidth(selectBtnFrame)-size.width)/2, CGRectGetHeight(self.frame)-3.5, size.width, 3.5);
            }else{
                self.botLine.frame = CGRectMake(CGRectGetMinX(selectBtnFrame), CGRectGetHeight(self.frame)-3.5, self.frame.size.width/menuTitles.count, 3.5);
            }
        }];
        if (self.finished) {
            self.finished(btn.tag-1000);
        }
    };

    int i = 0;
    CGFloat width = self.frame.size.width/menuTitles.count,height = CGRectGetHeight(self.frame) - 3.5;
    for (NSString* title in menuTitles) {
        CGFloat x = i * width;
        UIButton* btn = [HYTool getButtonWithFrame:CGRectMake(x, 0, width, height) title:title titleSize:self.btnTextSize titleColor:self.textColorForNormal backgroundColor:[UIColor clearColor] blockForClick:^(id sender) {
            self.selectBtn.selected = NO;
            self.setSelectedBtn((UIButton*)sender);
        }];
        [btn setTitleColor:self.textColorForSelect forState:UIControlStateSelected];
        btn.titleLabel.numberOfLines = 2;
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        btn.tag = 1000 + i;
        [self addSubview:btn];
        if (i == 0) {
            self.setSelectedBtn(btn);
        }
        i++;
    }
    [self addSubview:[HYTool getLineWithFrame:CGRectMake(0, self.frame.size.height-0.5, CGRectGetWidth(self.frame), 0.5) lineColor:nil]];
}

////menuTitle的setter方法，在给menuTitle赋值时更新UI
//- (void)setMenuTitles:(NSArray *)menuTitles {
//    [self updateUI:menuTitles];
//}

// 分割线
- (void)addSeparatedLine:(UIColor*)color {
    UIColor* lineColor = color == nil ? defaultLineColor : color;
    CGFloat width = kScreen_Width/_menuTitles.count;
    int i = 1;
    for (NSString* title in _menuTitles) {
        UIView* line = [HYTool getLineWithFrame:CGRectMake(width*i, (self.frame.size.height-25)/2, 0.5, 25) lineColor:lineColor];
        [self addSubview:line];
        i++;
    }
}


@end
