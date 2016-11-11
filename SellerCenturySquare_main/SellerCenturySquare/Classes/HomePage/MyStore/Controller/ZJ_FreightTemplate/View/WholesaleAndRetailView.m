//
//  WholesaleAndRetailView.m
//  SellerCenturySquare
//
//  Created by 张晓旭 on 16/6/17.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "WholesaleAndRetailView.h"
#import "UIColor+UIColor.h"
@implementation WholesaleAndRetailView
-(void)awakeFromNib
{
    //不选择包邮
    [self.selectedUnPackage setTextColor:[UIColor colorWithHexValue:0x666666 alpha:1]];
     //选择包邮
    [self.unselectedPackage setTextColor:[UIColor colorWithHexValue:0x666666 alpha:1]];
}
@end
