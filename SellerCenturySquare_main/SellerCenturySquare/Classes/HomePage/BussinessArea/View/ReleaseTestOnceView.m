//
//  ReleaseTestOnceView.m
//  SellerCenturySquare
//
//  Created by 陈光 on 16/5/17.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "ReleaseTestOnceView.h"

@implementation ReleaseTestOnceView
- (void)awakeFromNib
{
    self.promptTitleLab.text = @"发测评：采购商可对服装样板进行喜欢与不喜欢评价";
}
- (IBAction)selectSureBtn:(id)sender {
    if (self.blockTest) {
        self.blockTest(self);
        
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
