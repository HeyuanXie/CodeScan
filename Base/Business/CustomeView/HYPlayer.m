//
//  HYPlayer.m
//  Base
//
//  Created by admin on 2017/5/3.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "HYPlayer.h"
#import <AVFoundation/AVFoundation.h>

@interface HYPlayer ()

@property(nonatomic,strong)NSURL* url;

@end

@implementation HYPlayer

-(HYPlayer *)initWithUrlStr:(NSString *)urlStr {
    if (self = [super init]) {
        self.url = [NSURL URLWithString:urlStr];
        self.autoPlay = YES;
    }
    return self;
}

-(HYPlayer *)initWithName:(NSString *)fileName type:(NSString *)fileType {
    if (self = [super init]) {
        self.url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:fileName ofType:fileType]];
        self.autoPlay = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setPlayer];
}


#pragma mark - private methods
- (void)setPlayer {
    
    AVPlayerItem* playItem = [AVPlayerItem playerItemWithURL:self.url];
    self.player = [AVPlayer playerWithPlayerItem:playItem];
    if (self.autoPlay) {
        [self.player play];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
