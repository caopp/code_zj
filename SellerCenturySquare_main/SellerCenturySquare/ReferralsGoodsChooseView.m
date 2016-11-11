//
//  ReferralsGoodsChooseView.m
//  SellerCenturySquare
//
//  Created by 王剑粟 on 15/9/21.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "ReferralsGoodsChooseView.h"
#import "ACMacros.h"

@implementation ReferralsGoodsChooseView

- (instancetype)initWithBlock:(ReferralsGoodsChooseViewClick)block withIndex:(NSInteger)index withxOffsent:(float)x {
    
    NSInteger pageNo = index / 8;
    NSInteger pageLocation = index % 8;
    
    CGRect frame = CGRectMake(Main_Screen_Width * pageNo + 15 + (pageLocation % 4) * (x + GoodsChooseViewWidth), 12 + (pageLocation / 4) * (12 + GoodsChooseViewHeight), GoodsChooseViewWidth, GoodsChooseViewHeight);
    self = [super initWithFrame:frame];
    if (self) {
        
        goodsIndex = index;
        clickBlock = block;
        isSelected = NO;
        
        _picImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, GoodsChooseViewWidth, 60)];
        _picImageView.layer.borderColor = [UIColor blackColor].CGColor;
        [self addSubview:_picImageView];
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, GoodsChooseViewWidth, 15)];
        [_priceLabel setFont:[UIFont fontWithName:nil size:13.0f]];
        [self addSubview:_priceLabel];
        _checkImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 11, 11)];
        [_checkImageView setImage:[UIImage imageNamed:@"点击效果图示"]];
        _checkImageView.hidden = YES;
        [self addSubview:_checkImageView];
        
        
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewClick:)]];
    }
    
    return self;
}

- (void)viewClick:(UITapGestureRecognizer *)sender {
    
    isSelected = !isSelected;
    
    if (clickBlock) {
        [self viewChange];
        clickBlock(isSelected, goodsIndex);
    }
    
}

//样式改变函数
- (void)viewChange {
    
    if (isSelected) {
        
        _picImageView.layer.borderWidth = 1.0f;
        _checkImageView.hidden = NO;
        [_priceLabel setBackgroundColor:[UIColor blackColor]];
        [_priceLabel setTextColor:[UIColor whiteColor]];
    }else {
        
        _picImageView.layer.borderWidth = 0.0f;
        _checkImageView.hidden = YES;
        [_priceLabel setBackgroundColor:[UIColor clearColor]];
        [_priceLabel setTextColor:[UIColor blackColor]];
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
