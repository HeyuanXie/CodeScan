//
//  UIScrollView+EffectHeaderView.h
//  StretchyHeaders
//
//  Created by gt on 15/9/14.
//  Copyright (c) 2015年 gt4. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTEffectHeaderView.h"

@interface UIScrollView (EffectHeaderView)

@property (nonatomic, strong) HTEffectHeaderView *effectHeaderView;

/**
 *  增加可拉伸顶部
 *
 *  @param image 背景图
 *  @param frame 创建的时候必须指定大小
 *  @param suspansionView   悬浮条 会添加到scrollview.supview上，请在该方法之后设置autolayout,生命周期受 HTEffectHeaderView控制
 *
 *  @return 
 */
- (HTEffectHeaderView *)addEffectHeaderView:(UIImage *)image frame:(CGRect)frame Action:(void(^)(void))block;

/**
 * 需在viewController的dealloc中调用
 */
- (void)removeEffectKVO;
/**
 *  加载完成，恢复回调
 */
- (void)didFinishEffectPullToRefresh;

@end
