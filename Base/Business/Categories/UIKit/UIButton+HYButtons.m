//
//  UIButton+HYButtons.m
//  Base
//
//  Created by admin on 17/1/16.
//  Copyrighy © 2017年 XHY. All righys reserved.
//

#import "UIButton+HYButtons.h"
#import "UIImage+HYImages.h"


@implementation UIButton (HYButtons)

- (void)setBlackStyle {
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    
    [self setBackgroundImage:[UIImage hyRoundRectImageWithFillColor:[UIColor blackColor] borderColor:nil borderWidth:0.f cornerRadius:0.f]
                    forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage hyRoundRectImageWithFillColor:[UIColor blackColor] borderColor:nil borderWidth:0.f cornerRadius:0.f]
                    forState:UIControlStateDisabled];
    [self setBackgroundImage:[UIImage hyRoundRectImageWithFillColor:[UIColor blackColor] borderColor:nil borderWidth:0.f cornerRadius:0.f]
                    forState:UIControlStateHighlighted];
    [self setBackgroundImage:[UIImage hyRoundRectImageWithFillColor:[UIColor blackColor] borderColor:nil borderWidth:0.f cornerRadius:0.f]
                    forState:UIControlStateSelected];
}


- (void)setBlackDisableGrayStyle{
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    
    [self setBackgroundImage:[UIImage hyRoundRectImageWithFillColor:[UIColor hyColorWithString:@"#cccccc"] borderColor:nil borderWidth:0.f cornerRadius:5.f]
                    forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage hyRoundRectImageWithFillColor:[UIColor hyColorWithString:@"#cccccc"] borderColor:nil borderWidth:0.f cornerRadius:5.f]
                    forState:UIControlStateDisabled];
    [self setBackgroundImage:[UIImage hyRoundRectImageWithFillColor:[UIColor hyColorWithString:@"#cccccc"] borderColor:nil borderWidth:0.f cornerRadius:5.f]
                    forState:UIControlStateHighlighted];
    [self setBackgroundImage:[UIImage hyRoundRectImageWithFillColor:[UIColor hyColorWithString:@"#cccccc"] borderColor:nil borderWidth:0.f cornerRadius:5.f]
                    forState:UIControlStateSelected];
}

- (void)setMainStyle{
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    
    [self setBackgroundImage:[UIImage hyRoundRectImageWithFillColor:[UIColor hyBarTintColor] borderColor:nil borderWidth:0.f cornerRadius:5.f]
                    forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage hyRoundRectImageWithFillColor:[UIColor hyBarTintColor] borderColor:nil borderWidth:0.f cornerRadius:5.f]
                    forState:UIControlStateDisabled];
    [self setBackgroundImage:[UIImage hyRoundRectImageWithFillColor:[UIColor hyBarTintColor] borderColor:nil borderWidth:0.f cornerRadius:5.f]
                    forState:UIControlStateHighlighted];
    [self setBackgroundImage:[UIImage hyRoundRectImageWithFillColor:[UIColor hyBarTintColor] borderColor:nil borderWidth:0.f cornerRadius:5.f]
                    forState:UIControlStateSelected];
}

- (void)setMainUnAngleStyle{
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    
    [self setBackgroundImage:[UIImage hyRoundRectImageWithFillColor:[UIColor hyBarTintColor] borderColor:nil borderWidth:0.f cornerRadius:0.f]
                    forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage hyRoundRectImageWithFillColor:[UIColor hyBarTintColor] borderColor:nil borderWidth:0.f cornerRadius:0.f]
                    forState:UIControlStateDisabled];
    [self setBackgroundImage:[UIImage hyRoundRectImageWithFillColor:[UIColor hyBarTintColor] borderColor:nil borderWidth:0.f cornerRadius:0.f]
                    forState:UIControlStateHighlighted];
    [self setBackgroundImage:[UIImage hyRoundRectImageWithFillColor:[UIColor hyBarTintColor] borderColor:nil borderWidth:0.f cornerRadius:0.f]
                    forState:UIControlStateSelected];
}

@end
