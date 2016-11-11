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
        [self awakeFromNib];
    }
    return self;
}

- (void)awakeFromNib
{
    self.layer.cornerRadius = 3.0f;
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    self.layer.borderWidth = 1;
    self.alpha = 0.7f;

}

@end
