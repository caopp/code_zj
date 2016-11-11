//
//  LoginLabel.m
//  SellerCenturySquare
//
//  Created by 张晓旭 on 15/11/10.
//  Copyright © 2015年 pactera. All rights reserved.
//

#import "LoginLabel.h"
#import "UIColor+UIColor.h"
#define LGClickColor [UIColor colorWithHexValue:0xffffff alpha:1]  //点击后线条

@interface LoginLabel ()
@property(strong,nonatomic)UILabel *label;
@end

@implementation LoginLabel

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 1)];
        [self addSubview:self.label];
    }
    return  self;
}

-(void)settingLoginLabelLine
{
   self.label.backgroundColor = LGClickColor;
}


@end
