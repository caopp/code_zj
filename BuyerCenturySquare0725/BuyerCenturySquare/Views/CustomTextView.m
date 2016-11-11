//
//  CustomTextView.m
//  BuyerCenturySquare
//
//  Created by 张晓旭 on 15/12/30.
//  Copyright © 2015年 pactera. All rights reserved.
//

#import "CustomTextView.h"

@implementation CustomTextView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      
    }
    return self;
}

- (CGRect)caretRectForPosition:(UITextPosition *)position{
    CGRect originalRect = [super caretRectForPosition:position];
   
    originalRect.size.height = self.font.lineHeight + 1;
    originalRect.size.width = 2;
    return originalRect;
}
- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return CGRectInset( bounds, 0 , 0 );
}


-(CGRect)textRectForBounds:(CGRect)bounds
{
    return CGRectInset( bounds, 0 , 0 );
}


@end
