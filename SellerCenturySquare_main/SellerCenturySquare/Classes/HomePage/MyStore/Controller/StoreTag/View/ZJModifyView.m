//
//  ZJModifyView.m
//  SellerCenturySquare
//
//  Created by 张晓旭 on 16/2/29.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "ZJModifyView.h"
#import "UIColor+UIColor.h"

@interface ZJModifyView ()
@property (nonatomic ,strong)NSArray *titleArr;
@end

@implementation ZJModifyView


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
    UILabel *genreLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 100, 11)];
    genreLabel.text = @"风格";
    genreLabel.textColor = [UIColor colorWithHexValue:0x000000 alpha:1];
    genreLabel.font = [UIFont systemFontOfSize:13];
    [self addSubview:genreLabel];
    
    float width = 85;
    float interval = 15;
    float height = 60;
    for (int i = 0 ;i <_titleArr.count; i++) {
        StyleButton  *typeBall = [[StyleButton alloc]initWithFrame:CGRectMake(i %4 * width + interval, i/4*height + genreLabel.frame.size.height + 5, 75, 30)  andTitle:_titleArr[i]];
        typeBall.layer.cornerRadius = 4;
        typeBall.layer.masksToBounds = YES;
        typeBall.layer.borderColor = [UIColor blackColor].CGColor;
        typeBall.tag = 10000+i;
        [typeBall addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:typeBall];
    }
}

- (void)clickBtn:(StyleButton *)btn
{
    [self.delegate ModifyClickBtn:btn];
}




@end
