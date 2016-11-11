//
//  ChooseView.m
//  SellerCenturySquare
//
//  Created by clz on 15/8/4.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "ChooseView.h"
static const CGFloat alpha = 0.7;
@implementation ChooseView

- (void)awakeFromNib{
    
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor clearColor];
    
    self.leftLineView.alpha = alpha;
    
    self.rightLineView.alpha = alpha;
    
    self.bottomLineView.alpha = alpha;
    
    self.phoneNumLabel.alpha = alpha;
    
    self.phoneNumLabel.font = [UIFont systemFontOfSize:13];
}

@end
