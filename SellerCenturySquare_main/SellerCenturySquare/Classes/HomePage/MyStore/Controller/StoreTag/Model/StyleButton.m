//
//  StyleButton.m
//  SellerCenturySquare
//
//  Created by 张晓旭 on 16/2/29.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "StyleButton.h"
#import "UIColor+UIColor.h"

@interface StyleButton ()

@end


@implementation StyleButton

-(instancetype)initWithFrame:(CGRect)frame andTitle:(NSString *)title
{
    if (self = [super initWithFrame:frame]) {
        
        self.label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.label.text = title;
        self.label.font = [UIFont systemFontOfSize:13];
        self.backgroundColor = [UIColor whiteColor];
        self.label.layer.cornerRadius = 4;
        self.label.layer.masksToBounds = YES;
        self.label.layer.borderWidth = 1;
        self.label.layer.borderColor = [UIColor colorWithHexValue:0x999999 alpha:1].CGColor;
        self.label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.label];
        
    }
    return self;
}
- (void)setTypeColor:(UIColor *)typeColor
{
    [_label setTextColor:typeColor];
    
}
-(void)setBackColor:(UIColor *)backColor
{
    [self setBackgroundColor:backColor];
}




@end
