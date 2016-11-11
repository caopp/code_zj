//
//  LoadFailedView.m
//  BuyerCenturySquare
//
//  Created by 陈光 on 16/4/29.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "LoadFailedView.h"

@interface LoadFailedView ()

@property (weak, nonatomic) IBOutlet UIButton *requestBtn;



@end

@implementation LoadFailedView


- (IBAction)selectRequestBtn:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(loadFailedAgainRequest)]) {
        [self.delegate loadFailedAgainRequest];
        
    }
}

- (void)awakeFromNib
{
    self.requestBtn.layer.borderWidth = 1;
    self.requestBtn.layer.borderColor = [UIColor blackColor].CGColor;
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

