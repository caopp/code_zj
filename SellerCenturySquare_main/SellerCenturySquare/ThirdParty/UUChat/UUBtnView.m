//
//  UUBtnView.m
//  BuyerCenturySquare
//
//  Created by 王剑粟 on 15/8/26.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "UUBtnView.h"
#import "ACMacros.h"

@implementation UUBtnView

- (id)initWithFrame:(CGRect)frame {
    
    CGRect newframe = CGRectMake(0, Main_Screen_Height - 100 - 64, Main_Screen_Width, 50);
    self = [super initWithFrame:newframe];
    if (self) {
        
        //设置边框
        [self.layer setBorderColor:[UIColor blackColor].CGColor];
        [self.layer setBorderWidth:1.0f];
        
        CGFloat btnWidth = self.frame.size.width / 3;
        
        UIButton * btn_modity = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, btnWidth, self.frame.size.height)];
        [btn_modity setTitle:@"修改采购单量" forState:UIControlStateNormal];
        [btn_modity setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn_modity.titleLabel setFont:[UIFont fontWithName:nil size:13.0f]];
        [btn_modity setTag:1000];
        [btn_modity addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn_modity];
        
        UILabel * lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(btnWidth, 0, 1, self.frame.size.height)];
        [lineLabel setBackgroundColor:[UIColor blackColor]];
        [self addSubview:lineLabel];
        
        UIButton * btn_add = [[UIButton alloc] initWithFrame:CGRectMake(btnWidth, 0, btnWidth, self.frame.size.height)];
        [btn_add setTitle:@"加入采购车" forState:UIControlStateNormal];
        [btn_add setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn_add.titleLabel setFont:[UIFont fontWithName:nil size:13.0f]];
        [btn_add setTag:1001];
        [btn_add addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn_add];
        
        UIButton * btn_settlement = [[UIButton alloc] initWithFrame:CGRectMake(btnWidth * 2, 0, btnWidth, self.frame.size.height)];
        [btn_settlement setTitle:@"去采购车结算" forState:UIControlStateNormal];
        [btn_settlement setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn_settlement setBackgroundColor:[UIColor blackColor]];
        [btn_settlement.titleLabel setFont:[UIFont fontWithName:nil size:13.0f]];
        [btn_settlement setTag:1002];
        [btn_settlement addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn_settlement];

    }
    
    return self;
}

- (void)btnClick:(UIButton *)sender {
    
    if (sender.tag == 1000) {
        [self.delegate UUBtnViewBtnClick:self btnIndex:0];
    }else if (sender.tag == 1001) {
        [self.delegate UUBtnViewBtnClick:self btnIndex:1];
    }else if (sender.tag == 1002) {
        [self.delegate UUBtnViewBtnClick:self btnIndex:2];
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
