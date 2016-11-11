//
//  RegisteredView.m
//  BuyerCenturySquare
//
//  Created by 张晓旭 on 15/12/21.
//  Copyright © 2015年 pactera. All rights reserved.
//

#import "RegisteredView.h"
#import "UIColor+UIColor.h"
#define backGroundColor [UIColor colorWithHexValue:0x000000 alpha:1]  //背景色颜色
#define lineColor [UIColor colorWithHexValue:0xf3f3f3 alpha:1]  //点击后线条
#define fontColor [UIColor colorWithHexValue:0xffffff alpha:1]  //点击后线条
@implementation RegisteredView





- (IBAction)goonRegsteredAction:(id)sender {
  
    if ([self.delegate respondsToSelector:@selector(goOnCompleteRegisteredAction)]) {
        [self.delegate performSelector:@selector(goOnCompleteRegisteredAction)];
    }
    
}

-(void)awakeFromNib
{
    [self.goOnRegisteredButton setTitleColor:fontColor forState:(UIControlStateNormal)];
    [self.registeredSuccessLabel setTintColor:fontColor];
    
    self.goOnRegisteredButton.layer.borderColor = fontColor.CGColor;
}

@end
