//
//  ZJ_ManagerAddressView.m
//  BuyerCenturySquare
//
//  Created by 张晓旭 on 16/3/24.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "ZJ_ManagerAddressView.h"

#import "UIColor+UIColor.h"
@implementation ZJ_ManagerAddressView


- (IBAction)postionBtnAction:(id)sender {
    
    if ( [self.delegate respondsToSelector:@selector(postionBtnAction)]) {
        [self.delegate performSelector:@selector(postionBtnAction)];
    }
}

-(void)awakeFromNib
{
    
    //
    self.nameLabel.textColor = [UIColor colorWithHexValue:0x999999 alpha:1];
    //
    self.phoneLabel.textColor = [UIColor colorWithHexValue:0x999999 alpha:1];
    //
    self.cityLabel.textColor = [UIColor colorWithHexValue:0x999999 alpha:1];
    //
    self.addressLabel.textColor = [UIColor colorWithHexValue:0x999999 alpha:1];
    //
//    [self.addressTextView setTextColor:[UIColor colorWithHexValue:0x666666 alpha:1]];
    [self.ppositionButton setTitleColor:[UIColor colorWithHexValue:0x999999 alpha:1] forState:(UIControlStateNormal)];
    //
    self.firstLabel.backgroundColor = [UIColor colorWithHexValue:0xc8c7cc alpha:1];
    //
    self.secondLabel.backgroundColor = [UIColor colorWithHexValue:0xc8c7cc alpha:1];
    //
    self.thridLabel.backgroundColor = [UIColor colorWithHexValue:0xc8c7cc alpha:1];
    //
    self.fourLabel.backgroundColor = [UIColor colorWithHexValue:0xc8c7cc alpha:1];
    
    //
    self.roundLabel.layer.masksToBounds = YES;
    self.roundLabel.layer.cornerRadius = 4;
    self.roundLabel.layer.borderWidth = 1;
    
    self.roundLabel.backgroundColor = [UIColor clearColor];
    self.roundLabel.layer.borderColor = [UIColor colorWithHexValue:0xc8c7cc alpha:1].CGColor;

    //
    [self.nameTextField setTextColor:[UIColor colorWithHexValue:0x000000 alpha:1]];
    [self.phoneTextField setTextColor:[UIColor colorWithHexValue:0x000000 alpha:1]];
    [self.cityTextField setTextColor:[UIColor colorWithHexValue:0x000000 alpha:1]];
    [self.addressTextView setTextColor:[UIColor colorWithHexValue:0x000000 alpha:1]];

    
}




@end
