//
//  CustomTextShopView.m
//  BuyerCenturySquare
//
//  Created by caopenpen on 16/5/16.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "CustomTextShopView.h"

@implementation CustomTextShopView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.view.alpha = 1;
    self.view.backgroundColor = LineColor;
}
- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return CGRectInset( bounds, 0 , 0 );
}


-(CGRect)textRectForBounds:(CGRect)bounds
{
    return CGRectInset( bounds, 0 , 0 );
}

-(CGRect)placeholderRectForBounds:(CGRect)bounds
{
    CGRect inset = CGRectMake(bounds.origin.x+0, bounds.origin.y+8.5, bounds.size.width, bounds.size.height);//更好理解些
    
    return inset;
}




- (void)drawPlaceholderInRect:(CGRect)rect
{
    [[self placeholder] drawInRect:rect withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:PlaceholderTitleColor}];
}

@end
