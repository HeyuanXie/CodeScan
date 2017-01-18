//
//  UIView+FrameExpand.m
//  Base
//
//  Created by admin on 17/1/16.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "UIView+FrameExpand.h"
#import "UIView+Layout.h"

@implementation UIView (FrameExpand)

#pragma mark - get line
-(UIView *)obtainBottomLine {

    return [self viewWithTag:0xff0b];
}

-(UIView *)obtainTopLine {
    
    return [self viewWithTag:0xff0a];
}

- (UIView *)obtainLeftLine {
    
    return [self viewWithTag:0xff0c];
}

- (UIView *)obtainRightLine {
    
    return [self viewWithTag:0xff0d];
}

#pragma mark - add line


/**
 添加底部线条

 @param x 起始点x坐标
 @param bEnd 线条是否延伸到最右边
 */
-(void)addBottomLineWithStartX:(NSInteger)x withEnd:(bool)bEnd {
    
    @autoreleasepool {
        if ([self viewWithTag:0xff0b]) {
            
        }
        else{
            
            NSInteger w = self.width - (bEnd ? 1 : 2) * x;
            
            __autoreleasing UIView *v = [[UIView alloc] initWithFrame:CGRectMake(x, self.height-0.55, w, 0.55)];
            v.backgroundColor = [UIColor hySeparatorColor];
            [self addSubview:v];
            v.tag = 0xff0b;
        }
    }
}

/**
 添加顶部分割线

 @param x 起始点x坐标
 @param bEnd 是否延伸到最右边
 */
-(void)addTopLineWithStartX:(NSInteger)x withEnd:(bool)bEnd {
    @autoreleasepool {
        if ([self viewWithTag:0xff0a]) {
            
        }
        else {
            NSInteger w = self.width - (bEnd ? 1 : 2) * x;
            
            __autoreleasing UIView *v = [[UIView alloc] initWithFrame:CGRectMake(x, 0, w, 0.55)];
            v.backgroundColor = [UIColor hySeparatorColor];
            [self addSubview:v];
            v.tag = 0xff0a;
        }
    }
}


/**
 添加左边分割线

 @param y 起始点y坐标
 @param bEnd 是否延伸到最下边
 */
-(void)addLeftLineWithStartY:(NSInteger)y withEnd:(bool)bEnd {
    @autoreleasepool {
        if ([self viewWithTag:0xff0c]) {
            
        }
        else{
            
            NSInteger h = self.height - (bEnd ? 1: 2) * y;
            
            __autoreleasing UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, y, 0.55, h)];
            v.backgroundColor = [UIColor hySeparatorColor];
            [self addSubview:v];
            v.tag = 0xff0c;
        }
    }
}


/**
 添加右边分割线

 @param y 起始点y坐标
 @param bEnd 是否延伸到最下边
 */
-(void)addRightLineWithStartY:(NSInteger)y withEnd:(bool)bEnd {
    @autoreleasepool {
        if ([self viewWithTag:0xff0d]) {
            
        }
        else {
            
            NSInteger h = self.height - (bEnd ? 1 : 2) * y;
            
            __autoreleasing UIView *v = [[UIView alloc] initWithFrame:CGRectMake(self.width-0.55, y, 0.55, h)];
            v.backgroundColor = [UIColor hySeparatorColor];
            [self addSubview:v];
            v.tag = 0xff0d;
        }
    }
}

@end
