//
//  SearchDeriveCell.h
//  Base
//
//  Created by admin on 2017/3/23.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeriveModel.h"

@interface SearchDeriveCell : UITableViewCell

+(NSString*)identify;
-(void)configSearchDeriveCell:(DeriveModel*)model keyword:(NSString*)word;

@end
