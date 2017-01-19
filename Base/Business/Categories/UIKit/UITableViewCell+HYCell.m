//
//  UITableViewCell+HYCell.m
//  Base
//
//  Created by admin on 2017/1/18.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "UITableViewCell+HYCell.h"

@implementation UITableViewCell (HYCell)
-(void)addLine {
    [self addLine:false leftOffSet:0 rightOffSet:0];
}

-(void)addLine:(BOOL)hidden leftOffSet:(CGFloat)left rightOffSet:(CGFloat)right {
    UIView* customLine = [self viewWithTag:100011];
    if (customLine == nil) {
        UIView* line = [HYTool getLineWithFrame:CGRectZero lineColor:nil];
        line.tag = 100011;
        [self.contentView addSubview:line];
        [line autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:-0.5];
        [line autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:left];
        [line autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:-right];
        [line autoSetDimension:ALDimensionHeight toSize:0.5];
        customLine = line;
    }
    customLine.hidden = hidden;
}

@end
