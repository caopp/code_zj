//
//  CSPScrolSelectView.m
//  BuyerCenturySquare
//
//  Created by Edwin on 15/9/15.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "CSPScrolSelectView.h"

@implementation CSPScrolSelectView


- (IBAction)buttonClicked:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectButtonClicked:)]) {
        [self.delegate selectButtonClicked:sender];
    }
}
@end
