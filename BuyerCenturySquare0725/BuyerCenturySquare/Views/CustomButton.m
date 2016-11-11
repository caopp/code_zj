//
//  CustomButton.m
//  Ziggo
//
//  Created by Edwin on 15-4-27.
//  Copyright (c) 2015年 PacteraGBG1. All rights reserved.
//

#import "CustomButton.h"

@implementation CustomButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _defaultBorderColor = [UIColor whiteColor];
        [self awakeFromNib];
       
        
    }
    return self;
}


- (void)awakeFromNib
{
    if (self.defaultBorderColor == nil) {
        self.defaultBorderColor = [UIColor whiteColor];
        self.layer.cornerRadius = 3.0f;
//        self.alpha = 0.7f;
        self.layer.borderWidth = 1.0f;
    }


}

- (void)setDefaultBorderColor:(UIColor *)defaultBorderColor {
    _defaultBorderColor = defaultBorderColor;
    self.layer.borderColor = defaultBorderColor.CGColor;
    self.layer.borderWidth = 0.5;
    self.layer.cornerRadius = 3.0f;
    self.layer.masksToBounds = YES;
    self.alpha = 1.0f;
}


@end
