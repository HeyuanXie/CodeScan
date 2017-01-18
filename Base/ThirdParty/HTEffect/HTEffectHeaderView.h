//
//  HTEffectHeaderView.h
//  StretchyHeaders
//
//  Created by gt4 on 15/8/18.
//  Copyright (c) 2015年 gt4. All rights reserved.
//

#import <UIKit/UIKit.h>
extern CGFloat GTEffectPullToRefreshViewHeight;

typedef NS_ENUM(NSInteger, GTEffectPullToRefreshState) {
    GTEffectPullToRefreshStatePulling,
    GTEffectPullToRefreshStateLoading,
    GTEffectPullToRefreshStateCompleted
};

@interface HTEffectHeaderView : UIView

@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic) UIImage * headerImage;
@property (nonatomic, assign) GTEffectPullToRefreshState state;
@property (nonatomic, assign) BOOL triggered;
@property (nonatomic, copy) void (^pullToRefreshActionBlock)();


- (void)endLoading;

- (void)triggerRefresh;

- (void)registerForKVO;

- (void)unregisterFromKVO;

@end
