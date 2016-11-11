//
//  ReferralsGoodsView.m
//  SellerCenturySquare
//
//  Created by 王剑粟 on 15/9/21.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#define yOffsent 17

#import "ReferralsGoodsView.h"
#import "ACMacros.h"
#import "ReferralsGoodsChooseView.h"

@implementation ReferralsGoodsView

- (instancetype)initWithDic:(GetShopGoodsListDTO *)goodDic {
    
    CGRect frame = CGRectMake(0, 0, Main_Screen_Width, 240);
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setBackgroundColor:[UIColor whiteColor]];
        selectedGoodsArray = [[NSMutableArray alloc] init];
        _getShopGoodsListDTO = goodDic;
        NSInteger total = _getShopGoodsListDTO.ShopGoodsDTOList.count;
        pageNum =  total / 8;
        if (total % 8 > 0) {
            pageNum ++;
        }
        currentPage = 0;
        
        xOffsent = (Main_Screen_Width - 278) / 3;
        
        [self drawView];
    }
    
    return self;
}

- (void) drawView {
    
    //初始化UIScrollView
    pageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 180)];
    [pageScrollView setContentSize:CGSizeMake(Main_Screen_Width * pageNum, 180)];
    pageScrollView.showsHorizontalScrollIndicator = NO;
    pageScrollView.pagingEnabled = YES;
    pageScrollView.delegate = self;
    
    for (int i = 0; i < _getShopGoodsListDTO.ShopGoodsDTOList.count; i++){
        
        ShopGoodsDTO * dto = (ShopGoodsDTO *)[_getShopGoodsListDTO.ShopGoodsDTOList objectAtIndex:i];
        
        //画商品
        ReferralsGoodsChooseView * chooseView = [[ReferralsGoodsChooseView alloc] initWithBlock:^(BOOL isSelected, NSInteger index) {
            
            if(isSelected) {
                
                [selectedGoodsArray addObject:[_getShopGoodsListDTO.ShopGoodsDTOList objectAtIndex:index]];
            }else {
                
                [selectedGoodsArray removeObject:[_getShopGoodsListDTO.ShopGoodsDTOList objectAtIndex:index]];
            }
            
        } withIndex:i withxOffsent:xOffsent];
        [chooseView.picImageView sd_setImageWithURL:[NSURL URLWithString:dto.imgUrl]];
        chooseView.priceLabel.text = [NSString stringWithFormat:@"￥%.2f", [dto.price doubleValue]];
        [pageScrollView addSubview:chooseView];

    }
    
    [self addSubview:pageScrollView];
    
    
    if (!_getShopGoodsListDTO.ShopGoodsDTOList.count) {
        UILabel *labelAlert = [[UILabel alloc] initWithFrame:CGRectMake(0, 70, Main_Screen_Width, 20)];
        labelAlert.text = @"无当前采购商所属等级可看的商品";
        labelAlert.textAlignment = NSTextAlignmentCenter;
        labelAlert.font = [UIFont systemFontOfSize:16];
        [self addSubview:labelAlert];
    }
    
    //初始化
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 180, Main_Screen_Width, 0.0)];
    pageControl.numberOfPages = pageNum;
    pageControl.currentPage = currentPage;
    pageControl.pageIndicatorTintColor = [UIColor colorWithRed:0.58 green:0.58 blue:0.58 alpha:1];
    pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:0.01 green:0.01 blue:0.01 alpha:1];
    [self addSubview:pageControl];
    
    //分割线
    UILabel * lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 190, Main_Screen_Width, 1.0f)];
    [lineLabel setBackgroundColor:[UIColor colorWithRed:0.91 green:0.91 blue:0.91 alpha:1]];
    [self addSubview:lineLabel];
    
    //发送按钮
    UIButton * sendBtn = [[UIButton alloc] initWithFrame:CGRectMake(7, 195, Main_Screen_Width - 14, 40)];
    [sendBtn setBackgroundColor:[UIColor blackColor]];
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(sendClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:sendBtn];
}

//发送按钮
- (void)sendClick:(UIButton *)sender {

    if (self.delegate) {
        if (selectedGoodsArray.count > 0) {
            [self.delegate sendButtonAction:selectedGoodsArray];
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    
    int page = pageScrollView.contentOffset.x / Main_Screen_Width;
    
    pageControl.currentPage = page;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
