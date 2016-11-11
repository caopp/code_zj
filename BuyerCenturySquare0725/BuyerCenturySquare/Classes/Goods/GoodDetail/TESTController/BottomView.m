//
//  BottomView.m
//  BuyerCenturySquare
//
//  Created by zuojianshijue on 16/1/7.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "BottomView.h"

@implementation BottomView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithHexValue:0xf0f0f0 alpha:1];
        _button = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width - SCREEN_WIDTH/4, 0, SCREEN_WIDTH/4, frame.size.height)];
        [self addSubview:_button];
        [_button setTitle:@"询单结算" forState:UIControlStateNormal];

        _button.backgroundColor = [UIColor blackColor];
        _button.titleLabel.font = [UIFont systemFontOfSize:16];
        [_button addTarget:_delegate action:@selector(settleButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        //_button.enabled = NO;
        
        _startNumL = [[UILabel alloc] initWithFrame:CGRectMake(95, 15, self.frame.size.width-SCREEN_WIDTH/4-90-20, 21)];
        _startNumL.font = [UIFont systemFontOfSize:12];// [UIFont systemFontOfSize:14];
        _startNumL.textAlignment = NSTextAlignmentRight;
        _startNumL.text = @"合计:";
        [self addSubview:_startNumL];
        
//        _lineView = [[UIView alloc] initWithFrame:CGRectMake(88, 19, 1, 12)];
//        _lineView.backgroundColor = [UIColor blackColor];
//        [self addSubview:_lineView];
        
        _hasSelectedNumL = [[UILabel alloc] initWithFrame:CGRectMake(65, 15, self.frame.size.width-90-50, 21)];
        _hasSelectedNumL.text = @"共0件";
        _hasSelectedNumL.font = [UIFont systemFontOfSize:14];//[UIFont systemFontOfSize:14];
        [self addSubview:_hasSelectedNumL];
        
        UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0,Main_Screen_Width, 0.5)];
        topLine.backgroundColor = [UIColor colorWithHexValue:0xc8c7cc alpha:1];
        [self addSubview:topLine];
    
        
        _btnShop = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        [_btnShop addTarget:_delegate action:@selector(showCarList) forControlEvents:UIControlEventTouchUpInside];

        [_btnShop setImage:[UIImage imageNamed:@"navShopCar"] forState:UIControlStateNormal];
        [_btnShop setTitle:@"采购车" forState:UIControlStateNormal];
        [_btnShop setTitleColor:[UIColor colorWithHexValue:0x999999 alpha:1] forState:UIControlStateNormal];
        _btnShop.titleLabel.font = [UIFont systemFontOfSize:10];
        _btnShop.imageEdgeInsets = UIEdgeInsetsMake(-8,2,0,0);//设置image在button上的位置（上top，左left，下bottom，右right）这里可以写负值，对上写－5，那么image就象上移动5个像素
        _btnShop.titleEdgeInsets = UIEdgeInsetsMake(27,-25, 0, 0);//设置title在button上的位置（上top，左left，下bottom，右right）
        
        //    [button setContentEdgeInsets:UIEdgeInsetsMake(70, 0, 0, 0)];//
        
        
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
@end
