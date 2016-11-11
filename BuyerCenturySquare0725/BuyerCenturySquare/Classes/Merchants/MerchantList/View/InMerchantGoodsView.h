//
//  InMerchantGoodsView.h
//  BuyerCenturySquare
//
//  Created by 左键视觉 on 16/3/25.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InMerchantGoodsView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;


@property (weak, nonatomic) IBOutlet UILabel *goodsPriceLabel;


@property (weak, nonatomic) IBOutlet UIView *blueView;


@property (weak, nonatomic) IBOutlet UILabel *readLevelLabel;


@property (weak, nonatomic) IBOutlet UIButton *selectBtn;


//!点击按钮的事件
@property(nonatomic,copy)void(^selectBlock)();



@end
