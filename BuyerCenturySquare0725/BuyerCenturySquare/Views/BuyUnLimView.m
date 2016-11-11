//
//  BuyUnLimView.m
//  BuyerCenturySquare
//
//  Created by caopenpen on 16/3/30.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "BuyUnLimView.h"

@implementation BuyUnLimView
- (IBAction)addCount:(id)sender {
    [self removeFromSuperview];
}
-(void)awakeFromNib{
    _alerView.layer.cornerRadius = 6.0f;
    _alerView.layer.masksToBounds = YES;
    _alerView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _alerView.layer.borderWidth = 1.0f;
    self.flowLayout.wrapContentHeight = YES;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
