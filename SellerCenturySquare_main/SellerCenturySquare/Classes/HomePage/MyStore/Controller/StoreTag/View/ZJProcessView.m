//
//  ZJProcessView.m
//  SellerCenturySquare
//
//  Created by 张晓旭 on 16/2/29.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "ZJProcessView.h"
#import "UIColor+UIColor.h"
@interface ZJProcessView ()
@property (nonatomic ,strong)NSArray *titleArr;
@end

@implementation ZJProcessView
-(instancetype)initWithFrame:(CGRect)frame andWith:(NSArray *)titleArr
{
    self = [super initWithFrame:frame];
    if (self) {
        _titleArr = titleArr;
        [self autoLayout];
        
        
    }
    return self;
}

- (void)autoLayout
{
    
    //风格
    UILabel *artsLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 100, 11)];
    artsLabel.text = @"工艺";
    artsLabel.textColor = [UIColor colorWithHexValue:0x000000 alpha:1];
    artsLabel.font = [UIFont systemFontOfSize:13];
    [self addSubview:artsLabel];

    
    
    float width = 85;
    float interval = 15;
    float height = 60;
    for (int i = 0 ;i <_titleArr.count; i++) {
        
        ProcessButton  *typeBall = [[ProcessButton alloc]initWithFrame:CGRectMake(i %4 * width+interval ,i/4*height + artsLabel.frame.size.height + 5, 75, 30)  andTitle:_titleArr[i]];
        typeBall.tag = 1000+i;
        typeBall.layer.cornerRadius = 4;
        typeBall.layer.masksToBounds = YES;
        typeBall.layer.borderColor = [UIColor blackColor].CGColor;
        [typeBall addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:typeBall];
        
    }
}

- (void)clickBtn:(ProcessButton *)btn

{
    [self.delegate ProcessClickBtn:btn];
}



@end
