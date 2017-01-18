//
//  HYPaddingLabel.m
//  Base
//
//  Created by admin on 17/1/16.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "HYPaddingLabel.h"

@implementation HYPaddingLabel

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupPadding];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupPadding];
    }
    return self;
}

- (void)setupPadding {
    self.horizontalPadding = 5.f;
    self.verticalPadding = 0.f;
}

-(CGSize)intrinsicContentSize{
    CGSize contentSize = [super intrinsicContentSize];
    return CGSizeMake(contentSize.width + _horizontalPadding * 2,
                      contentSize.height + _verticalPadding * 2);
}

@end
