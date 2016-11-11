//
//  SaveInfoView.m
//  BuyerCenturySquare
//
//  Created by 张晓旭 on 15/11/12.
//  Copyright © 2015年 pactera. All rights reserved.
//

#import "SaveInfoView.h"
#import "UIColor+UIColor.h"

#define backGroundColor [UIColor colorWithHexValue:0x000000 alpha:1]  //背景色颜色
#define lineColor [UIColor colorWithHexValue:0xf3f3f3 alpha:1]  //点击后线条
#define fontColor [UIColor colorWithHexValue:0x007aff alpha:1]  //点击后线条

@implementation SaveInfoView

-(void)awakeFromNib
{
    self.lineLabel.backgroundColor = lineColor;
    self.lineSecondLabel.backgroundColor = lineColor;

    
    [self.loginButtton setTitleColor:fontColor forState:(UIControlStateNormal)];
    [self.forgetLoginPasswordButton setTitleColor:fontColor forState:(UIControlStateNormal)];
    [self.describeLabel setTextColor:fontColor];
    
    self.backgroundView.backgroundColor = backGroundColor;
}

- (IBAction)didClickLoginAction:(id)sender {

    if ([self.delegate respondsToSelector:@selector(didClickLoginAction)]) {
        [self.delegate performSelector:@selector(didClickLoginAction)];
    }
}

- (IBAction)didClickForgetPasswordButtonAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didClickForgetPasswordButtonAction)]) {
        [self.delegate performSelector:@selector(didClickForgetPasswordButtonAction)];
    }
}

@end
