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
        
        [self.layer setBorderColor:[UIColor colorWithHexValue:0x999999 alpha:1].CGColor];
        [self.layer setBorderWidth:1.0f];
        
        CGFloat btnWidth = (self.frame.size.width-50) /2;
        
        UIButton * btn_modity = [[UIButton alloc] initWithFrame:CGRectMake(50, 0, btnWidth, self.frame.size.height)];
        [btn_modity setTitle:@"修改订购量" forState:UIControlStateNormal];
        [btn_modity setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn_modity.titleLabel setFont:[UIFont fontWithName:nil size:13.0f]];
        [btn_modity setTag:1000];
        
        [btn_modity addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn_modity];
        
        UILabel * lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(btnWidth+50, 0, 1, self.frame.size.height)];
        [lineLabel setBackgroundColor:[UIColor colorWithHexValue:0x999999 alpha:1]];
        [self addSubview:lineLabel];
        
        UIButton * btn_add = [[UIButton alloc] initWithFrame:CGRectMake(btnWidth+50, 0, btnWidth, self.frame.size.height)];
        [btn_add setTitle:@"加入采购车" forState:UIControlStateNormal];
        [btn_add setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn_add.backgroundColor = [UIColor blackColor];
        [btn_add.titleLabel setFont:[UIFont fontWithName:nil size:13.0f]];
        [btn_add setTag:1001];
        [btn_add addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn_add];
        
//        UIButton * btn_settlement = [[UIButton alloc] initWithFrame:CGRectMake(btnWidth * 2, 0, btnWidth, self.frame.size.height)];
//        [btn_settlement setTitle:@"去结算" forState:UIControlStateNormal];
//        [btn_settlement setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [btn_settlement setBackgroundColor:[UIColor blackColor]];
//        [btn_settlement.titleLabel setFont:[UIFont fontWithName:nil size:13.0f]];
//        [btn_settlement setTag:1002];
//        [btn_settlement addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:btn_settlement];

        UIButton *_btnShop = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        [_btnShop addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [_btnShop setImage:[UIImage imageNamed:@"navShopCar"] forState:UIControlStateNormal];
        [_btnShop setTitle:@"采购车" forState:UIControlStateNormal];
        [_btnShop setTitleColor:[UIColor colorWithHexValue:0x999999 alpha:1] forState:UIControlStateNormal];
        _btnShop.titleLabel.font = [UIFont systemFontOfSize:10];
        _btnShop.imageEdgeInsets = UIEdgeInsetsMake(-8,2,0,0);//设置image在button上的位置（上top，左left，下bottom，右right）这里可以写负值，对上写－5，那么image就象上移动5个像素
        _btnShop.titleEdgeInsets = UIEdgeInsetsMake(27,-25, 0, 0);//设置title在button上的位置（上top，左left，下bottom，右right）
        
        //    [button setContentEdgeInsets:UIEdgeInsetsMake(70, 0, 0, 0)];//
        
        _btnShop.tag = 1003;
        _btnShop.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//设置button的内容横向居中。。设置content是title和image一起变化
        
        _shopPoint = [[UIView alloc] initWithFrame:CGRectMake(40, 5, 7, 7)];
        _shopPoint.backgroundColor = [UIColor redColor];
        [_btnShop addSubview:_shopPoint];
        _shopPoint.layer.cornerRadius = 3.5f;
        _shopPoint.layer.masksToBounds = YES;
        [self addSubview:_btnShop];
        
        
        UIView *viewLine = [[UIView alloc] initWithFrame:CGRectMake(50, 0, 0.5, 50)];
        viewLine.backgroundColor = [UIColor colorWithHexValue:0x999999 alpha:1];
        [self addSubview:viewLine];
        

    }
    
    return self;
}

- (void)btnClick:(UIButton *)sender {
    
    if (sender.tag == 1000) {
        [self.delegate UUBtnViewBtnClick:self btnIndex:0];
    }else if (sender.tag == 1001) {
        [self.delegate UUBtnViewBtnClick:self btnIndex:1];
    }else if (sender.tag == 1002) {
        [self.delegate UUBtnViewBtnClick:self btnIndex:3];
    }else if (sender.tag == 1003) {
        [self.delegate UUBtnViewBtnClick:self btnIndex:4];
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
