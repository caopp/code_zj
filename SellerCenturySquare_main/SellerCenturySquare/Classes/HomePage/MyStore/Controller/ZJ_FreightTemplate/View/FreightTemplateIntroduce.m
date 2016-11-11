//
//  FreightTemplateIntroduce.m
//  SellerCenturySquare
//
//  Created by 张晓旭 on 16/6/16.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "FreightTemplateIntroduce.h"
#import "UIColor+UIColor.h"

@implementation FreightTemplateIntroduce

-(void)awakeFromNib
{
    
    self.backgroundColor = [UIColor whiteColor];
    
    [self.usetTitle setTextColor:[UIColor colorWithHexValue:0x666666 alpha:1]];
    [self.setTitle setTextColor:[UIColor colorWithHexValue:0x666666 alpha:1]];
    [self.packageTitle setTextColor:[UIColor colorWithHexValue:0x666666 alpha:1]];
    
    [self.useLabel setTextColor:[UIColor colorWithHexValue:0x999999 alpha:1]];
    [self.setLabel1 setTextColor:[UIColor colorWithHexValue:0x999999 alpha:1]];
    [self.setLabel2 setTextColor:[UIColor colorWithHexValue:0x999999 alpha:1]];
    [self.packageLabel setTextColor:[UIColor colorWithHexValue:0x999999 alpha:1]];
    
}



@end
