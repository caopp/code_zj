//
//  ReferralsGoodsChooseView.h
//  SellerCenturySquare
//
//  Created by 王剑粟 on 15/9/21.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#define GoodsChooseViewWidth 62
#define GoodsChooseViewHeight 75

#import <UIKit/UIKit.h>

typedef void(^ReferralsGoodsChooseViewClick)(BOOL isSelected, NSInteger index);

@interface ReferralsGoodsChooseView : UIView {
    
    BOOL isSelected;
    ReferralsGoodsChooseViewClick clickBlock;
    NSInteger goodsIndex;
}

@property (nonatomic, strong) UIImageView * picImageView;

@property (nonatomic, strong) UILabel * priceLabel;

@property (nonatomic, strong) UIImageView * checkImageView;

- (instancetype)initWithBlock:(ReferralsGoodsChooseViewClick)block withIndex:(NSInteger)index withxOffsent:(float)x;

@end
