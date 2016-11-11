//
//  DetailXibView.m
//  SellerCenturySquare
//
//  Created by 张晓旭 on 16/7/15.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "DetailXibView.h"

@implementation DetailXibView
-(void)awakeFromNib
{
    [self.setLabel setTextColor:[UIColor colorWithHex:0x999999 alpha:1]];
    self.lineView.backgroundColor = [UIColor colorWithHex:0xc8c7cc alpha:1];
    [self.setOkLabel setTextColor:[UIColor colorWithHex:0x999999 alpha:1]];
}

- (IBAction)didClickEyeButtonAction:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(setEyeButtonAction:)]) {
        
        [self.delegate  setEyeButtonAction:self.eyeButton];
    }
    
}
@end
