//
//  SkillDetailHeadView.h
//  Base
//
//  Created by admin on 2017/3/15.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SkillDetailHeadView : UIView

@property(nonatomic,copy)void (^searchFinish)(NSString* text);

-(void)configHeadView:(id)model;

@end
