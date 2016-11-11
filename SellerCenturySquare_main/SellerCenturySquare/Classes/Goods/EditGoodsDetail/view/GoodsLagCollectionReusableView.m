//
//  GoodsLagCollectionReusableView.m
//  SellerCenturySquare
//
//  Created by 陈光 on 16/3/14.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "GoodsLagCollectionReusableView.h"
#import "UIColor+HexColor.h"

@implementation GoodsLagCollectionReusableView

- (void)awakeFromNib {
    
    [self.goodsLagCollectionLabel setTextColor:[UIColor colorWithHex:0x000000 alpha:1]];

    self.goodsLagCollectionLabel.font =[UIFont systemFontOfSize:13];
    
}

@end
