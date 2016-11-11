//
//  InviteLevelButton.m
//  SellerCenturySquare
//
//  Created by 李春晓 on 15/9/11.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "InviteLevelButton.h"

@implementation InviteLevelButton

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (void)drawRect:(CGRect)rect {
    // Drawing code
    [self.layer setMasksToBounds:YES];
    [self.layer setBorderColor:[UIColor blackColor].CGColor];
    [self.layer setBorderWidth:1];
    
}

- (void)setSelected:(BOOL)selected{
    
    if (selected) {
        
        [self setBackgroundColor:[UIColor blackColor]];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        
    }else{
        
        [self setBackgroundColor:[UIColor whiteColor]];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        
    }
}


@end
