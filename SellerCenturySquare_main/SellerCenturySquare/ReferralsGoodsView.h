//
//  ReferralsGoodsView.h
//  SellerCenturySquare
//
//  Created by 王剑粟 on 15/9/21.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetShopGoodsListDTO.h"
#import "ShopGoodsDTO.h"

@protocol ReferralsGoodsDelegate <NSObject>

//button click
- (void) sendButtonAction:(NSMutableArray *) sendGoodsArray;

@end

@interface ReferralsGoodsView : UIView <UIScrollViewDelegate>{
    
    NSInteger pageNum;
    NSInteger currentPage;
    NSMutableArray * selectedGoodsArray;
    float xOffsent;
    
    UIPageControl * pageControl;
    UIScrollView * pageScrollView;
}

@property (nonatomic, assign) id<ReferralsGoodsDelegate> delegate;

@property (nonatomic, strong) GetShopGoodsListDTO *getShopGoodsListDTO;

- (instancetype)initWithDic:(GetShopGoodsListDTO *)goodDic;

@end
