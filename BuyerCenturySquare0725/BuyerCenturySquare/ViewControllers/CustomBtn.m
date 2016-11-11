//
//  CustomBtn.m
//  BuyerCenturySquare
//
//  Created by 陈光 on 16/1/12.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "CustomBtn.h"
#import "Masonry.h"

@interface CustomBtn ()

@end
@implementation CustomBtn
-  (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UIButton *iconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        iconBtn.userInteractionEnabled = NO;
        [iconBtn setImage:[UIImage imageNamed:@"topup_unsel"] forState:UIControlStateNormal];
        [iconBtn setImage:[UIImage imageNamed:@"topup_sel"] forState:UIControlStateSelected];
        [self addSubview:iconBtn];
        self.iconBtn = iconBtn;
        
        [iconBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.left.equalTo(self.mas_left);
            make.width.equalTo(@21);
        }];
        
        UIButton *levelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        levelBtn.userInteractionEnabled = NO;
        [levelBtn setBackgroundColor:[UIColor colorWithHexValue:0x999999 alpha:1]];
        [levelBtn setTitle:@"升级至V6" forState:UIControlStateNormal];
        levelBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        
        [self addSubview:levelBtn];
        self.levelBtn = levelBtn;
        
        [levelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(iconBtn.mas_right).offset(11);
            make.height.equalTo(@48);
            make.top.equalTo(self.mas_top);
            make.width.equalTo(@105);
        }];
        
    
        UIButton *topUpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        topUpBtn.userInteractionEnabled = NO;
    
        topUpBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        self.topUpBtn = topUpBtn;

        [topUpBtn setBackgroundImage:[UIImage imageNamed:@"amountTopupUnSel"] forState:UIControlStateNormal];
                [topUpBtn setBackgroundImage:[UIImage imageNamed:@"amountTopupSel"] forState:UIControlStateSelected];
        
        [topUpBtn setTitle:@"充值￥50000" forState:UIControlStateNormal];
        [topUpBtn setTitleColor:[UIColor colorWithHexValue:0xffffff alpha:1] forState:UIControlStateNormal];
        [self addSubview:topUpBtn];
        
        
        [topUpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(levelBtn.mas_top);
            make.left.equalTo(levelBtn.mas_right).offset(4);
//            make.width.equalTo(@165);
            make.right.equalTo(self.mas_right);
            
            make.height.equalTo(levelBtn.mas_height);
        }];
        
    }
    return self;
}


@end
