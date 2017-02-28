//
//  BlockView.h
//  Base
//
//  Created by admin on 2017/2/24.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BlockView : UIView

@property(nonatomic,assign)CGFloat from;
@property(nonatomic,assign)CGFloat to;

- (void)startAnimation;

- (void)completeAnimation;

@end
