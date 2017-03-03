//
//  HomeVideoView.h
//  Base
//
//  Created by admin on 2017/3/3.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeVideoView : UIView

@property(nonatomic,weak)IBOutlet UIImageView *imgV;
@property(nonatomic,weak)IBOutlet UILabel *durationLbl;
@property(nonatomic,weak)IBOutlet UIView *duartionView;

@property(nonatomic,weak)IBOutlet UILabel *titleLbl;
@property(nonatomic,weak)IBOutlet UILabel *timeLbl;

-(void)configVideoView:(id)model;

@end
