//
//  InquireView.m
//  BuyerCenturySquare
//
//  Created by caopenpen on 16/3/31.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "InquireView.h"

@implementation InquireView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)awakeFromNib{
    //self.flowLayout.wrapContentHeight = YES;
}
- (IBAction)deleateView:(id)sender {
    [self removeFromSuperview];
}

@end
