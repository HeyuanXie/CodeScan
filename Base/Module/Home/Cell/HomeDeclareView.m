//
//  HomeDeclareView.m
//  Base
//
//  Created by admin on 2017/1/22.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "HomeDeclareView.h"
#import "ZMDArticle.h"

@implementation HomeDeclareView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+(NSString *)identify {
    return NSStringFromClass([self class]);
}

-(void)configWithArray:(NSArray*)array andIndex:(int)index {
    int pages = (int)array.count/4;
    int remainder = (int)array.count%4;
    if (index < pages-1) {
        //config满载declareView
        for (int j=0; j<4; j++) {
            ZMDArticle* policy = array[index*4+j];
            UIView* miniView = [self viewWithTag:10000+j];
            UILabel* titleLbl = [miniView viewWithTag:100];
            UIImageView* imgV = [ miniView viewWithTag:101];
            UIButton* btn = [miniView viewWithTag:102];
            
            titleLbl.text = policy.title;
            imgV.image = [UIImage imageNamed:policy.thumb];
            btn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
                NSLog(@"%ld",btn.tag-100);
                return [RACSignal empty];
            }];
        }
    }else{
        //config非满载declareView
        for (int j=0; j<remainder; j++) {
            ZMDArticle* policy = array[j];
            UIView* miniView = [self viewWithTag:10000+j];
            UILabel* titleLbl = [miniView viewWithTag:100];
            UIImageView* imgV = [ miniView viewWithTag:101];
            UIButton* btn = [miniView viewWithTag:102];
            
            titleLbl.text = policy.title;
            imgV.image = [UIImage imageNamed:policy.thumb];
            btn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
                NSLog(@"%ld",btn.tag-100);
                return [RACSignal empty];
            }];
        }
    }
}


@end
