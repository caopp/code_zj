//
//  OrderImgView.m
//  BuyerCenturySquare
//
//  Created by caopenpen on 16/3/24.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "OrderImgView.h"
#import "UIColor+UIColor.h"
@implementation OrderImgView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)awakeFromNib{
    _imagePic = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [self addSubview:_imagePic];
    
    _priceLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 65, 75, 12)];
    _priceLab.text = @"￥11111888";
    
    _priceLab.font = [UIFont systemFontOfSize:13.0];
    _priceLab.textColor = [UIColor colorWithHexValue:0x666666 alpha:1];
    [self addSubview:_priceLab];
    
    
    
    _goodsCount = [[UILabel alloc] initWithFrame:CGRectMake(0, 77, 75, 12)];
    _goodsCount.font = [UIFont systemFontOfSize:13.0];
    _goodsCount.textColor = [UIColor colorWithHexValue:0x666666 alpha:1];
    _goodsCount.text = @"× 222";
    [self addSubview:_goodsCount];
}
-(id)init{
    self = [super init];
    if (self) {
        
        [self awakeFromNib];
        
    }
    return self;
}
@end
