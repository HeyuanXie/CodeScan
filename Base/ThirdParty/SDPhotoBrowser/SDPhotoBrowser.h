//
//  SDPhotoBrowser.h
//  photobrowser
//
//  Created by aier on 15-2-3.
//  Copyright (c) 2015年 aier. All rights reserved.
//

#import <UIKit/UIKit.h>


@class SDButton, SDPhotoBrowser;

@protocol SDPhotoBrowserDelegate <NSObject>

@required

- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index;

@optional

- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index;

@end


@interface SDPhotoBrowser : UIView <UIScrollViewDelegate>


/**
 所有小图片的父视图(containerView)
 */
@property (nonatomic, weak) UIView *sourceImagesContainerView;

/**
 点击的小图的index
 */
@property (nonatomic, assign) NSInteger currentImageIndex;


/**
 点击的小图的image
 */
@property (nonatomic, strong) UIImage* currentImage;

/**
 photoBrower的图片数据源
 */
@property (nonatomic, strong) NSArray* images;

@property (nonatomic, weak) id<SDPhotoBrowserDelegate> delegate;


/**
 在UIWindow上加载photoBrower
 */
- (void)show;

@end
