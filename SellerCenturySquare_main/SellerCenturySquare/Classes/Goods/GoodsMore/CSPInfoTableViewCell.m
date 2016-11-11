//
//  CSPInfoTableViewCell.m
//  CustomerCenturySquare
//
//  Created by caopenpen on 16/6/20.
//  Copyright © 2016年 zuojian. All rights reserved.
//

#import "CSPInfoTableViewCell.h"

@implementation CSPInfoTableViewCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)loadDTO:(GoodsMoreDTO *)dto{
    _priceLabel.text = [NSString stringWithFormat:@"￥%@",dto.retailPrice?dto.retailPrice:@"0"];
    _nameLabel.text = dto.goodsName;
}
@end
