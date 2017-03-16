//
//  SkillDetailHeadView.m
//  Base
//
//  Created by admin on 2017/3/15.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "SkillDetailHeadView.h"
#import "UIImage+HYImages.h"
@interface SkillDetailHeadView ()<UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *backImgV;
@property (weak, nonatomic) IBOutlet UIImageView *imgV;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *addressLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UILabel *statuLbl;

@property (weak, nonatomic) IBOutlet UILabel *personCountLbl;
@property (weak, nonatomic) IBOutlet UILabel *voteCountLbl;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (weak, nonatomic) IBOutlet UIView *descView;
@property (weak, nonatomic) IBOutlet UIView *ruleView;
@property (weak, nonatomic) IBOutlet UIView *awardView;

@end

@implementation SkillDetailHeadView

-(void)configHeadView:(id)model {
    //subviewStyle
    self.backgroundColor = [UIColor hyViewBackgroundColor];
    
    self.statuLbl.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    
    self.searchBar.backgroundColor = RGB(244, 244, 244, 1.0);
    [HYTool configViewLayer:self.searchBar withColor:[UIColor lightGrayColor]];
    UIView* view = self.searchBar.subviews.firstObject;
    for (id obj in view.subviews) {
        if ([obj isKindOfClass:[UIImageView class]]) {
            [((UIImageView*)obj) removeFromSuperview];
            
        }
    }
    [self.searchBar setSearchFieldBackgroundImage:[UIImage hyImageWithColor:RGB(244, 244, 244, 1.0) size:CGSizeMake(kScreen_Width-24, 45)] forState:UIControlStateNormal];
    
    
    //data
    
    
    //subviewBind
    [self.descView bk_whenTapped:^{
        
    }];
    [self.ruleView bk_whenTapped:^{
        
    }];
    [self.awardView bk_whenTapped:^{
        
    }];
}


#pragma mark - searchBar delegate
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    if (self.searchFinish) {
        self.searchFinish(searchBar.text);
    }
}


@end
