//
//  HomeImageCell.h
//  Template
//
//  Created by admin on 2017/2/16.
//  Copyright © 2017年 hitao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeImageCell : UITableViewCell

@property(nonatomic,weak)IBOutlet UIView* topView;
@property(nonatomic,weak)IBOutlet UIView* botView;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *botSubViews;
@property(nonatomic,copy)void (^botSubviewClick)(NSInteger index);

+(NSString*)identify;

@end

