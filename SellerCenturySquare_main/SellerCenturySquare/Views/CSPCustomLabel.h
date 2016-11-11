//
//  CSPCustomLabel.h
//  SellerCenturySquare
//
//  Created by clz on 15/8/24.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    VerticalAlignmentTop = 0, // default
    VerticalAlignmentMiddle,
    VerticalAlignmentBottom,
} VerticalAlignment;

@interface CSPCustomLabel : UILabel
@property(assign,nonatomic)VerticalAlignment verticalAlignment;

@end
