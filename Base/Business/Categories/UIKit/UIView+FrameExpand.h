//
//  UIView+FrameExpand.h
//  Base
//
//  Created by admin on 17/1/16.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (FrameExpand)

- (void)addBottomLineWithStartX:(NSInteger)x withEnd:(bool)bEnd; //从x位置开始添加一根下划线
- (void)addTopLineWithStartX:(NSInteger)x withEnd:(bool)bEnd;    //从x位置开始添加一根上引线
- (void)addLeftLineWithStartY:(NSInteger)y withEnd:(bool)bEnd;   //从y位置开始添加一根左边线
- (void)addRightLineWithStartY:(NSInteger)y withEnd:(bool)bEnd;  //从y位置开始添加一根右边线

- (void)addDottedLineWithEdge:(UIEdgeInsets)edge;

- (UIView *)obtainBottomLine; //获取下划线
- (UIView *)obtainTopLine;    //获取上引线
- (UIView *)obtainLeftLine;   //获取左边线
- (UIView *)obtainRightLine;  //获取右边线

@end
