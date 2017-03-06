//
//  UIImage+Extension.h
//  test
//
//  Created by admin on 16/9/30.
//  Copyright © 2016年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)

-(UIImage*)colorImageWithColor:(UIColor*)color;

-(UIImage*)colorImageWithColor:(UIColor*)color andSize:(CGSize)size;

-(UIImage*)imageWithColor:(UIColor*)color andSize:(CGSize)size;

-(UIImage*)imageWithSimpleImage:(CGSize)size;

@end
