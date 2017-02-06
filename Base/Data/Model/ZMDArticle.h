//
//  ZMDArticle.h
//  Base
//
//  Created by admin on 2017/1/21.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "BaseModel.h"

@interface ZMDArticle : BaseModel

PN(articleId);
PN(title);
PN(thumb);
PN(publishDate);
PN(detailUrl);
PN(summary);
PN(canShare);

@end

