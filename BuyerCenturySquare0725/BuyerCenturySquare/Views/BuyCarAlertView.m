//
//  BuyCarAlertView.m
//  BuyerCenturySquare
//
//  Created by zuojianshijue on 16/1/25.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "BuyCarAlertView.h"

@implementation BuyCarAlertView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)awakeFromNib{
    _alertView.layer.cornerRadius = 6.0f;
    _alertView.layer.masksToBounds = YES;
    _alertView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _alertView.layer.borderWidth = 1.0f;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleateView:)];
    [self addGestureRecognizer:tap];
    self.labelLayout.wrapContentHeight = YES;
}
- (IBAction)goBuy:(id)sender {
    [self.delegate  goBuy];
}
- (IBAction)goOrder:(id)sender {
    [self.delegate goOrder];
}
- (IBAction)deleateView:(id)sender {
    [self removeFromSuperview];
}

@end
