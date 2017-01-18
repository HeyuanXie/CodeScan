//
//  UITextView+MaxLimit.m
//  Base
//
//  Created by admin on 17/1/16.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "UITextView+MaxLimit.h"
#import <objc/runtime.h>

#pragma mark - MaxHelper
@interface MaxHelper : NSObject

@property(nonatomic,assign) NSUInteger maxLength;
@property(nonatomic,strong) UITextView * tempTextView;

-(instancetype)initWithLength:(NSUInteger) maxLength WithTempTextView:(UITextView*)tempTextView;

@end

@implementation MaxHelper

-(instancetype)initWithLength:(NSUInteger)maxLength WithTempTextView:(UITextView *)tempTextView {
    if (self = [super init]) {
        _tempTextView = tempTextView;
        _maxLength = maxLength;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewValueChanged:) name:UITextViewTextDidBeginEditingNotification object:tempTextView];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewValueChanged:) name:UITextViewTextDidChangeNotification object:tempTextView];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewValueChanged:) name:UITextViewTextDidEndEditingNotification object:tempTextView];
    }
    return self;
}

- (void)textViewValueChanged:(NSNotification *) noti{
    UITextView *textView = (UITextView *)noti.object;
    
    NSString *toBeString = textView.text;
    
    NSString *lang =  textView.textInputMode.primaryLanguage;
    
    if ([lang isEqualToString:@"zh-Hans"]) {
        UITextRange *selectedRange = [textView markedTextRange];
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        if (!position) {
            if (toBeString.length > self.maxLength) {
                textView.text = [toBeString substringToIndex:self.maxLength];
            }
        }
        else{
        }
    }else{
        if (toBeString.length > self.maxLength) {
            
            textView.text = [toBeString substringToIndex:self.maxLength];
            
        }
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

// ===========================================================================
#pragma mark - MaxLimitHelper

@interface UITextView (MaxLimitHelper)

@property(nonatomic,strong)MaxHelper * helper;

@end

@implementation UITextView (MaxLimitHelper)

static void* dcUITextViewHelperKey = &dcUITextViewHelperKey;

- (void)setHelper:(MaxHelper *)helper {
    objc_setAssociatedObject(self, &dcUITextViewHelperKey, helper, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (MaxHelper*)helper{
    MaxHelper * tempHelper = objc_getAssociatedObject(self, dcUITextViewHelperKey);
    if (!tempHelper) {
        tempHelper = [[MaxHelper alloc] initWithLength:self.MaxNumberOfDescriptionChars WithTempTextView:self];
        [self setHelper:tempHelper];
    }
    return tempHelper;
}
@end

// ===========================================================================

@implementation UITextView (MaxLimit)

static void * dcUITextViewMaxLengthKey = &dcUITextViewMaxLengthKey;

- (void)setMaxNumberOfDescriptionChars:(NSUInteger)MaxNumberOfDescriptionChars{
    objc_setAssociatedObject(self, dcUITextViewMaxLengthKey, @(MaxNumberOfDescriptionChars), OBJC_ASSOCIATION_COPY);
    self.helper.maxLength = MaxNumberOfDescriptionChars;
}

- (NSUInteger)MaxNumberOfDescriptionChars{
    return [objc_getAssociatedObject(self, dcUITextViewMaxLengthKey) unsignedIntegerValue];
}

@end
