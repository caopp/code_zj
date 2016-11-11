//
//  ProcessButton.m
//  SellerCenturySquare
//
//  Created by 张晓旭 on 16/2/29.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "ProcessButton.h"
#import "UIColor+UIColor.h"

@interface ProcessButton ()
{
    UILabel *label;
}
@end
@implementation ProcessButton

-(instancetype)initWithFrame:(CGRect)frame andTitle:(NSString *)title
{
    if (self = [super initWithFrame:frame]) {
        label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        label.text = title;
        label.font = [UIFont systemFontOfSize:13];        self.backgroundColor = [UIColor whiteColor];
        label.layer.cornerRadius = 4;
        label.layer.masksToBounds = YES;
        label.layer.borderWidth = 1;
        label.layer.borderColor = [UIColor colorWithHexValue:0x999999 alpha:1].CGColor;
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
    }
    return self;
}
- (void)setTypeColor:(UIColor *)typeColor
{
    [label setTextColor:typeColor];
    
}
-(void)setBackColor:(UIColor *)backColor
{
    [self setBackgroundColor:backColor];
    
}

@end
