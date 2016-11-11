//
//  CourierView.m
//  SellerCenturySquare
//
//  Created by 张晓旭 on 16/3/26.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "CourierView.h"
#import "UIColor+UIColor.h"

@implementation CourierView

-(void)awakeFromNib
{
    self.backgroundColor = [UIColor colorWithHexValue:0xefeff4 alpha:1];
    
    [self.companyLabel setTextColor:[UIColor colorWithHexValue:0x666666 alpha:1]];
    [self.courierName setTextColor:[UIColor colorWithHexValue:0x000000 alpha:1]];
    [self.courierNum setTextColor:[UIColor colorWithHexValue:0x666666 alpha:1]];
    [self.courierCompanyNum setTextColor:[UIColor colorWithHexValue:0x000000 alpha:1]];
    [self.sendPeopleLabel setTextColor:[UIColor colorWithHexValue:0x666666 alpha:1]];
    [self.sendNameLabel setTextColor:[UIColor colorWithHexValue:0x000000 alpha:1]];
    [self.phoneLabel setTextColor:[UIColor colorWithHexValue:0x666666 alpha:1]];
    [self.phoneNumLabel setTextColor:[UIColor colorWithHexValue:0x000000 alpha:1]];
    self.phoneNumLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didClickPhoneAction)];
    [self.phoneNumLabel addGestureRecognizer:tap];
}

-(void)didClickPhoneAction
{
    
    if ([self.delegate respondsToSelector:@selector(didClickAction)]) {
        
        [self.delegate performSelector:@selector(didClickAction)];
    }
    
}


@end
