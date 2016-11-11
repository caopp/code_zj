//
//  IMModityOrder.h
//  BuyerCenturySquare
//
//  Created by 王剑粟 on 15/8/27.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMGoodsInfoDTO.h"
#import "CSPAmountControlView.h"
@protocol IMOrderDelegate <NSObject>
-(void)addBuyCar:(NSMutableArray *)arrGoods;
-(void)addUnBuyCar:(NSMutableArray *)arrGoods;
@end
@interface IMModityOrder : UIView <UIAlertViewDelegate, CSPSkuControlViewDelegate,UIGestureRecognizerDelegate> {
    
    UIImageView * checkImage;
    UIView * bgUnClickView;
    UIView *bgClickView;
    UILabel * priceLabel1;
    UIScrollView * bgModityView;
    
    UIView *bgBtnView;
    UIScrollView *colorScroll;
    UIView *detailsView;
    UILabel * priceLabel;
    UIImageView * picImage;
    UILabel * wholesale ;
    UILabel * num;
}

@property (strong, nonatomic) IMGoodsInfoDTO * imGoodsInfoDTO;
@property (strong, nonatomic) NSArray *colorItemArray;// 各种颜色 商品  IMGoodsInfoDTO
@property(nonatomic,assign)id<IMOrderDelegate>delegate;
//- (instancetype)initWithFrame:(CGRect)frame withCartDTO:(IMGoodsInfoDTO *)good;
- (instancetype)initWithFrame:(CGRect)frame withCartArrayDTO:(NSArray *)goodArray ;
//显示
- (void)IMmodityOrderShow;

//隐藏
- (void)IMmodityOrderHidden;

@end
