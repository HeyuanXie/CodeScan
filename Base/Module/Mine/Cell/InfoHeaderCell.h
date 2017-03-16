//
//  InfoHeaderCell.h
//  Template
//
//  Created by hitao on 16/10/4.
//  Copyright © 2016年 hitao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoHeaderCell : UITableViewCell
+ (CGFloat)height;
+ (NSString *)identify;

- (void)setHeaderImage:(UIImage *)image;
- (void)setHeaderUrlString:(NSString *)url;
@end
