//
//  CustomTextApplyField.m
//  BuyerCenturySquare
//
//  Created by caopenpen on 16/5/11.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "CustomTextApplyField.h"

@implementation CustomTextApplyField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)awakeFromNib{
    [super awakeFromNib];
    self.alpha = 1;
    self.view.alpha = 1;
    self.view.backgroundColor = LineColor;
}

- (void)changeTextLineAlpha:(CGFloat)alpha
{
    self.view.alpha = 1;
}

- (CGRect)editingRectForBounds:(CGRect)bounds{
    CGRect inset = CGRectMake(bounds.origin.x+15, bounds.origin.y-5, bounds.size.width, bounds.size.height);
    return inset;
}

- (CGRect)rightViewRectForBounds:(CGRect)bounds{
    CGRect inset = CGRectMake(bounds.size.width -30, bounds.origin.y+10, 15,15);
    return inset;
}
    
    
-(CGRect)textRectForBounds:(CGRect)bounds
{
     CGRect inset = CGRectMake(bounds.origin.x+15, bounds.origin.y-5, bounds.size.width, bounds.size.height);
    return inset;
}
-(CGRect)placeholderRectForBounds:(CGRect)bounds
{
    
    //return CGRectInset(bounds, 20, 0);
    CGRect inset = CGRectMake(bounds.origin.x+15, bounds.origin.y+10, bounds.size.width, bounds.size.height);//更好理解些
    return inset;
}
- (void)drawPlaceholderInRect:(CGRect)rect
{
    [[self placeholder] drawInRect:rect withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:PlaceholderTitleColor}];
}

@end
